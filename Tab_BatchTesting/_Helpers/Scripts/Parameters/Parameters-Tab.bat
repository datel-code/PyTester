 REM -----------------------------------------------------------------------
REM --- Dynamic Tab;es Tester specific PARAMETERS -------------------------
REM -----------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM _AETCOMMONNAME - Automatic Esko Tester base common name 
REM _HELPERSFOLDER

REM --- Tester specific variables ---
REM _TOPIC - Tester's name or abbreviation
REM _ROOT - Main tester root path

call %G_TIMESTAMP%

echo ^>Entering Parameters-Tab.bat>>%_LOGFILE%
echo ^>Entering Parameters-Tab.bat

REM Define export options and paths
REM _jsxOUTPUTTYPE - 0 - Esko Normalized PDF / 1 - Esko Tiff / 2 - Esko NDLPDF / 3 - Esko PDF+
REM Tester name: "PDF Export Tester", "Dynamic Barcodes Tester", "DB Recognition Tester", "Dynamic Marks Tester", "Dynamic Tables Tester" or "Trapping Tester"

set _jsxTESTERNAME="Dynamic Tables Tester"

set _TICKETS=%_HELPERSFOLDER%\CSV

set _SOURCEFOLDER=%_ROOT%\Source
set _OUTFOLDER=%_PROCESSEDFOLDER%\%_TOPIC%
set _jsxJOBNAME=%_TOPIC%-AutomatedTest
set _jsxOUTPUTTYPE=3
set _REFFOLDER=%_ROOT%\Reference\ReferenceTIFF
REM set _NMTTRAPFOLDER=%_PROCESSEDFOLDER%\NMTTrapped

REM If _KNOWNISSUESPERTASK=YES then _KNOWNISSUES serves as a base for per-task file names
set _KNOWNISSUESPERTASK=NO
set _KNOWNISSUES=%_HELPERSFOLDER%\KnownIssues\KnownIssues-%_TOPIC%.xml

REM Does the tester export to multiple folders?
set _MULTIFOLDER_CMP=YES
set _INPUTFILESSTRUCTURE=MULTICFG
rem FLAT=Input files in single folder, FOLDERS=in subfolders
set _MULTIFOLDER_PROCESS=YES

REM Define tester specific helpers
set AET=%_AETCOMMONNAME%-Tab.bat
set vbsAET=%_AETCOMMONNAME%-Tab.vbs

set _CMPENGINE=NMT

if "%_CMPENGINE%" EQU "NMT" (
    set G_COMPARE=%G_NMTCOMPARE%
    set P_Compare=%P_NMTCompare%
)
if "%_CMPENGINE%" EQU "EGC" (
    set G_COMPARE=%G_EGCOMPARE%
    set P_Compare=%P_EGCompare%
)

set COLLECTTICKETS=%_GLOBALSCRIPTSFOLDER%\COLLECTTICKETS_CountFiles.bat

REM Define the file extensions (for statistics)
set _INPUTFILETYPE=Ai
set _OUTPUTFILETYPE=PDF
set _DIFFTYPE=ontop
REM The file type of files counted as tasks
set _TASKFILETYPE=CSV

REM List of processed tickets/TestQs
set _SUBTASKSLISTFILE=%_PROCESSEDFOLDER%\SubtasksList.txt
echo The file with a list of tasks %_SUBTASKSLISTFILE% is defined automatically.
echo The file with a list of tasks %_SUBTASKSLISTFILE% is defined automatically. >>%_LOGFILE%

REM Archiving parameters
set _ARCHIVE_OUT=%_TOPIC%_%_SAFEDATE%

REM Processing log file
set "_PROCESSLOGFILE=%_OUTFOLDER%\%_TOPIC%-Processing.log"
set "_TIMELOGFILE=%_OUTFOLDER%\%_TOPIC%-Times.log"
REM Export Time Logging
set _PREVIOUSTIMEFILE=%_GTMP%\PreviousTime_%_TOPIC%.txt
set _TIMESPENTTMPFILE=%_GTMP%\TimeSpentCalc.tmp

REM Define recipients and the topic for mailing
if "%REGIME%" NEQ "AUTO" (
	set "_LOGTOPIC=AT: M %_TOPIC%"
	set _RECIPIENTS=tomas.tarant@esko.com,matous.zoubek@esko.com
	) ELSE (
	set "_LOGTOPIC=AT: A %_TOPIC%"
	set _RECIPIENTS=tomas.tarant@esko.com,matous.zoubek@esko.com,jan.patera@esko.com
	)
rem jan.patera@esko.com,matous.zoubek@esko.com,standa.kasny@esko.com,tomas.tarant@esko.com,jan.grebler@esko.com
