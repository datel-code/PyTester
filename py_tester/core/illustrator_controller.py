# Illustrator controller - multiplatform COM/AppleScript interface

import logging
import subprocess
import time
from pathlib import Path
from typing import Optional

logger = logging.getLogger(__name__)


class IllustratorController:
    """Multiplatform controller for Adobe Illustrator.

    Supports:
    - Windows: COM automation via win32com
    - macOS: AppleScript via osascript
    """

    def __init__(self, config: dict, platform: Optional[str] = None):
        self.config = config
        self.version = config["version"]
        self.com_name = config["com_name"]
        self.executable = config["executable"]
        self.platform = platform or self._detect_platform()
        self._platform_controller: Optional["BaseIllustratorController"] = None
        self._app = None

    def _detect_platform(self) -> str:
        """Auto-detect platform if not provided."""
        import platform as sys_platform
        system = sys_platform.system()
        if system == "Darwin":
            return "darwin"
        elif system == "Windows":
            return "windows"
        else:
            raise OSError(f"Unsupported platform: {system}")

    def _get_controller(self):
        if self._platform_controller is None:
            if self.platform == "windows":
                self._platform_controller = WindowsIllustratorController(self.config)
            elif self.platform == "darwin":
                self._platform_controller = MacIllustratorController(self.config)
            else:
                raise OSError(f"Unsupported platform: {self.platform}")
        return self._platform_controller

    def run_jsx(self, jsx_path: Path, timeout: int = 3600) -> bool:
        """Run JSX script in Illustrator.

        Args:
            jsx_path: Path to JSX file
            timeout: Maximum time to wait for execution (not for initial launch)

        Returns:
            True if script was submitted successfully
        """
        controller = self._get_controller()
        return controller.run_jsx(jsx_path)

    def is_running(self) -> bool:
        """Check if Illustrator is still running and responsive."""
        try:
            controller = self._get_controller()
            return controller.is_running()
        except Exception:
            return False

    def kill(self) -> None:
        try:
            controller = self._get_controller()
            controller.kill()
        except Exception as e:
            logger.error(f"Failed to kill Illustrator: {e}")


class BaseIllustratorController:
    def __init__(self, config: dict):
        self.config = config
        self._app = None

    def run_jsx(self, jsx_path: Path) -> bool:
        raise NotImplementedError

    def is_running(self) -> bool:
        raise NotImplementedError

    def kill(self) -> None:
        raise NotImplementedError


class WindowsIllustratorController(BaseIllustratorController):
    """Windows implementation using win32com."""

    def __init__(self, config: dict):
        super().__init__(config)
        try:
            import win32com.client
            self.win32com = win32com.client
        except ImportError:
            raise ImportError("win32com.client required on Windows")

    def run_jsx(self, jsx_path: Path) -> bool:
        try:
            logger.info(f"Connecting to {self.config['com_name']}")
            self._app = self.win32com.Dispatch(self.config["com_name"])
            self._app.UserInteractionLevel = -1

            logger.info(f"Executing JSX: {jsx_path}")
            self._app.DoJavaScriptFile(str(jsx_path), [])
            return True

        except Exception as e:
            logger.exception("Failed to run JSX via COM")
            return False

    def is_running(self) -> bool:
        if self._app is None:
            return False
        try:
            _ = self._app.Version
            return True
        except Exception:
            return False

    def kill(self) -> None:
        import os
        os.system(f"taskkill /F /IM {self.config['executable']} /T 2>nul")
        self._app = None


class MacIllustratorController(BaseIllustratorController):
    """macOS implementation using AppleScript.

    Uses osascript to execute JSX files. The script runs asynchronously
    - we don't wait for completion here, monitoring handles that.
    """

    def __init__(self, config: dict):
        super().__init__(config)
        self._pid = None

    def run_jsx(self, jsx_path: Path) -> bool:
        """Execute JSX via AppleScript without waiting for completion.

        The AppleScript tells Illustrator to execute the JSX file.
        We don't use timeout here - the monitoring loop handles
        detecting when AI finishes or crashes.
        """
        # Build AppleScript that executes JSX and returns immediately
        # The 'do javascript' command runs asynchronously in Illustrator
        script_lines = [
            'tell application "Adobe Illustrator"',
            '    activate',
            f'    do javascript file "{jsx_path}"',
            'end tell'
        ]
        script = "\n".join(script_lines)

        try:
            logger.info(f"Submitting JSX to Illustrator: {jsx_path.name}")

            # Run AppleScript with short timeout just for submission
            # (not for waiting for completion)
            result = subprocess.run(
                ["osascript", "-e", script],
                capture_output=True,
                text=True,
                timeout=30  # 30s should be enough for AI to accept the script
            )

            if result.returncode == 0:
                logger.info("JSX submitted to Illustrator successfully")
                return True
            else:
                # Check if error is just because AI is busy (which is OK)
                stderr = result.stderr.lower()
                if "busy" in stderr or "timeout" in stderr:
                    logger.warning(f"Illustrator busy, but JSX may still run: {stderr}")
                    return True  # Assume it will run
                logger.error(f"AppleScript failed: {result.stderr}")
                return False

        except subprocess.TimeoutExpired:
            logger.warning("AppleScript submission timeout (30s)")
            # AI might still be starting up, assume it will work
            return True
        except Exception as e:
            logger.exception("AppleScript execution failed")
            return False

    def is_running(self) -> bool:
        """Check if Illustrator process exists."""
        try:
            result = subprocess.run(
                ["pgrep", "-f", "Adobe Illustrator"],
                capture_output=True,
                timeout=5
            )
            return result.returncode == 0
        except Exception:
            return False

    def kill(self) -> None:
        try:
            subprocess.run(
                ["pkill", "-f", "Adobe Illustrator"],
                capture_output=True,
                timeout=10
            )
            logger.info("Illustrator killed")
        except Exception as e:
            logger.error(f"Failed to kill Illustrator: {e}")
