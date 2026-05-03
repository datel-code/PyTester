# NMT wrapper - handles comparison using NDLModelTest

import logging
import subprocess
from pathlib import Path
from typing import Dict, Any, Optional, List
import xml.etree.ElementTree as ET

logger = logging.getLogger(__name__)


class NMTWrapper:
    """Wrapper for NDLModelTest comparison engine.

    Replaces CMPNMT.bat functionality.
    Uses NDLModelTestDriver and NDLModelTestReporter.

    Paths:
    - macOS: /Applications/NDLModelTest.app/Contents/MacOS/NDLModelTestDriver
    - Windows: NMTROOT\\NDLModelTest.app\\Contents\\Windows\\NDLModelTestDriver.exe
    """

    def __init__(self, config: Dict[str, Any], paths: Dict[str, Path]):
        self.config = config
        self.paths = paths
        self.comparison_config = config.get("comparison", {})

        # Determine platform-specific paths
        import platform
        if platform.system() == "Darwin":
            self.nmt_driver = "/Applications/NDLModelTest.app/Contents/MacOS/NDLModelTestDriver"
            self.nmt_reporter = "/Applications/NDLModelTest.app/Contents/MacOS/NDLModelTestReporter"
        else:
            nmt_root = config.get("nmt_root", "")
            self.nmt_driver = nmt_root + "\\NDLModelTest.app\\Contents\\Windows\\NDLModelTestDriver.exe"
            self.nmt_reporter = nmt_root + "\\NDLModelTest.app\\Contents\\Windows\\NDLModelTestReporter.exe"

    def compare_task(
        self,
        candidate: Path,
        reference: Path,
        task_name: str,
        testq_template: Optional[Path] = None
    ) -> Dict[str, Any]:
        """Compare candidate vs reference using NMT.

        Args:
            candidate: Path to processed output file
            reference: Path to reference file
            task_name: Name for this comparison task
            testq_template: Optional TestQ template file

        Returns:
            Dictionary with comparison results
        """
        logger.info(f"NMT comparison: {task_name}")

        # Generate TestQ file
        testq_path = self._generate_testq(
            candidate=candidate,
            reference=reference,
            task_name=task_name,
            template=testq_template
        )

        # Run NMT Driver
        try:
            cmd = [
                self.nmt_driver,
                "-testq", str(testq_path),
                "-compare",
                "-dpi", str(self.comparison_config.get("dpi", 300)),
                "-tolerance", str(self.comparison_config.get("tolerance", 0.01))
            ]

            logger.debug(f"NMT command: {' '.join(cmd)}")

            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=3600,
                cwd=str(self.paths.get("testq", "."))
            )

            success = result.returncode == 0

            # Generate report
            report_path = None
            if success:
                report_path = self._generate_report(testq_path)

            return {
                "task_name": task_name,
                "testq": testq_path,
                "candidate": candidate,
                "reference": reference,
                "success": success,
                "stdout": result.stdout,
                "stderr": result.stderr,
                "report": report_path
            }

        except subprocess.TimeoutExpired:
            logger.error("NMT comparison timeout")
            return {
                "task_name": task_name,
                "success": False,
                "error": "timeout"
            }
        except Exception as e:
            logger.exception("NMT comparison failed")
            return {
                "task_name": task_name,
                "success": False,
                "error": str(e)
            }

    def _generate_testq(
        self,
        candidate: Path,
        reference: Path,
        task_name: str,
        template: Optional[Path] = None
    ) -> Path:
        """Generate TestQ XML file for comparison.

        Uses shared ticket files:
        - ImageCompare.ticket
        - IRender500.ticket

        Or creates basic comparison task.
        """
        root = ET.Element("testq")
        root.set("version", "1.0")

        # Add shared tickets if available
        testq_dir = self.paths.get("testq", Path("."))

        # ImageCompare ticket
        image_compare = testq_dir / "ImageCompare.ticket"
        if image_compare.exists():
            self._include_ticket(root, image_compare)

        # IRender500 ticket
        render500 = testq_dir / "IRender500.ticket"
        if render500.exists():
            self._include_ticket(root, render500)

        # Main comparison task
        task = ET.SubElement(root, "task")
        task.set("name", task_name)
        task.set("type", "compare")

        ref_elem = ET.SubElement(task, "reference")
        ref_elem.text = str(reference)

        cand_elem = ET.SubElement(task, "candidate")
        cand_elem.text = str(candidate)

        tol_elem = ET.SubElement(task, "tolerance")
        tol_elem.text = str(self.comparison_config.get("tolerance", 0.01))

        # Pretty print
        self._indent(root)

        # Save
        from datetime import datetime
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        testq_path = testq_dir / f"{task_name}_{timestamp}.testq"

        tree = ET.ElementTree(root)
        tree.write(testq_path, encoding="utf-8", xml_declaration=True)

        logger.info(f"Generated TestQ: {testq_path}")
        return testq_path

    def _include_ticket(self, root: ET.Element, ticket_path: Path) -> None:
        """Include shared ticket file in TestQ."""
        try:
            ticket_tree = ET.parse(str(ticket_path))
            ticket_root = ticket_tree.getroot()

            # Copy all child elements
            for child in ticket_root:
                root.append(child)

        except Exception as e:
            logger.warning(f"Failed to include ticket {ticket_path}: {e}")

    def _generate_report(self, testq_path: Path) -> Optional[Path]:
        """Generate HTML report from TestQ results."""
        try:
            report_path = testq_path.with_suffix(".report.html")

            cmd = [
                self.nmt_reporter,
                "-testq", str(testq_path),
                "-output", str(report_path)
            ]

            subprocess.run(cmd, capture_output=True, timeout=300)

            if report_path.exists():
                logger.info(f"Generated report: {report_path}")
                return report_path

        except Exception as e:
            logger.warning(f"Report generation failed: {e}")

        return None

    def _indent(self, elem, level=0):
        """Pretty print XML."""
        i = "\n" + level * "  "
        if len(elem):
            if not elem.text or not elem.text.strip():
                elem.text = i + "  "
            if not elem.tail or not elem.tail.strip():
                elem.tail = i
            for child in elem:
                self._indent(child, level + 1)
            if not elem.tail or not elem.tail.strip():
                elem.tail = i
        else:
            if level and (not elem.tail or not elem.tail.strip()):
                elem.tail = i


class ComparisonOrchestrator:
    """Orchestrates comparison of all processed files against references."""

    def __init__(self, config: Dict[str, Any], paths: Dict[str, Path]):
        self.nmt = NMTWrapper(config, paths)
        self.paths = paths

    def compare_all(self, processed_files: List[Path]) -> List[Dict[str, Any]]:
        """Compare all processed files against references.

        Args:
            processed_files: List of processed output files

        Returns:
            List of comparison results
        """
        results = []

        for proc_file in processed_files:
            # Determine reference path based on action subfolder
            relative = proc_file.relative_to(self.paths["processed"])
            ref_file = self.paths.get("reference", 
                self.paths["processed"].parent / "Reference") / relative

            if not ref_file.exists():
                logger.warning(f"Reference not found: {ref_file}")
                continue

            result = self.nmt.compare_task(
                candidate=proc_file,
                reference=ref_file,
                task_name=proc_file.stem
            )
            results.append(result)

        return results
