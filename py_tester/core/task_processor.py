# Task processor - handles individual test task execution

import logging
import time
from pathlib import Path
from typing import Optional, Dict, Any

from core.illustrator_controller import IllustratorController
from core.jsx_runner import JSXRunner

logger = logging.getLogger(__name__)


class TaskProcessor:
    """Processes individual test tasks through Adobe Illustrator.

    Uses testerRunning check (like original VBS) to detect completion:
    - Periodically runs check JSX script
    - Returns 1 = running, 0 = completed
    - Handles timeout and crash detection
    - Validates output file existence before declaring success
    """

    def __init__(
        self,
        config: Dict[str, Any],
        paths: Dict[str, Path],
        platform: Optional[str] = None
    ):
        self.config = config
        self.paths = paths
        self.ai_config = config["illustrator"]
        self.monitoring_config = config.get("monitoring", {})
        self.platform = platform
        self.illustrator: Optional[IllustratorController] = None
        self.generated_wrappers: list[Path] = []
        self.generated_checks: list[Path] = []

    def process_task(self, task) -> Optional[Path]:
        """Process single task through AI + JSX.

        Returns the expected output file path if the task completes
        successfully, otherwise None.
        """
        logger.info(f"Processing task: {task.name} ({task.action})")
        expected_output: Optional[Path] = None

        try:
            # 1. Ensure output directory exists
            output_dir = self._get_output_dir(task)
            output_dir.mkdir(parents=True, exist_ok=True)

            # 2. Determine expected output file for later validation
            expected_output = output_dir / f"{task.name}.pdf"

            # 3. Generate main JSX wrapper
            jsx_runner = JSXRunner(self.config, self.paths, self.platform)
            main_jsx = jsx_runner.generate_wrapper(task)
            self.generated_wrappers.append(main_jsx)

            # 4. Initialize Illustrator if needed
            if self.illustrator is None:
                self.illustrator = IllustratorController(self.ai_config, self.platform)

            # 5. Execute main JSX
            success = self.illustrator.run_jsx(main_jsx)
            if not success:
                logger.error("Failed to start JSX execution")
                return None

            # 6. Monitor using testerRunning check
            logger.info("Monitoring task execution...")
            monitoring_success = self._monitor_with_tester_running(expected_output)

            if monitoring_success:
                logger.info(f"Task completed: {task.name}")
                return expected_output
            else:
                logger.error(f"Task failed or timed out: {task.name}")
                return None

        except Exception as e:
            logger.exception(f"Error processing task {task.name}")
            return None
        finally:
            # Always clean up temporary scripts, even on crash or timeout
            self._cleanup_all_temp_scripts()

    def _generate_check_jsx(self, output_dir: Path) -> Path:
        """Generate JSX script for checking testerRunning status.

        Replicates AutomatedEskoTester-Check.jsx functionality.
        Returns 1 if running, 0 if completed or error.
        """
        check_jsx_content = r"""#target illustrator-[[ai_version]]
// Check script - returns scripter.testerRunning value
// 1 = running, 0 = completed or error

app.userInteractionLevel = UserInteractionLevel.DONTDISPLAYALERTS;

try {
    if (typeof scripter !== 'undefined' && scripter !== null) {
        var running = scripter.testerRunning;
        $.writeln("CHECK: testerRunning = " + running);
        running;
    } else {
        $.writeln("CHECK: scripter not defined - assuming completed");
        0;
    }
} catch(err) {
    $.writeln("CHECK ERROR: " + err);
    0;
}
"""
        # Replace version placeholder
        check_jsx_content = check_jsx_content.replace(
            "[[ai_version]]",
            self.ai_config.get("version", "30")
        )

        check_path = output_dir / f"check_{int(time.time())}.jsx"
        check_path.write_text(check_jsx_content, encoding="utf-8")
        return check_path

    def _monitor_with_tester_running(self, expected_output: Optional[Path]) -> bool:
        """Monitor task execution using testerRunning check.

        Periodically runs check script to detect if tester is still running.
        Also monitors output file growth to detect completion when the
        testerRunning variable is no longer accessible.

        Args:
            expected_output: Path to the expected output file for validation.

        Returns:
            True if completed successfully, False if timeout or crash.
        """
        max_cycles = self.monitoring_config.get("max_cycles", 1000)
        poll_interval = self.monitoring_config.get("poll_interval", 5)
        auto_kill = self.monitoring_config.get("auto_kill_on_timeout", True)

        logger.debug(f"Monitoring: max {max_cycles} cycles, {poll_interval}s interval")

        cycle = 0
        consecutive_errors = 0
        max_consecutive_errors = 3
        last_file_size = -1
        stable_size_cycles = 0

        while cycle < max_cycles:
            cycle += 1
            time.sleep(poll_interval)

            # Check if AI process is still alive
            if not self.illustrator.is_running():
                logger.info("Illustrator process ended")
                # Process ended - validate output to distinguish crash from completion
                if self._validate_output(expected_output):
                    return True
                else:
                    logger.error("Illustrator terminated but output file is missing or empty")
                    return False

            # Run check script every few cycles (not every cycle to reduce overhead)
            if cycle % 3 == 0:
                try:
                    check_jsx = self._generate_check_jsx(
                        Path(self.paths["logs"]) / "jsx_wrappers"
                    )
                    self.generated_checks.append(check_jsx)

                    # Execute check - on macOS we cannot read the return value easily,
                    # so we treat a successful execution as "still responsive".
                    self.illustrator.run_jsx(check_jsx)
                    consecutive_errors = 0

                except Exception as e:
                    consecutive_errors += 1
                    logger.warning(f"Check failed ({consecutive_errors}/{max_consecutive_errors}): {e}")

                    if consecutive_errors >= max_consecutive_errors:
                        logger.error("Too many consecutive check failures - assuming crash")
                        if auto_kill:
                            self.illustrator.kill()
                        return False

            # Detect completion by monitoring output file size stability
            # This is a fallback when testerRunning is not available
            if expected_output and expected_output.exists():
                current_size = expected_output.stat().st_size
                if current_size == last_file_size and current_size > 0:
                    stable_size_cycles += 1
                    # If file size is stable for 3 consecutive checks (~15s), assume done
                    if stable_size_cycles >= 3:
                        logger.info("Output file size stable - assuming completion")
                        return True
                else:
                    stable_size_cycles = 0
                last_file_size = current_size

            # Log progress every 10 cycles
            if cycle % 10 == 0:
                logger.debug(f"Still monitoring (cycle {cycle}/{max_cycles})")

        # Timeout reached
        logger.warning(f"TIMEOUT after {cycle} cycles ({cycle * poll_interval}s)")
        if auto_kill:
            logger.info("Killing Illustrator due to timeout...")
            self.illustrator.kill()
        return False

    def _validate_output(self, expected_output: Optional[Path]) -> bool:
        """Validate that the expected output file exists and is non-empty.

        Args:
            expected_output: Path to the expected output file.

        Returns:
            True if the file exists and has content, False otherwise.
        """
        if expected_output is None:
            return False
        if not expected_output.exists():
            logger.warning(f"Expected output not found: {expected_output}")
            return False
        size = expected_output.stat().st_size
        if size == 0:
            logger.warning(f"Output file is empty: {expected_output}")
            return False
        logger.info(f"Output validated: {expected_output.name} ({size} bytes)")
        return True

    def _cleanup_all_temp_scripts(self) -> None:
        """Delete all temporary JSX scripts (wrappers and check scripts)."""
        # Clean wrappers
        while self.generated_wrappers:
            wrapper = self.generated_wrappers.pop()
            try:
                if wrapper.exists():
                    wrapper.unlink()
                    logger.debug(f"Deleted wrapper: {wrapper.name}")
            except OSError as e:
                logger.warning(f"Failed to delete wrapper {wrapper}: {e}")

        # Clean check scripts
        while self.generated_checks:
            check = self.generated_checks.pop()
            try:
                if check.exists():
                    check.unlink()
                    logger.debug(f"Deleted check script: {check.name}")
            except OSError as e:
                logger.warning(f"Failed to delete check script {check}: {e}")

    def _get_output_dir(self, task) -> Path:
        """Get output directory for task based on action type."""
        output_key = f"processed_{task.action.lower()}"
        if output_key in self.paths:
            return self.paths[output_key]
        return self.paths["processed"]

    def cleanup(self) -> None:
        """Cleanup resources - always call in finally block."""
        # Clean any remaining temp scripts
        self._cleanup_all_temp_scripts()

        # Kill Illustrator
        if self.illustrator:
            try:
                self.illustrator.kill()
                logger.info("Illustrator cleanup completed")
            except Exception as e:
                logger.error(f"Error during cleanup: {e}")
            finally:
                self.illustrator = None
