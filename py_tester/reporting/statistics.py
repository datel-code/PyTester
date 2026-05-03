# Statistics aggregator - aggregates comparison results into XML

import logging
from pathlib import Path
from typing import Dict, Any, List
from datetime import datetime
import xml.etree.ElementTree as ET

logger = logging.getLogger(__name__)


class StatisticsAggregator:
    """Aggregates comparison statistics into XML report.

    Replaces the original STAT.bat functionality.
    """

    def __init__(self, paths: Dict[str, Path]):
        """Initialize statistics aggregator.

        Args:
            paths: Dictionary of resolved paths
        """
        self.paths = paths

    def aggregate(self, comparison_results: List[Dict[str, Any]]) -> Path:
        """Aggregate comparison results into XML statistics.

        Args:
            comparison_results: List of comparison result dictionaries

        Returns:
            Path to generated XML file
        """
        root = ET.Element("test-results")
        root.set("timestamp", datetime.now().isoformat())
        root.set("version", "1.0")

        # Summary statistics
        total = len(comparison_results)
        passed = sum(1 for r in comparison_results if r.get("success"))
        failed = total - passed

        summary = ET.SubElement(root, "summary")
        ET.SubElement(summary, "total").text = str(total)
        ET.SubElement(summary, "passed").text = str(passed)
        ET.SubElement(summary, "failed").text = str(failed)

        if total > 0:
            rate = passed / total * 100
            ET.SubElement(summary, "success-rate").text = f"{rate:.1f}%"
        else:
            ET.SubElement(summary, "success-rate").text = "N/A"

        # Detailed results
        details = ET.SubElement(root, "details")
        for result in comparison_results:
            task = ET.SubElement(details, "task")
            task.set("name", str(result.get("testq", "unknown")))
            task.set("status", "PASS" if result.get("success") else "FAIL")

            if "error" in result:
                error_elem = ET.SubElement(task, "error")
                error_elem.text = result["error"]

        # Save
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        xml_path = self.paths["reports"] / f"statistics_{timestamp}.xml"

        tree = ET.ElementTree(root)
        tree.write(xml_path, encoding="utf-8", xml_declaration=True)

        logger.info(f"Statistics saved: {xml_path}")
        return xml_path
