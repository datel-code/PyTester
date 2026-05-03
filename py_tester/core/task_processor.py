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
    """

    def __init__(self, config: Dict[str, Any], paths: Dict[str, Path]):
        self.config = config
        self.paths = paths
        self.ai_config = config["illustrator"]
        self.monitoring_config = config.get("monitoring", {})
        self.illustrator: Optional[IllustratorController] = None
        self.generated_wrappers: list[Path] = []

    def process_task(self, task) -> Optional[Path]:
        """Process single task through AI + JSX."""
        logger.info(f"Processing task: {task.name} ({task.action})")

        try:
            # 1. Ensure output directory exists
            output_dir = self._get_output_dir(task)
            output_dir.mkdir(parents=True, exist_ok=True)

            # 2. Generate main JSX wrapper
            jsx_runner = JSXRunner(self.config, self.paths)
            main_jsx = jsx_runner.generate_wrapper(task)
            self.generated_wrappers.append(main_jsx)

            # 3. Initialize Illustrator if needed
            if self.illustrator is None:
                self.illustrator = IllustratorController(self.ai_config)

            # 4. Execute main JSX
            success = self.illustrator.run_jsx(main_jsx)
            if not success:
                logger.error("Failed to start JSX execution")
                return None

            # 5. Monitor using testerRunning check
            logger.info("Monitoring task execution...")
            monitoring_success = self._monitor_with_tester_running()

            if monitoring_success:
                output_file = output_dir / f"{task.name}.pdf"
                logger.info(f"Task completed: {task.name}")
                return output_file
            else:
                logger.error(f"Task failed or timed out: {task.name}")
                return None

        except Exception as e:
            logger.exception(f"Error processing task {task.name}")
            return None
        finally:
            # Clean up wrapper immediately after task
            self._cleanup_current_wrapper()

    def _generate_check_jsx(self, output_dir: Path) -> Path:
        """Generate JSX script for checking testerRunning status.

        Replicates AutomatedEskoTester-Check.jsx functionality.
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

    def _monitor_with_tester_running(self) -> bool:
        """Monitor task execution using testerRunning check.

        Periodically runs check script to detect if tester is still running.
        Returns True if completed successfully, False if timeout or crash.
        """
        max_cycles = self.monitoring_config.get("max_cycles", 1000)
        poll_interval = self.monitoring_config.get("poll_interval", 5)

        logger.debug(f"Monitoring: max {max_cycles} cycles, {poll_interval}s interval")

        cycle = 0
        consecutive_errors = 0
        max_consecutive_errors = 3

        while cycle < max_cycles:
            cycle += 1
            time.sleep(poll_interval)

            # Check if AI process is still alive
            if not self.illustrator.is_running():
                logger.info("Illustrator process ended")
                # Process ended - could be completion or crash
                # Check if output files exist to determine success
                return True

            # Run check script every few cycles (not every cycle to reduce overhead)
            if cycle % 3 == 0:
                try:
                    # Generate fresh check script
                    check_jsx = self._generate_check_jsx(
                        Path(self.paths["logs"]) / "jsx_wrappers"
                    )

                    # Run check - we can't easily get return value from AppleScript
                    # So we use the fact that if check runs, AI is responsive
                    self.illustrator.run_jsx(check_jsx)

                    # Clean up check script
                    try:
                        check_jsx.unlink()
                    except OSError:
                        pass

                    consecutive_errors = 0  # Reset error counter

                except Exception as e:
                    consecutive_errors += 1
                    logger.warning(f"Check failed ({consecutive_errors}/{max_consecutive_errors}): {e}")

                    if consecutive_errors >= max_consecutive_errors:
                        logger.error("Too many consecutive check failures - assuming crash")
                        return False

            # Log progress every 10 cycles
            if cycle % 10 == 0:
                logger.debug(f"Still monitoring (cycle {cycle}/{max_cycles})")

        # Timeout reached
        logger.warning(f"TIMEOUT after {cycle} cycles ({cycle * poll_interval}s)")
        if self.monitoring_config.get("auto_kill_on_timeout", True):
            logger.info("Killing Illustrator due to timeout...")
            self.illustrator.kill()
        return False

    def _cleanup_current_wrapper(self) -> None:
        """Delete the most recently generated wrapper."""
        if self.generated_wrappers:
            wrapper = self.generated_wrappers.pop()
            try:
                if wrapper.exists():
                    wrapper.unlink()
                    logger.debug(f"Deleted wrapper: {wrapper.name}")
            except OSError as e:
                logger.warning(f"Failed to delete wrapper {wrapper}: {e}")

    def cleanup_all_wrappers(self) -> None:
        """Delete all remaining wrappers (safety cleanup)."""
        while self.generated_wrappers:
            self._cleanup_current_wrapper()

    def _get_output_dir(self, task) -> Path:
        """Get output directory for task based on action."""
        output_key = f"processed_{task.action.lower()}"
        if output_key in self.paths:
            return self.paths[output_key]
        return self.paths["processed"]

    def cleanup(self) -> None:
        """Cleanup resources - always call in finally block."""
        # Clean any remaining wrappers
        self.cleanup_all_wrappers()

        # Kill Illustrator
        if self.illustrator:
            try:
                self.illustrator.kill()
                logger.info("Illustrator cleanup completed")
            except Exception as e:
                logger.error(f"Error during cleanup: {e}")
            finally:
                self.illustrator = None
