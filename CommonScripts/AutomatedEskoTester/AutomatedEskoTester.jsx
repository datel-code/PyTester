
// Universal Automated Esko Tester Launcher Script

//------------------------------------------------------------------------------------------------------------------------------------
// Expected parameters:

// 0-AISignature - WAI22r / WAI23r ...
// 1-testerName - "PDF Export Tester", "Dynamic Barcodes Tester", "DB Recognition Tester", "Dynamic Marks Tester", "Dynamic Tables Tester", "Trapping Tester", "DynamicVDP Tester" and "Trapping Tester with TestQ files"

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

// ------------ 2. Dynamic Barcodes Tester

// 2-testerParametersFile - CSV/TXT with parameters
// 3-outputFolder  - Output path
// 4-jobName  - log prefix
// 5-outputType - 0 - Esko Normalized PDF / 1 - Esko Tiff / 2 - Esko NDLPDF

// ------------ 3. DB Recognition Tester

// 2-inputFolder - Path
// 3-processSubfolder - true/false
// 4-mask - *.pdf /  *.ai
// 5-outputFolder  - Output path
// 6-jobName  - log prefix
// 7-outputType - 0 - Esko Normalized PDF / 1 - Esko Tiff / 2 - Esko NDLPDF

// ------------ 4. Dynamic Marks Tester

// 2-inputFolder - Path
// 3-processSubfolder - true/false
// 4-mask - *.pdf /  *.ai
// 5-useImportPDF - true/false
// 6-useImportNDLPDF - true/false
// 7-ticketsFolder - Path to Mark sets 
// 8-outputFolder  - Output path
// 9-jobName  - log prefix
// 10-outputType - 0 - Esko Normalized PDF / 1 - Esko Tiff / 2 - Esko NDLPDF

// ------------ 5. Dynamic Tables Tester

// 2-testerParametersFile - CSV/TXT with parameters
// 3-outputFolder  - Output path
// 4-jobName  - log prefix
// 5-outputType - 0 - Esko Normalized PDF / 1 - Esko Tiff / 2 - Esko NDLPDF

// ------------ 6. Trapping Tester

// 2-inputFolder - Path
// 3-processSubfolder - true/false
// 4-mask - *.pdf /  *.ai
// 5-useImportPDF - true/false
// 6-useImportNDLPDF - true/false
// 7-ticketsFolder - Path to trapping tickets / 
// 8-outputFolder  - Output path
// 9-jobName  - log prefix
// 10-outputType - 0 - Esko Normalized PDF / 1 - Esko Tiff / 2 - Esko NDLPDF

// ------------ 7. DynamicVDP Tester

// 2-inputFolder - Path
// 3-processSubfolder - true/false
// 4-mask - *.pdf /  *.ai
// 5-useImportPDF - true/false
// 6-useImportNDLPDF - true/false
// 7-outputFolder  - Output path
// 8-jobName  - log prefix

// ------------ 8. Trapping Tester with TestQ files

// 2-inputFolder - Path
// 3-processSubfolder - true/false
// 4-mask - *.testq
// 5-useImportPDF - true/false
// 6-useImportNDLPDF - true/false
// 7-outputFolder  - Output path
// 8-jobName  - log prefix
// 9-outputType - 0 - Esko Normalized PDF / 1 - Esko Tiff / 2 - Esko NDLPDF

//------------------------------------------------------------------------------------------------------------------------------------

// Not necessary if the correct Ai version is assigned as a default opener of Ai documents in OS.
#target Illustrator-30.064

var TAISignature = "WAI30r";

// TestQ Trapping

var TrequestedTesterName = "Trapping Tester with TestQ files";
var TinputFolder = "\\\\prasrv03\\qa\\_JIRA\\DPI\\DPI-12212 TestQ Tester inpdf\\TestQ";
var TprocessSubfolder = "false";
var Tmask = "*.testq";
var TuseImportPDF = "true";
var TuseImportNDLPDF = "false";
var ToutputFolder = "\\\\prasrv03\\qa\\_JIRA\\DPI\\DPI-12212 TestQ Tester inpdf\\Output";
var TjobName = "Trapping via TestQ-AutomatedTest"
var ToutputType = "3";


// PDF+ Export

/*var TrequestedTesterName = "PDF Export Tester";
var TinputFolder = "T:\\CommonSource\\108-DeviceN\\";
var TprocessSubfolder = "false";
var Tmask = "*.pdf";
var TuseImportPDF = "false";
var TuseImportNDLPDF = "false";
var ToutputFolder = "T:\\NDLPlus_BatchTesting\\Processed\\PDFPlusExport\\108-DeviceN\\";
var TtrapTicket = "-";
var TinkMappingFile = "-";
var TjobName = "PDFPlusExport-AutomatedTest"
var TticketsFolder = "-"
var ToutputType = "3";
*/

// DVDP

// var TrequestedTesterName = "DynamicVDP Tester";
// var TinputFolder = "T:\\DVDP_BatchTesting\\Source\\Tested1";
// var TprocessSubfolder = "true";
// var Tmask = "*.ai";
//var TuseImportPDF = "false";
//var TuseImportNDLPDF = "false";
//var ToutputFolder = "T:\\DVDP_BatchTesting\\Processed\\DVDP\\Tested1";
//var TtrapTicket = "-";
//var TinkMappingFile = "-";
//var TjobName = "Test"
//var ToutputType = "0";

// Comment if calling from another script, otherwise Txxx parameters are used for testing
//Trapping via TestQ
//var arguments = [TAISignature, TrequestedTesterName, TinputFolder, TprocessSubfolder, Tmask, TuseImportPDF, TuseImportNDLPDF, ToutputFolder, TjobName, ToutputType];

//var arguments = [TAISignature, TrequestedTesterName, TinputFolder, TprocessSubfolder, Tmask, TuseImportPDF, TuseImportNDLPDF, ToutputFolder, TtrapTicket, TinkMappingFile, TjobName, ToutputType];
// Trap test: 
//var arguments = [TAISignature, TrequestedTesterName, TinputFolder, TprocessSubfolder, Tmask, TuseImportPDF, TuseImportNDLPDF, TticketsFolder, ToutputFolder, TjobName, ToutputType];
// DVDP tester
// arguments = [TAISignature, TrequestedTesterName, TinputFolder, TprocessSubfolder, Tmask, TuseImportPDF, TuseImportNDLPDF, ToutputFolder, TjobName];


try
{
    if (typeof arguments == "undefined")
    {
        throw "This script requires at least some parameters!";
    }
    else
    {
        var testNo = 0;
        var expectedNoOfParameters = 0;
        var expectedParameters  = "";
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

        // Set the search path that contains TrappingTester plug-in
 //       var externalSearchFolder = ExternalObject.searchFolder;
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

         switch (requestedTesterName)
        {
            case "PDF Export Tester":
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

                break;

            case "Dynamic Barcodes Tester":
                var realTesterName = requestedTesterName;
                expectedNoOfParameters = 6;
                expectedParameters = "\n- AISignature\n- testerName\n- testerParametersFile\n- outputFolder\n- jobName\n- outputType";
                if (typeof (arguments[expectedNoOfParameters-1]) == "undefined")
                    throw "This script requires " +  expectedNoOfParameters + " parameters: " + expectedParameters;

                // Assembly parameters
                processSubfolder = false;
                testerParametersFile = String(arguments[2]);
                outputFolder = String(arguments[3]);
                jobName = String(arguments[4]); 
                outputType = Number(arguments[5]); 
                
                break;
                
            case "DB Recognition Tester":
                var realTesterName = requestedTesterName;
                expectedNoOfParameters = 8;
                expectedParameters = "\n- AISignature\n- testerName\n- inputFolder\n- processSubfolder\n- mask\n- outputFolder\n- jobName\n- outputType";
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
                outputFolder = String(arguments[5]);
                jobName = String(arguments[6]); 
                outputType = Number(arguments[7]); 
                
                break;
                
            case "Dynamic Marks Tester":
                var realTesterName = requestedTesterName;
                expectedNoOfParameters = 11;
                expectedParameters = "\n- AISignature\n- testerName\n- inputFolder\n- processSubfolder\n- mask\n- useImportPDF\n- useImportNDLPDF\n- ticketsFolder\n- outputFolder\n- jobName\n- outputType";
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
                ticketsFolder = String(arguments[7]);
                outputFolder = String(arguments[8]);
                jobName = String(arguments[9]); 
                outputType = Number(arguments[10]); 
                
                break;
                
             case "Dynamic Tables Tester":
                var realTesterName = requestedTesterName;
                expectedNoOfParameters = 6;
                expectedParameters = "\n- AISignature\n- testerName\n- testerParametersFile\n- outputFolder\n- jobName\n- outputType";
                if (typeof (arguments[expectedNoOfParameters-1]) == "undefined")
                    throw "This script requires " +  expectedNoOfParameters + " parameters: " + expectedParameters;
                    
                // Assembly parameters
                processSubfolder = false;
                testerParametersFile = String(arguments[2]);
                outputFolder = String(arguments[3]);
                jobName = String(arguments[4]); 
                outputType = Number(arguments[5]); 
                
                break;
                
            case "Trapping Tester":
                var realTesterName = requestedTesterName;
                expectedNoOfParameters = 11;
                expectedParameters = "\n- AISignature\n- testerName\n- inputFolder\n- processSubfolder\n- mask\n- useImportPDF\n- useImportNDLPDF\n- ticketsFolder\n- outputFolder\n- jobName\n- outputType";
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
                ticketsFolder = String(arguments[7]);
                outputFolder = String(arguments[8]);
                jobName = String(arguments[9]); 
                outputType = Number(arguments[10]); 
                
                break;
                
            case "DynamicVDP Tester":
                var realTesterName = requestedTesterName;
                expectedNoOfParameters = 9;
                expectedParameters = "\n- AISignature\n- testerName\n- inputFolder\n- processSubfolder\n- mask\n- useImportPDF\n- useImportNDLPDF\n- outputFolder\n- jobName";
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
                jobName = String(arguments[8]); 
                
                break;
                
            case "Trapping Tester with TestQ files":
                var realTesterName = requestedTesterName;
                expectedNoOfParameters = 10;
                expectedParameters = "\n- AISignature\n- testerName\n- inputFolder\n- processSubfolder\n- mask\n- useImportPDF\n- useImportNDLPDF\n- outputFolder\n- jobName\n- outputType";
                
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
                jobName = String(arguments[8]); 
                outputType = Number(arguments[9]); 
                
                break;

                
            default:
                throw "Incorrect Tester name!"
                break;
        }

 
        switch (testNo)
        {
            case 1:
            case 2:
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

                break;
        }

       
        $.writeln("AI Signature: " + AISignature);
        $.writeln("Tester name: " + realTesterName);

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

        if (typeof (realTesterName) != "undefined")
            scripter.testerName = realTesterName;
        
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
        if (outputType != "N/D")
            {
                scripter.outputType = outputType; 
            }
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

        if (ErrorCode != 0) {
            throw "Error Code: " + ErrorCode + ", Error Message: " + ErrorMessage;
            "Error Code: " + ErrorCode + ", Error Message: " + ErrorMessage; 
			}
        else {
            $.writeln("Done successfully.");
            "Done successfully.";
			}
    }

}
catch (err)
{
    $.writeln(err);
    err;
}
