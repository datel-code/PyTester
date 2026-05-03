# Example test for PyTester

import unittest
from pathlib import Path
from core.task_scheduler import TaskScheduler, Task


class TestTaskScheduler(unittest.TestCase):
    """Test cases for TaskScheduler."""

    def test_task_creation(self):
        """Test basic task creation."""
        task = Task(
            name="test_0001",
            action="RECOGNIZE",
            file_path=Path("/test/file.ai"),
            table_type="CFIA",
            version="1.0"
        )
        self.assertEqual(task.name, "test_0001")
        self.assertEqual(task.action, "RECOGNIZE")
        self.assertEqual(task.job_name, "test_0001-AutomatedTest")

    def test_task_with_defaults(self):
        """Test task with default parameters."""
        defaults = {
            "tester_name": "Dynamic Tables Tester",
            "process_subfolder": True,
            "mask": "*.pdf"
        }
        task = Task(
            name="test_0002",
            action="EXTRACT",
            file_path=Path("/test/file.pdf"),
            table_type="FDA",
            version="2.0",
            tester_name=defaults["tester_name"],
            process_subfolder=defaults["process_subfolder"],
            mask=defaults["mask"],
            test_params=defaults
        )
        self.assertTrue(task.process_subfolder)
        self.assertEqual(task.mask, "*.pdf")


if __name__ == "__main__":
    unittest.main()
