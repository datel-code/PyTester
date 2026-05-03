# Operation-aware task scheduler

import csv
import logging
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path
from typing import Dict, Any, List, Optional, Tuple

logger = logging.getLogger(__name__)


@dataclass
class OperationTask:
    """Task with operation-specific context.

    Extends base Task with operation configuration from YAML.
    """
    name: str
    operation: str                    # CREATE, RECOGNIZE, REGENERATE
    input_file: Path
    table_type: str
    version: str
    language: Optional[str] = None

    # Operation config from YAML
    operation_config: Dict[str, Any] = field(default_factory=dict)

    # Resolved paths
    input_dir: Optional[Path] = None
    output_dir: Optional[Path] = None

    # Standard task fields
    tester_name: str = "Dynamic Tables Tester"
    job_name: str = ""
    timestamp: datetime = field(default_factory=datetime.now)
    test_params: Dict[str, Any] = field(default_factory=dict)

    def __post_init__(self):
        if not self.job_name:
            self.job_name = f"{self.operation}_{self.name}-AutomatedTest"


class OperationScheduler:
    """Schedules tasks based on operation type from CSV.

    Reads CSV files and routes each row to appropriate operation handler
    based on the action column. Each operation has its own configuration
    for input sources, output destinations, and parameters.
    """

    def __init__(
        self,
        tickets_dir: Path,
        operations_config: Dict[str, Any],
        base_path: Path,
        test_defaults: Optional[Dict[str, Any]] = None
    ):
        """Initialize operation scheduler.

        Args:
            tickets_dir: Directory containing CSV task files
            operations_config: Operation definitions from YAML
            base_path: Base directory for resolving paths
            test_defaults: Default test parameters
        """
        self.tickets_dir = Path(tickets_dir)
        self.operations_config = operations_config
        self.base_path = Path(base_path)
        self.test_defaults = test_defaults or {}

    def load_tasks(self, specific_csv: Optional[str] = None) -> List[OperationTask]:
        """Load all tasks from CSV files.

        Parses CSV and creates OperationTask for each row,
        applying operation-specific configuration.

        Args:
            specific_csv: Optional specific CSV filename

        Returns:
            List of OperationTask objects
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

            logger.info(f"Loading tasks from: {csv_file}")
            try:
                file_tasks = self._parse_csv(csv_file)
                tasks.extend(file_tasks)
                logger.info(
                    f"Loaded {len(file_tasks)} tasks from {csv_file.name}"
                )
            except Exception as e:
                logger.error(f"Failed to parse {csv_file}: {e}")

        return tasks

    def _parse_csv(self, csv_path: Path) -> List[OperationTask]:
        """Parse CSV file into operation tasks.

        Determines operation from first column and applies
        operation-specific configuration.

        Args:
            csv_path: Path to CSV file

        Returns:
            List of OperationTask objects
        """
        tasks = []

        with open(csv_path, "r", encoding="utf-8-sig") as f:
            reader = csv.reader(f, delimiter=";")

            for row_num, row in enumerate(reader, 1):
                if len(row) < 2:
                    logger.warning(
                        f"Skipping invalid row {row_num} in {csv_path}: "
                        f"expected at least 2 columns, got {len(row)}"
                    )
                    continue

                # First column is the operation
                operation = row[0].strip().upper()

                # Validate operation
                if operation not in self.operations_config:
                    logger.warning(
                        f"Unknown operation '{operation}' in row {row_num}, "
                        f"skipping. Known operations: "
                        f"{list(self.operations_config.keys())}"
                    )
                    continue

                # Get operation configuration
                op_config = self.operations_config[operation]

                # Parse row based on operation's CSV column mapping
                task = self._parse_operation_row(
                    operation=operation,
                    op_config=op_config,
                    row=row,
                    row_num=row_num,
                    csv_path=csv_path
                )

                if task:
                    tasks.append(task)

        return tasks

    def _parse_operation_row(
        self,
        operation: str,
        op_config: Dict[str, Any],
        row: List[str],
        row_num: int,
        csv_path: Path
    ) -> Optional[OperationTask]:
        """Parse a single CSV row into OperationTask.

        Args:
            operation: Operation name (CREATE, RECOGNIZE, REGENERATE)
            op_config: Operation configuration from YAML
            row: CSV row data
            row_num: Row number for logging
            csv_path: Source CSV file path

        Returns:
            OperationTask or None if parsing fails
        """
        csv_columns = op_config.get("csv_columns", [])

        # Need at least action + input file
        if len(row) < 2:
            logger.warning(
                f"Row {row_num}: insufficient columns for {operation}"
            )
            return None

        # Extract fields based on column mapping
        # Column 0 is always action
        # Column 1 is always input file path
        input_file_str = row[1].strip() if len(row) > 1 else ""
        table_type = row[2].strip() if len(row) > 2 else ""
        version = row[3].strip() if len(row) > 3 else ""
        language = row[4].strip() if len(row) > 4 else None

        if not input_file_str:
            logger.warning(
                f"Row {row_num}: missing input file for {operation}"
            )
            return None

        # Resolve input file path
        input_file = Path(input_file_str)

        # If relative, resolve against operation's input directory
        if not input_file.is_absolute():
            input_subdir = op_config.get("input", {}).get("source_subdir", "")
            input_dir = self.base_path / input_subdir
            input_file = input_dir / input_file_str

        # Resolve output directory
        output_subdir = op_config.get("output", {}).get("subdir", "Processed")
        output_dir = self.base_path / output_subdir

        # Create task
        task = OperationTask(
            name=f"{csv_path.stem}_{row_num:04d}",
            operation=operation,
            input_file=input_file,
            table_type=table_type,
            version=version,
            language=language,
            operation_config=op_config,
            input_dir=input_file.parent,
            output_dir=output_dir,
            tester_name=self.test_defaults.get(
                "tester_name", "Dynamic Tables Tester"
            ),
            test_params=self.test_defaults
        )

        logger.debug(
            f"Created task: {task.name} [{task.operation}] "
            f"input={task.input_file} output={task.output_dir}"
        )

        return task

    def get_operations_summary(self, tasks: List[OperationTask]) -> Dict[str, int]:
        """Get summary of tasks by operation.

        Args:
            tasks: List of tasks

        Returns:
            Dictionary mapping operation name to count
        """
        summary = {}
        for task in tasks:
            summary[task.operation] = summary.get(task.operation, 0) + 1
        return summary
