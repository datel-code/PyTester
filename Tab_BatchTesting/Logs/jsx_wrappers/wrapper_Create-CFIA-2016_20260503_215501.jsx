#target illustrator-30

// Auto-generated JSX wrapper for PyTester
// Task: Create-CFIA-2016
// CSV: /Users/datel/Library/CloudStorage/GoogleDrive-tomas.tarant@gmail.com/My Drive/Esko/Tester/py_tester/../Tab_BatchTesting/_Helpers/CSV/Create-CFIA-2016.csv
// Generated: 2026-05-03T21:55:01.744556

// === DEBUG ===
$.writeln("=== PyTester Debug ===");
$.writeln("AI Signature: MAI30r");
$.writeln("Platform: Darwin");
$.writeln("===================");

// === Plugin Setup ===
var updateSearchFolders = ExternalObject.searchFolders.indexOf("PDFExportTester") < 0;
if (updateSearchFolders) {
    ExternalObject.searchFolders += ";/Applications/Adobe Illustrator 2026/Plug-ins.localized/Esko/Automated Testers;/Applications/Adobe Illustrator 2026/Plug-ins/Esko/Automated Testers;/Applications/Adobe Illustrator 2024/Plug-ins.localized/Esko/Automated Testers;/Applications/Adobe Illustrator 2024/Plug-ins/Esko/Automated Testers";
    $.writeln("Updated search folders");
}

try {
    $.writeln("Loading PDFExportTester_MAI30r.aip");
    var module = new ExternalObject("lib:PDFExportTester_MAI30r.aip");
    $.writeln("Plugin loaded");
} catch (error) {
    $.writeln("ERROR: " + error);
    alert("PDFExportTester plugin not found!\\nError: " + error);
    throw error;
}

var scripter = new PDFExportTester();

// === Set Properties (matching original pattern) ===
scripter.testerName = "Dynamic Tables Tester";
scripter.inputFolder = "/Users/datel/Library/CloudStorage/GoogleDrive-tomas.tarant@gmail.com/My Drive/Esko/Tester/py_tester/../Tab_BatchTesting/Processed/Create";
scripter.processSubfolder = false;
scripter.mask = "*.ai";
scripter.useImportPDF = false;
scripter.useImportNDLPDF = false;
scripter.outputFolder = "/Users/datel/Library/CloudStorage/GoogleDrive-tomas.tarant@gmail.com/My Drive/Esko/Tester/py_tester/../Tab_BatchTesting/Processed/Create";
scripter.ticketsFolder = "/Users/datel/Library/CloudStorage/GoogleDrive-tomas.tarant@gmail.com/My Drive/Esko/Tester/py_tester/../Tab_BatchTesting/_Helpers/CSV/Create-CFIA-2016.csv";
scripter.jobName = "Create-CFIA-2016-AutomatedTest";
scripter.outputType = 3;

// Additional properties
scripter.trapTicket = "-";
scripter.inkMappingFile = "-";

// === Execute ===
try {
    $.writeln("Running testPDFExport for Create-CFIA-2016");
    scripter.testPDFExport();
    $.writeln("Completed");
} catch (error) {
    alert("testPDFExport failed!\\n" + error);
    throw error;
}
