# JSX runner - generates JSX wrappers matching original pattern

import logging
from pathlib import Path
from typing import Optional
from datetime import datetime
import platform

logger = logging.getLogger(__name__)


class JSXRunner:
    """Generates JSX wrappers that match original AET pattern.

    For Dynamic Tables tester, original parameters are:
    0-AISignature
    1-testerName
    2-testerParametersFile (CSV/TXT with parameters)
    3-outputFolder
    4-jobName
    5-outputType
    """

    JSX_TEMPLATE = r"""#target illustrator-[[ai_version]]

// Auto-generated JSX wrapper for PyTester
// Task: [[task_name]]
// CSV: [[csv_path]]
// Generated: [[timestamp]]

// === DEBUG ===
$.writeln("=== PyTester Debug ===");
$.writeln("AI Signature: [[ai_signature]]");
$.writeln("Platform: [[platform]]");
$.writeln("===================");

// === Plugin Setup ===
var updateSearchFolders = ExternalObject.searchFolders.indexOf("PDFExportTester") < 0;
if (updateSearchFolders) {
    ExternalObject.searchFolders += ";[[plugin_search_paths]]";
    $.writeln("Updated search folders");
}

try {
    $.writeln("Loading PDFExportTester_[[ai_signature]].aip");
    var module = new ExternalObject("lib:PDFExportTester_[[ai_signature]].aip");
    $.writeln("Plugin loaded");
} catch (error) {
    $.writeln("ERROR: " + error);
    alert("PDFExportTester plugin not found!\\nError: " + error);
    throw error;
}

var scripter = new PDFExportTester();

// === Set Properties (matching original Dynamic Tables pattern) ===
// For Dynamic Tables, the key parameter is testerParametersFile (CSV path)
scripter.testerName = "[[tester_name]]";
scripter.testerParametersFile = "[[tester_parameters_file]]";
scripter.outputFolder = "[[output_folder]]";
scripter.jobName = "[[job_name]]";
scripter.outputType = [[output_type]];

// Optional properties (may not be used by Dynamic Tables tester)
scripter.inputFolder = "[[input_folder]]";
scripter.processSubfolder = [[process_subfolder]];
scripter.mask = "[[mask]]";
scripter.useImportPDF = [[use_import_pdf]];
scripter.useImportNDLPDF = [[use_import_ndlpdf]];

// Additional properties
scripter.trapTicket = "[[trap_ticket]]";
scripter.inkMappingFile = "[[ink_mapping_file]]";

// === Execute ===
try {
    $.writeln("Running testPDFExport for [[task_name]]");
    scripter.testPDFExport();
    $.writeln("Completed");
} catch (error) {
    alert("testPDFExport failed!\\n" + error);
    throw error;
}
"""

    def __init__(self, config: dict, paths: dict):
        self.config = config
        self.paths = paths
        self.ai_config = config["illustrator"]
        self.test_defaults = config.get("test_defaults", {})

    def generate_wrapper(self, task, output_dir: Optional[Path] = None) -> Path:
        if output_dir is None:
            output_dir = Path(self.paths["logs"]) / "jsx_wrappers"
        output_dir.mkdir(parents=True, exist_ok=True)

        params = self._build_params(task)

        logger.debug("JSX parameters:")
        for key, value in params.items():
            logger.debug(f"  {key}: {value}")

        jsx_content = self._replace_placeholders(self.JSX_TEMPLATE, params)

        # Verify no unreplaced placeholders
        import re
        unreplaced = re.findall(r'\[\[[a-zA-Z_]+\]\]', jsx_content)
        if unreplaced:
            logger.error(f"Unreplaced placeholders: {unreplaced}")

        # Verify no double dots
        if "..aip" in jsx_content:
            logger.error("Double dot found in JSX! Fixing...")
            jsx_content = jsx_content.replace("..aip", ".aip")

        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        jsx_path = output_dir / f"wrapper_{task.name}_{timestamp}.jsx"
        jsx_path.write_text(jsx_content, encoding="utf-8")

        logger.info(f"Generated JSX: {jsx_path}")

        return jsx_path

    def _build_params(self, task) -> dict:
        defaults = self.test_defaults

        output_folder = self.paths["processed"]
        if task.output_subfolder:
            output_folder = output_folder / task.output_subfolder

        return {
            "ai_version": self.ai_config["version"],
            "ai_signature": self.ai_config["signature"],
            "platform": platform.system(),
            "tester_name": task.tester_name,
            # KEY FIX: Use testerParametersFile instead of ticketsFolder
            "tester_parameters_file": self._escape_path(task.csv_path),
            "input_folder": "",  # Empty for Dynamic Tables - plugin reads from CSV
            "process_subfolder": "true" if defaults.get("process_subfolder", False) else "false",
            "mask": defaults.get("mask", "*.ai"),
            "use_import_pdf": "true" if defaults.get("use_import_pdf", False) else "false",
            "use_import_ndlpdf": "true" if defaults.get("use_import_ndlpdf", False) else "false",
            "output_folder": self._escape_path(output_folder),
            "csv_path": str(task.csv_path),
            "output_type": str(defaults.get("output_type", 3)),
            "trap_ticket": defaults.get("trap_ticket", "-"),
            "ink_mapping_file": defaults.get("ink_mapping_file", "-"),
            "plugin_search_paths": self._build_plugin_paths(),
            "task_name": task.name,
            "job_name": task.job_name,
            "timestamp": datetime.now().isoformat(),
        }

    def _build_plugin_paths(self) -> str:
        paths = self.ai_config.get("plugin_search_paths", [])

        if platform.system() == "Darwin":
            return ";".join(paths)
        else:
            return ";".join(p.replace("/", "\\\\") for p in paths)

    def _escape_path(self, path: Optional[Path]) -> str:
        if path is None:
            return ""
        path_str = str(path)

        if platform.system() == "Darwin":
            return path_str
        else:
            return path_str.replace("\\\\", "\\\\\\\\\\\\\\\\")

    def _replace_placeholders(self, template: str, params: dict) -> str:
        result = template
        for key, value in params.items():
            placeholder = f"[[{key}]]"
            if placeholder in result:
                result = result.replace(placeholder, str(value))
            else:
                logger.warning(f"Placeholder not found: {placeholder}")
        return result

    def cleanup_old_wrappers(self, max_age_hours: int = 24) -> int:
        wrapper_dir = Path(self.paths["logs"]) / "jsx_wrappers"
        if not wrapper_dir.exists():
            return 0

        from datetime import timedelta
        cutoff = datetime.now() - timedelta(hours=max_age_hours)
        deleted = 0

        for jsx_file in wrapper_dir.glob("wrapper_*.jsx"):
            if datetime.fromtimestamp(jsx_file.stat().st_mtime) < cutoff:
                try:
                    jsx_file.unlink()
                    deleted += 1
                except OSError:
                    pass

        return deleted
