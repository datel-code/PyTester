
//------------------------------------------------------------------------------------------------------------------------------------
// Expected parameters:

// 0-AISignature - WAI22r / WAI23r ...
// 1-testerName - "PDF Export Tester", "Dynamic Barcodes Tester", "DB Recognition Tester", "Dynamic Marks Tester", "Dynamic Tables Tester", "Trapping Tester" or "DynamicVDP Tester"

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

// #target Illustrator-29.064

var TAISignature = "WAI29r";

var TrequestedTesterName = "PDF Export Tester";
var TinputFolder = "T:\\CommonSource\\PyTest";
var TprocessSubfolder = "false";
var Tmask = "*.ai";
var TuseImportPDF = "false";
var TuseImportNDLPDF = "false";
var ToutputFolder = "T:\\NDLPlus_BatchTesting\\Processed\\PyTest";
var TjobName = "Test"
var ToutputType = 3;
var TinkMappingFile = "";
var TtrapTicket = "";


// Comment if calling from another script, otherwise Txxx parameters are used for testing
// var arguments = [TAISignature, TrequestedTesterName, TinputFolder, TprocessSubfolder, Tmask, TuseImportPDF, TuseImportNDLPDF, ToutputFolder, TtrapTicket, TinkMappingFile, TjobName, ToutputType];


try
{
    if (typeof arguments == "undefined")
    {
        throw "This script requires at least some parameters!";
    }
    else
    {
        var AISignature = String(arguments[0]); 
        var requestedTesterName = String(arguments[1]); 
        
        var inputFolder = "N/D";
        var processSubfolder = false;
        var mask = "N/D"; 
        var useImportPDF = false;
        var useImportNDLPDF = false;
        var outputFolder = "N/D";
        var trapTicket = "N/D";
        var ticketsFolder = "N/D";
        var testerParametersFile = "N/D";
        var inkMappingFile = "N/D";
        var jobName = "N/D"; 
        var outputType = "N/D"; 

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

        // No Tester name for PDF export > no realTesterName definition
        expectedNoOfParameters = 12;
        expectedParameters = "\n- AISignature\n- testerName\n- inputFolder\n- processSubfolder\n- mask\n- useImportPDF\n- useImportNDLPDF\n- outputFolder\n- trapTicket\n- inkMappingFile\n- jobName\n- outputType";

        // Check if there is enough parameters
        if (typeof (arguments[expectedNoOfParameters-1]) == "undefined")
            throw "This script requires " +  expectedNoOfParameters + " parameters: " + expectedParameters;

        // Assembly parameters
        inputFolder = String(arguments[2]);
        processSubfolder = false;
        if (arguments[3] == "true")
        {
            processSubfolder = true;
        }
        mask = String(arguments[4]); 
        useImportPDF = false;
        if (arguments[5] == "true")
        {
            useImportPDF = true;
        }
        useImportNDLPDF = false;
        if (arguments[6] == "true")
        {
            useImportNDLPDF = true;
        }
        outputFolder = String(arguments[7]);
        trapTicket = String(arguments[8]);
        inkMappingFile = String(arguments[9]);
        jobName = String(arguments[10]); 
        outputType = Number(arguments[11]); 

//        break;
 
       
        $.writeln("AI Signature: " + AISignature);
        $.writeln("Tester name: Core PDF Export Tester");

        $.writeln("Input folder: " + inputFolder);
        $.writeln("Output folder: " + outputFolder);
        $.writeln("Process subfolders: " + processSubfolder);
        $.writeln("Mask: " + mask);
        $.writeln("Use PDF Import: " + useImportPDF);
        $.writeln("Use NDL PDF Import: " + useImportNDLPDF);
        $.writeln("Parameters file: " + testerParametersFile);
        $.writeln("Tickets folder: " + ticketsFolder);
        $.writeln("Trap ticket: " + trapTicket);
        $.writeln("Ink mapping file: " + inkMappingFile);
        $.writeln("Job name: " + jobName);
        $.writeln("Output type: " + outputType);

        // Send parameters to Scripter

        // scripter.testerName = realTesterName;
        
        scripter.inputFolder = inputFolder;
        scripter.processSubfolder = processSubfolder;
        scripter.mask = mask; 
        if (useImportPDF == true && useImportNDLPDF == false) 
        {
            scripter.useImportPDF = true;
        }
        if (useImportNDLPDF == true && useImportPDF == false) 
        {
            scripter.useImportNDLPDF = true;
        }
        scripter.outputFolder = outputFolder;
        scripter.trapTicket = trapTicket;
        scripter.ticketsFolder = ticketsFolder;
        scripter.testerParametersFile = testerParametersFile;
        scripter.inkMappingFile = inkMappingFile;
        scripter.jobName = jobName; 
        scripter.outputType = outputType; 
        // Suppress application messages
        app.userInteractionLevel = UserInteractionLevel.DONTDISPLAYALERTS;

        scripter.testPDFExport();

        app.userInteractionLevel = UserInteractionLevel.DISPLAYALERTS;

        // Cleanup the parameters
        delete scripter.testerName;
        delete scripter.inputFolder;
        delete scripter.processSubfolder;
        delete scripter.mask; 
        delete scripter.useImportPDF;
        delete scripter.useImportNDLPDF;
        delete scripter.outputFolder;
        delete scripter.trapTicket;
        delete scripter.ticketsFolder;
        delete scripter.testerParametersFile;
        delete scripter.inkMappingFile;
        delete scripter.jobName; 
        delete scripter.outputType; 
        
        // Check if tester is successful
        var ErrorCode    = scripter.errorCode;
        var ErrorMessage = scripter.errorMessage;

        delete scripter.errorCode;
        delete scripter.errorMessage;

        if (ErrorCode != 0)
            throw "Error Code: " + ErrorCode + ", Error Message: " + ErrorMessage;
        else 
            $.writeln("Done successfully.");
    }

}
catch (err)
{
    $.writeln(err);
    err;
}
