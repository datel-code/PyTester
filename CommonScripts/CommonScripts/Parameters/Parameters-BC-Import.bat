REM -----------------------------------------------------------------------
REM --- Barcode Tester / Common PDF Import PARAMETERS ---------------------
REM -----------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM _AETCOMMONNAME - Automatic Esko Tester base common name 
REM _HELPERSFOLDER

REM --- Tester specific variables ---
REM _TOPIC - Tester's name or abbreviation
REM _ROOT - Main tester root path

call %G_TIMESTAMP%

echo ^>Entering Parameters-BC-Import.bat>>%_LOGFILE%
echo ^>Entering Parameters-BC-Import.bat

REM Define export options and paths
REM _jsxPROCESSSUBFOLDER - true/false
REM _jsxOUTPUTTYPE - 0 - Esko Normalized PDF / 1 - Esko Tiff / 2 - Esko NDLPDF / 3 - Esko PDF+
REM Tester name: "PDF Export Tester", "Dynamic Barcodes Tester", "DB Recognition Tester", "Dynamic Marks Tester", "Dynamic Tables Tester" or "Trapping Tester"

set _TESTQFOLDER=%_HELPERSFOLDER%\TestQ

set _jsxTESTERNAME="PDF Export Tester"
set _SOURCEFOLDER=%_OUTFOLDER%
set _jsxPROCESSSUBFOLDER=false
set _jsxMASK="*.pdf"
set _jsxUSEIMPORTPDF=true
set _jsxUSEIMPORTNDLPDF=false
set _OUTFOLDER=%_PROCESSEDFOLDER%\%_TOPIC%
set _jsxJOBNAME=%_TOPIC%-AutomatedTest
set _jsxOUTPUTTYPE=0
set _REFFOLDER=%_ROOT%\Reference\ReferenceTIFF

REM Does the tester export to multiple folders?
set _MULTIFOLDER_CMP=NO
set _INPUTFILESSTRUCTURE=FLAT

REM Define tester specific helpers
set STAT=%_GLOBALSCRIPTSFOLDER%\STATNMT.bat
set COLLECTTICKETS=%_GLOBALSCRIPTSFOLDER%\COLLECTTICKETS_CountFiles.bat
set CLEANUP_NMTTRAP=%_SCRIPTSFOLDER%\CLEANUP_NMTTRAP.bat
set NMTTRAP=%_SCRIPTSFOLDER%\NMTTrap.bat

REM Define the file extensions (for statistics)
set _INPUTFILETYPE=PDF
set _OUTPUTFILETYPE=PDF
set _DIFFTYPE=ontop
REM The file type of files counted as tasks
set _TASKFILETYPE=TESTQ

REM List of processed tickets/TestQs
set _SUBTASKSLISTFILE=%_PROCESSEDFOLDER%\SubtasksList.txt
echo The file with a list of tasks %_SUBTASKSLISTFILE% is defined automatically.
echo The file with a list of tasks %_SUBTASKSLISTFILE% is defined automatically. >>%_LOGFILE%

REM Processing log file
set "_PROCESSLOGFILE=%_OUTFOLDER%\%_TOPIC%-Processing.log"
set "_TIMELOGFILE=%_OUTFOLDER%\%_TOPIC%-Times.log"
REM Export Time Logging
set _PREVIOUSTIMEFILE=%_GTMP%\PreviousTime_%_TOPIC%.txt
set _TIMESPENTTMPFILE=%_GTMP%\TimeSpentCalc.tmp

REM Define recipients and the topic for mailing
if "%REGIME%" NEQ "AUTO" (
	set "_LOGTOPIC=AT: M %_TOPIC%"
	set _RECIPIENTS=tomas.tarant@esko.com
	) ELSE (
	set "_LOGTOPIC=AT: A %_TOPIC%"
	set _RECIPIENTS=jan.patera@esko.com,tomas.tarant@esko.com,matous.zoubek@esko.com
	)
rem jan.patera@esko.com,matous.zoubek@esko.com,standa.kasny@esko.com,tomas.tarant@esko.com,jan.grebler@esko.com
