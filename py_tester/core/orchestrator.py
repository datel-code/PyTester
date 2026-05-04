# Main orchestrator - supports automatic and manual modes, multi-platform

import logging
import platform as sys_platform
from pathlib import Path
from typing import List, Optional, Dict, Any

import yaml

from core.illustrator_controller import IllustratorController
from core.jsx_runner import JSXRunner
from core.task_scheduler import TaskScheduler
from core.task_processor import TaskProcessor
from comparison.nmt_wrapper import NMTWrapper
from utils.path_utils import resolve_root
from utils.path_validator import PathValidator, PathValidationError

logger = logging.getLogger(__name__)


def _deep_merge(base: dict, override: dict) -> dict:
    """Recursively merge override dict into base dict (in-place copy)."""
    result = base.copy()
    for key, value in override.items():
        if key in result and isinstance(result[key], dict) and isinstance(value, dict):
            result[key] = _deep_merge(result[key], value)
        else:
            result[key] = value
    return result


class TabTesterOrchestrator:
    """Main orchestrator with automatic and manual operation modes.

    Workflow:
    1. Validate paths
    2. Load CSV tasks
    3. Process all tasks (AI + JSX)
    4. Run NMT comparison (after all processing)
    5. Generate reports

    Modes:
    - automatic: Runs all steps without interaction
    - manual: Each step requires user confirmation (with skip option)

    Platform:
    - auto: Detected from OS
    - darwin / windows: Explicit override via CLI --platform
    """

    def __init__(
        self,
        config_path: str,
        script_dir: Optional[Path] = None,
        manual_mode: bool = False,
        platform: str = "auto"
    ):
        self.config_path = Path(config_path)
        with open(self.config_path, "r", encoding="utf-8") as f:
            raw_config = yaml.safe_load(f)

        self.script_dir = script_dir or self.config_path.parent.parent
        self.topic = raw_config["system"]["main_topic"]
        self.actions_config = raw_config.get("actions", {})
        self.manual_mode = manual_mode

        # Resolve platform and merge overrides
        self.platform = self._resolve_platform(platform)
        self.config = self._apply_platform_overrides(raw_config, self.platform)

        self.paths = self._resolve_paths()
        self.task_processor: Optional[TaskProcessor] = None
        self.processed_files: List[Path] = []
        self.comparison_results: List[Dict[str, Any]] = []

    def _resolve_platform(self, platform_arg: str) -> str:
        """Resolve platform string."""
        if platform_arg == "auto":
            system = sys_platform.system()
            if system == "Darwin":
                return "darwin"
            elif system == "Windows":
                return "windows"
            else:
                raise OSError(f"Unsupported platform: {system}")
        return platform_arg

    def _apply_platform_overrides(self, config: dict, platform: str) -> dict:
        """Deep-merge platform-specific overrides into base config."""
        overrides = config.get("platform_overrides", {})
        if platform in overrides:
            logger.info(f"Applying platform overrides for: {platform}")
            merged = _deep_merge(config, overrides[platform])
            return merged
        logger.info(f"No platform overrides found for: {platform}")
        return config

    def _resolve_paths(self) -> Dict[str, Path]:
        """Resolve all paths from configuration."""
        root = resolve_root(self.config["system"], self.script_dir)

        folder = self.config["system"].get("tester_folder", "")
        base = root / folder if folder else root

        logger.info(f"Base path: {base}")

        paths_config = self.config.get("paths", {})
        validator = PathValidator(paths_config, base)

        success, errors = validator.validate_all()
        if not success:
            raise PathValidationError(
                f"Required directories missing:\n" + "\n".join(errors)
            )

        for action_name, action_config in self.actions_config.items():
            source_config = action_config.get("source", {})
            if source_config.get("required", False):
                source_folder = base / source_config.get("folder", "")
                if not source_folder.exists():
                    raise PathValidationError(
                        f"Source folder missing for {action_name}: {source_folder}"
                    )

        validator.print_summary()

        all_paths = validator.get_all_paths()

        for action_name, action_config in self.actions_config.items():
            source_folder = action_config.get("source", {}).get("folder", "")
            if source_folder:
                all_paths[f"source_{action_name.lower()}"] = base / source_folder

            ref_folder = action_config.get("reference", {}).get("folder", "")
            if ref_folder:
                all_paths[f"reference_{action_name.lower()}"] = base / ref_folder

        processed_base = all_paths.get("processed", base / "Processed")
        for action_name in self.actions_config.keys():
            action_config = self.actions_config[action_name]
            subfolder = action_config.get("processing", {}).get("output_subfolder", "")
            if subfolder:
                all_paths[f"processed_{action_name.lower()}"] = processed_base / subfolder

        return all_paths

    def _confirm(self, step_name: str, description: str) -> bool:
        """Ask for confirmation in manual mode.

        Returns:
            True to proceed, False to skip
        """
        if not self.manual_mode:
            return True

        print(f"\n{'='*60}")
        print(f"STEP: {step_name}")
        print(f"{'='*60}")
        print(f"{description}")
        print()

        while True:
            response = input("Run this step? [y/n]: ").strip().lower()
            if response in ('y', 'yes'):
                return True
            elif response in ('n', 'no', 's', 'skip'):
                print(f" -> Skipped: {step_name}")
                return False
            else:
                print("Please enter 'y' (yes) or 'n' (no/skip)")

    def run(
        self,
        topic: Optional[str] = None,
        specific_csv: Optional[str] = None,
        dry_run: bool = False
    ) -> bool:
        """Execute complete testing workflow."""
        topic = topic or self.topic

        try:
            mode_str = "MANUAL" if self.manual_mode else "AUTOMATIC"
            logger.info(f"=== Starting PyTester - {topic} ({mode_str}) ===")
            logger.info(f"Platform: {self.platform}")

            # Pre-clean old wrappers to avoid accumulation from previous runs
            try:
                jsx_runner = JSXRunner(self.config, self.paths, self.platform)
                deleted = jsx_runner.cleanup_old_wrappers(max_age_hours=1)
                if deleted:
                    logger.info(f"Pre-run cleanup: removed {deleted} stale wrapper(s)")
            except Exception as e:
                logger.warning(f"Pre-run wrapper cleanup failed: {e}")

            # Step 1: Initialize
            logger.info("Step 1: Initialize")
            self.task_processor = TaskProcessor(self.config, self.paths, self.platform)

            # Step 2: Load tasks
            if not self._confirm("LOAD TASKS",
                                 f"Load CSV task files from: {self.paths['tickets']}"):
                logger.info("Load tasks skipped")
                return True

            scheduler = TaskScheduler(
                self.paths["tickets"],
                self.actions_config,
                self.config.get("test_defaults", {})
            )
            tasks = scheduler.load_tasks(specific_csv)

            if not tasks:
                logger.warning("No CSV files found")
                return True

            logger.info(f"Found {len(tasks)} CSV files")
            for task in tasks:
                logger.info(f" - {task.name} ({task.action})")

            # Step 3: Process all tasks
            if not dry_run:
                if self._confirm("PROCESS TASKS",
                                 f"Process {len(tasks)} tasks through Illustrator?"):

                    logger.info("Step 3: Processing tasks")
                    for i, task in enumerate(tasks, 1):
                        logger.info(f" [{i}/{len(tasks)}] {task.name}")
                        result = self.task_processor.process_task(task)
                        if result:
                            self.processed_files.append(result)
                            logger.info(f" Generated: {result.name}")
                else:
                    logger.info("Processing skipped")
            else:
                logger.info("DRY RUN: Would process:")
                for task in tasks:
                    logger.info(f" - {task.name}")

            # Step 4: NMT Comparison
            if self.processed_files and not dry_run:
                if self._confirm("NMT COMPARISON",
                                 f"Compare {len(self.processed_files)} files with NMT?"):

                    logger.info("Step 4: NMT Comparison")
                    self._run_comparison()
                else:
                    logger.info("Comparison skipped")

            # Step 5: Reporting
            if not dry_run:
                if self._confirm("REPORTING",
                                 "Generate test reports?"):

                    logger.info("Step 5: Generate reports")
                    self._generate_reports()
                else:
                    logger.info("Reporting skipped")

            logger.info("=== PyTester completed ===")
            return True

        except PathValidationError as e:
            logger.error(f"Path validation failed: {e}")
            return False
        except Exception as e:
            logger.exception("PyTester failed")
            return False
        finally:
            if self.task_processor:
                self.task_processor.cleanup()

    def _run_comparison(self) -> None:
        """Run NMT comparison on all processed files."""
        logger.info(f"Comparing {len(self.processed_files)} files")
        self.comparison_results = []

        try:
            nmt = NMTWrapper(self.config, self.paths, self.platform)

            for proc_file in self.processed_files:
                relative = proc_file.relative_to(self.paths["processed"])
                ref_file = self.paths.get("reference",
                                          self.paths["processed"].parent / "Reference") / relative

                if not ref_file.exists():
                    logger.warning(f"Reference not found: {ref_file}")
                    self.comparison_results.append({
                        "task_name": proc_file.stem,
                        "success": False,
                        "error": "Reference file missing",
                        "candidate": proc_file,
                        "reference": ref_file
                    })
                    continue

                logger.info(f"Comparing: {proc_file.name} vs {ref_file.name}")
                result = nmt.compare_task(
                    candidate=proc_file,
                    reference=ref_file,
                    task_name=proc_file.stem
                )
                self.comparison_results.append(result)

                if result.get("success"):
                    logger.info(f" Passed: {proc_file.name}")
                else:
                    logger.error(f" Failed: {proc_file.name}")
                    if "error" in result:
                        logger.error(f" Error: {result['error']}")

        except Exception as e:
            logger.exception("Comparison failed")

    def _generate_reports(self) -> None:
        """Generate summary test reports.

        Writes a simple JSON summary and plain-text log of results.
        Full XSLT/HTML reporting can be added later.
        """
        import json
        from datetime import datetime

        reports_dir = self.paths.get("reports", self.paths["processed"].parent / "Reports")
        reports_dir.mkdir(parents=True, exist_ok=True)

        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

        # JSON summary
        summary = {
            "topic": self.topic,
            "platform": self.platform,
            "timestamp": timestamp,
            "processed_count": len(self.processed_files),
            "comparison_count": len(self.comparison_results),
            "passed": sum(1 for r in self.comparison_results if r.get("success")),
            "failed": sum(1 for r in self.comparison_results if not r.get("success")),
            "results": [
                {
                    "task": r.get("task_name"),
                    "success": r.get("success"),
                    "error": r.get("error", None)
                }
                for r in self.comparison_results
            ]
        }

        json_path = reports_dir / f"summary_{timestamp}.json"
        json_path.write_text(json.dumps(summary, indent=2), encoding="utf-8")
        logger.info(f"JSON report: {json_path}")

        # Plain text summary
        txt_path = reports_dir / f"summary_{timestamp}.txt"
        lines = [
            f"PyTester Report - {self.topic}",
            f"Platform: {self.platform}",
            f"Generated: {timestamp}",
            f"Processed: {summary['processed_count']} files",
            f"Compared:  {summary['comparison_count']} files",
            f"Passed:    {summary['passed']}",
            f"Failed:    {summary['failed']}",
            "",
            "Details:",
            "-" * 40
        ]
        for r in summary["results"]:
            status = "PASS" if r["success"] else "FAIL"
            lines.append(f"  [{status}] {r['task']}")
            if r["error"]:
                lines.append(f"       Error: {r['error']}")
        lines.append("-" * 40)

        txt_path.write_text("\n".join(lines), encoding="utf-8")
        logger.info(f"Text report: {txt_path}")
