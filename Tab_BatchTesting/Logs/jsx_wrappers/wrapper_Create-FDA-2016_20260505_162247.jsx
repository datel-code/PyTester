#target illustrator-30

// Auto-generated JSX wrapper for PyTester
// Task: Create-FDA-2016
// CSV: D:\TOTA\NewTester\PyTester\py_tester\..\Tab_BatchTesting\_Helpers\CSV\Create-FDA-2016.csv
// Generated: 2026-05-05T16:22:47.266532

// === DEBUG ===
$.writeln("=== PyTester Debug ===");
$.writeln("AI Signature: WAI30r");
$.writeln("Platform: windows");
$.writeln("===================");

// === Plugin Setup ===
var updateSearchFolders = ExternalObject.searchFolders.indexOf("PDFExportTester") < 0;
if (updateSearchFolders) {
    ExternalObject.searchFolders += ";C:\Program Files\Adobe\Adobe Illustrator 2026\Plug-ins\Esko\Automated Testers;C:\Program Files\Adobe\Adobe Illustrator 2024\Plug-ins\Esko\Automated Testers";
    $.writeln("Updated search folders");
}

try {
    $.writeln("Loading PDFExportTester_WAI30r.aip");
    var module = new ExternalObject("lib:PDFExportTester_WAI30r.aip");
    $.writeln("Plugin loaded");
} catch (error) {
    $.writeln("ERROR: " + error);
    alert("PDFExportTester plugin not found!/nError: " + error);
    throw error;
}

var scripter = new PDFExportTester();

// === Set Properties (matching original Dynamic Tables pattern) ===
// For Dynamic Tables, the key parameter is testerParametersFile (CSV path)
scripter.testerName = "Dynamic Tables Tester";
scripter.testerParametersFile = "D:/TOTA/NewTester/PyTester/py_tester/../Tab_BatchTesting/_Helpers/CSV/Create-FDA-2016.csv";
scripter.outputFolder = "D:/TOTA/NewTester/PyTester/py_tester/../Tab_BatchTesting/Processed/Create";
scripter.jobName = "Create-FDA-2016-AutomatedTest";
scripter.outputType = 3;

// Optional properties (may not be used by Dynamic Tables tester)
scripter.inputFolder = "";
scripter.processSubfolder = false;
scripter.mask = "*.ai";
scripter.useImportPDF = false;
scripter.useImportNDLPDF = false;

// Additional properties
scripter.trapTicket = "-";
scripter.inkMappingFile = "-";

// === Execute ===
try {
    $.writeln("Running testPDFExport for Create-FDA-2016");
    scripter.testPDFExport();
    $.writeln("Completed");
} catch (error) {
    alert("testPDFExport failed!\n" + error);
    throw error;
}
