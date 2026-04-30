//------------------------------------------------------------------------------------------------------------------------------------
// Expected parameters:

// 0-AISignature - WAI22r / WAI23r ...
// 1-testerName - "PDF Export Tester"

// ------------ 1. PDF Export / NDL Import Tester

// 2-inputFolder - Path
// 3-processSubfolder - true/false
// 4-mask - *.pdf /  *.ai
// 5-useImportPDF - true/false
// 6-useImportNDLPDF - true/false
// 7-outputFolder  - Output path
// 8-trapTicket - Trapping ticket (PDF Export only)
// 9-inkMappingFile - Inks Mapping file (PDF Export only)
// 10-jobName  - log prefix
// 11-outputType - 0 - Esko Normalized PDF / 1 - Esko Tiff / 2 - Esko NDLPDF / 3 - Esko PDF+

//------------------------------------------------------------------------------------------------------------------------------------

// Not necessary if the correct Ai version is assigned as a default opener of Ai documents in OS.
#target Illustrator-26.064

var AISignature = "WAI26r";
var ErrorCode = 0;

try
{
    var updateSearchFolders = ExternalObject.searchFolders.indexOf("PDFExportTester") < 0;
    if (updateSearchFolders) 
    {
        ExternalObject.searchFolders += ";../../../Plug-ins/Esko/Automated Testers;../../../Plug-ins.localized/Esko/Automated Testers";
    }

    // Try to create a link to the Tester
    try 
    {
        var module = new ExternalObject("lib:PDFExportTester_" + AISignature + ".aip");
    } 
    catch (error) 
    {
        alert("The PDFExportTester plugin could not be found!");
    }
    var scripter = new PDFExportTester();

 
    scripter.inputFolder = "\\\\ESKW180139\\CommonHelpers\\AutomatedEskoTester\\STAK\\In";
    scripter.processSubfolder = true;
    scripter.mask = "*.ai"; 
    scripter.useImportPDF = false;
    scripter.useImportNDLPDF = false;
    scripter.outputFolder = "\\\\ESKW180139\\CommonHelpers\\AutomatedEskoTester\\STAK\\Out";
    scripter.trapTicket = "-";
    scripter.ticketsFolder = "-";
    scripter.testerParametersFile = "-";
    scripter.inkMappingFile = "-";
    scripter.jobName = "PDFExport"; 
    scripter.outputType = 3; 
    
    app.userInteractionLevel = UserInteractionLevel.DONTDISPLAYALERTS;

    scripter.testPDFExport();

    app.userInteractionLevel = UserInteractionLevel.DISPLAYALERTS;
    // Check if tester is successful
    var ErrorCode    = scripter.errorCode;
    var ErrorMessage = scripter.errorMessage;

    if (ErrorCode != 0)
       throw "Error Code: " + ErrorCode + ", Error Message: " + ErrorMessage;
    else 
        $.writeln("Done successfully.");

}
catch (err)
{
        alert("jsx: Error!, ",err,ErrorCode,ErrorMessage);

    err;
}
