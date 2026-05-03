# Task scheduler - simplified version
# Just passes CSV files to JSX, no parsing needed

import logging
from pathlib import Path
from typing import List, Optional, Dict, Any

logger = logging.getLogger(__name__)


class Task:
    """Simple task representation - just holds CSV file path and action type."""

    def __init__(
        self,
        name: str,
        csv_path: Path,
        action: str = "DYNAMIC_TABLES",
        output_subfolder: str = "",
        tester_name: str = "Dynamic Tables Tester"
    ):
        self.name = name
        self.csv_path = csv_path
        self.action = action
        self.output_subfolder = output_subfolder
        self.tester_name = tester_name
        self.job_name = f"{name}-AutomatedTest"


class TaskScheduler:
    """Finds CSV files and passes them to JSX for processing.

    The original system relied on the JSX plugin to parse CSV content.
    We just need to find CSV files and pass their paths.
    """

    def __init__(
        self,
        tickets_dir: Path,
        actions_config: Optional[Dict[str, Any]] = None,
        test_defaults: Optional[Dict[str, Any]] = None
    ):
        self.tickets_dir = Path(tickets_dir)
        self.actions_config = actions_config or {}
        self.test_defaults = test_defaults or {}

    def load_tasks(self, specific_csv: Optional[str] = None) -> List[Task]:
        """Load CSV files as tasks.

        Args:
            specific_csv: Optional specific CSV filename

        Returns:
            List of Task objects (one per CSV file)
        """
        tasks = []

        if specific_csv:
            csv_files = [self.tickets_dir / specific_csv]
        else:
            csv_files = sorted(self.tickets_dir.glob("*.csv"))

        for csv_file in csv_files:
            if not csv_file.exists():
                logger.warning(f"CSV file not found: {csv_file}")
                continue

            # Determine action from filename or content
            action = self._detect_action(csv_file)

            # Get output subfolder from action config
            output_subfolder = ""
            if action in self.actions_config:
                output_subfolder = self.actions_config[action].get("processing", {}).get("output_subfolder", "")

            task = Task(
                name=csv_file.stem,
                csv_path=csv_file,
                action=action,
                output_subfolder=output_subfolder,
                tester_name=self.test_defaults.get("tester_name", "Dynamic Tables Tester")
            )
            tasks.append(task)
            logger.info(f"Loaded task: {task.name} ({task.action}) -> {csv_file}")

        return tasks

    def _detect_action(self, csv_file: Path) -> str:
        """Detect action type from CSV filename.

        Examples:
            Create-DrugsSupp.csv -> CREATE
            Extract-CFIA-test.csv -> RECOGNIZE
            Regenerate-CFIA-test.csv -> REGENERATE
        """
        name_lower = csv_file.stem.lower()

        if name_lower.startswith("create"):
            return "CREATE"
        elif name_lower.startswith("extract"):
            return "RECOGNIZE"
        elif name_lower.startswith("regenerate"):
            return "REGENERATE"
        else:
            # Default: try to detect from first line of CSV
            try:
                with open(csv_file, "r", encoding="utf-8-sig") as f:
                    first_line = f.readline().strip().upper()
                    if first_line.startswith("CREATE"):
                        return "CREATE"
                    elif first_line.startswith("RECOGNIZE"):
                        return "RECOGNIZE"
                    elif first_line.startswith("REGENERATE"):
                        return "REGENERATE"
            except Exception:
                pass

            return "UNKNOWN"
