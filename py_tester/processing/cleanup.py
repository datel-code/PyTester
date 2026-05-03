# Cleanup manager - removes old processed outputs

import logging
from pathlib import Path
from typing import Optional

logger = logging.getLogger(__name__)


class CleanupManager:
    """Manages cleanup of old processed output files.

    Replaces the original G_CLEANUP_PROCESSED batch function.
    """

    def __init__(self, processed_dir: Path):
        """Initialize cleanup manager.

        Args:
            processed_dir: Directory containing processed outputs
        """
        self.processed_dir = Path(processed_dir)

    def cleanup_for_task(self, task) -> None:
        """Clean up old outputs for specific task.

        Args:
            task: Task object to clean up for
        """
        if not self.processed_dir.exists():
            return

        # Clean files matching task name pattern
        pattern = f"{task.name}*"
        removed = 0

        for file_path in self.processed_dir.glob(pattern):
            try:
                if file_path.is_file():
                    file_path.unlink()
                    removed += 1
                    logger.debug(f"Removed: {file_path}")
                elif file_path.is_dir():
                    # Optionally remove directories
                    pass
            except OSError as e:
                logger.warning(f"Failed to remove {file_path}: {e}")

        if removed > 0:
            logger.info(f"Cleaned up {removed} old files for task {task.name}")

    def cleanup_all(self, pattern: str = "*") -> int:
        """Clean up all processed files matching pattern.

        Args:
            pattern: Glob pattern for files to remove

        Returns:
            Number of files removed
        """
        if not self.processed_dir.exists():
            return 0

        removed = 0
        for file_path in self.processed_dir.glob(pattern):
            try:
                if file_path.is_file():
                    file_path.unlink()
                    removed += 1
            except OSError as e:
                logger.warning(f"Failed to remove {file_path}: {e}")

        logger.info(f"Cleaned up {removed} files from {self.processed_dir}")
        return removed
