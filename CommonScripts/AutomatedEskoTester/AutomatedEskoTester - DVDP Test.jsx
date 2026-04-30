
#target Illustrator-26.064

var TAISignature = "WAI26r";

var TrequestedTesterName = "DynamicVDP Tester";
var TinputFolder = "T:\\DVDP_BatchTesting\\Source\\Tested1";
var TprocessSubfolder = "true";
var Tmask = "*.ai";
var TuseImportPDF = "false";
var TuseImportNDLPDF = "false";
var ToutputFolder = "T:\\DVDP_BatchTesting\\Processed\\DVDP\\Tested1";
var TjobName = "DynamicVDP"

arguments = [TAISignature, TrequestedTesterName, TinputFolder, TprocessSubfolder, Tmask, TuseImportPDF, TuseImportNDLPDF, ToutputFolder, TjobName];

// Suppress application messages
// app.userInteractionLevel = UserInteractionLevel.DONTDISPLAYALERTS 


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

var realTesterName = requestedTesterName;
    
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
scripter.jobName = jobName; 

scripter.testPDFExport();

var ErrorCode    = scripter.errorCode;
var ErrorMessage = scripter.errorMessage;

$.writeln("Error Code: " + ErrorCode);
$.writeln("Error Message: " + ErrorMessage);
