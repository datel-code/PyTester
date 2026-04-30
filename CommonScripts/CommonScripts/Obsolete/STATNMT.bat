REM -----------------------------------------------------------------------
REM --- Data collector for Ct based EG Compare engine ---------------------
REM -----------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM _INPUTFILETYPE - What file type is used as AET input
REM _SUBTASKSLISTFILE - File with actual list of processed tickets (generated during AET run)
REM _LOGFILE - Common Log file

REM --- Tester specific variables
REM _STAT_ROOT - Root for collecting statistics, i.e. Processed\Compared (=_CMP_OUT)
REM _STAT_STATISTICSCOMMONFILE - Statistics collector XML file
REM _STAT_COLLECTEDERRORSFILE - Report collector XML
REM _STAT_INITIALSTATFILE - Empty XML
REM _STAT_XMLTMPFILE - Temporary intermediate XML 
REM _DATATMPFILE - Temporary intermediate file
REM _STAT_CMPOUTPUTFILETYPE - Which compare output file type present in the report
REM _INPUTFILESSTRUCTURE - FLAT/FOLDERS to get the number of input files from a flat structure/folders

call %G_TIMESTAMP%

echo ^>Entering STATNMT.bat /%_TOPIC%/ >>%_LOGFILE%
echo ^>Entering STATNMT.bat /%_TOPIC%/

if not exist %_STAT_ROOT% (
    echo %_STAT_ROOT% does not exist! >>%_LOGFILE%
    echo %_STAT_ROOT% does not exist!
    EXIT /B 99
)

REM Statistics XML file clean-up done by replacing it by an empty InitialStatistics.xml
copy %_STAT_INITIALSTATFILE% %_STAT_XMLTMPFILE% > nul

REM Building up the common root node in the Statistics XML
xml ed -P -O ^
-s "/stat" -t elem -n "tasks" -v "" ^
%_STAT_XMLTMPFILE% | xml fo -s 4 > %_STAT_STATISTICSCOMMONFILE%
copy /Y %_STAT_STATISTICSCOMMONFILE% %_STAT_XMLTMPFILE% 

REM Init Common statistics sums
set _INPUT_FILES_COUNT_SUM=0
set _PROCESS_OUT_FILES_COUNT_SUM=0
set _REIMPORT_OUT_FILES_COUNT_SUM=N/A
set _PRECMP_OUT_FILES_COUNT_SUM=0
set _ONTOP_FILES_COUNT_SUM=0
set _REF_TIFF_FILES_COUNT_SUM=0

REM Start a collected report file by the XML header and a common root node
echo ^<?xml version="1.0"?^>^<NMTCompareReport^> > %_STAT_TESTREPORTCOMMONFILE%

REM Collect data from task folders
setlocal EnableDelayedExpansion
for /F "skip=1" %%i in (%_SUBTASKSLISTFILE%) do (
    set _THIS_TASKNAME=%%i
    set _THIS_SOURCEFOLDER=%_STAT_SOURCEFOLDER%\!_THIS_TASKNAME!
    REM     if defined _REIMPORTFOLDERNAME (
    REM         set _THIS_REIMPORT_OUTFOLDER=%_STAT_REIMPORT_OUTFOLDER%\!_THIS_TASKNAME!
    REM     )
    set _THIS_PROCESSOUTFOLDER=%_STAT_PROCESSOUTFOLDER%\!_THIS_TASKNAME!
    set _THIS_CMPOUTFOLDER=%_STAT_ROOT%\!_THIS_TASKNAME!
    set _THIS_PRECMPFOLDER=%_STAT_PRECMPFOLDER%\!_THIS_TASKNAME!
    set _THIS_REFFOLDER=%_STAT_REFFOLDER%\!_THIS_TASKNAME!
    set _THIS_TESTREPORTFILE=!_THIS_CMPOUTFOLDER!\!_THIS_TASKNAME!.xml
    
    set _THIS_ERRORS=!_THIS_CMPOUTFOLDER!\Errors_!_THIS_TASKNAME!.log

    set /a _INPUT_FILES_COUNT=0

    REM Get number of input files
    if "%_INPUTFILESSTRUCTURE%" EQU "FLAT" (
        set _INPUT_FILES_COUNT=N/A
    )
    if "%_INPUTFILESSTRUCTURE%" EQU "FOLDERS" (
        dir !_THIS_SOURCEFOLDER!\*.%_INPUTFILETYPE% /A-D /B | FIND /C /V "" > %_DATATMPFILE% 2> nul
        set /p _INPUT_FILES_COUNT= < %_DATATMPFILE%
    )
    if "%_INPUTFILESSTRUCTURE%" EQU "MULTICFG" (
        for /f %%N in ('find /v /c "" ^<"%_STAT_SOURCEFOLDER%\!_THIS_TASKNAME!.%_TASKFILETYPE%"') do set /a _INPUT_FILES_COUNT+=%%N
    )

    dir "!_THIS_PROCESSOUTFOLDER!\*.%_OUTPUTFILETYPE%" /A-D /B 2> nul | FIND /C /V "" > %_DATATMPFILE% 2> nul
    set /p _PROCESS_OUT_FILES_COUNT= < %_DATATMPFILE%
    dir "!_THIS_PRECMPFOLDER!\*.%_STAT_CMPOUTPUTFILETYPE%" /A-D /B 2> nul | FIND /C /V "" > %_DATATMPFILE% 2> nul
    set /p _PRECMP_OUT_FILES_COUNT= < %_DATATMPFILE%
    dir "!_THIS_CMPOUTFOLDER!\diff\*.ontop" /A-D /B 2> nul | FIND /C /V "" > %_DATATMPFILE% 2> nul
    set /p _ONTOP_FILES_COUNT= < %_DATATMPFILE%
    dir "!_THIS_REFFOLDER!\*.%_STAT_CMPOUTPUTFILETYPE%" /A-D /B 2> nul | FIND /C /V "" > %_DATATMPFILE% 2> nul
    set /p _REF_TIFF_FILES_COUNT= < %_DATATMPFILE%
    REM     if defined _REIMPORTFOLDERNAME (
    REM         dir "!_THIS_REIMPORT_OUTFOLDER!\*.%_OUTPUTFILETYPE%" /A-D /B 2> nul | FIND /C /V "" > %_DATATMPFILE% 2> nul
    REM         set /p _REIMPORT_OUT_FILES_COUNT= < %_DATATMPFILE%
    REM         set /a _REIMPORT_OUT_FILES_COUNT_SUM=_REIMPORT_OUT_FILES_COUNT_SUM+_REIMPORT_OUT_FILES_COUNT
    REM 
    REM     ) else (
    REM         set _REIMPORT_OUT_FILES_COUNT=N/A
    REM     )
    set _REIMPORT_OUT_FILES_COUNT=N/A
    if "%_INPUTFILESSTRUCTURE%" NEQ "FLAT" set /a _INPUT_FILES_COUNT_SUM=_INPUT_FILES_COUNT_SUM+_INPUT_FILES_COUNT
    set /a _PROCESS_OUT_FILES_COUNT_SUM=_PROCESS_OUT_FILES_COUNT_SUM+_PROCESS_OUT_FILES_COUNT
    set /a _PRECMP_OUT_FILES_COUNT_SUM=_PRECMP_OUT_FILES_COUNT_SUM+_PRECMP_OUT_FILES_COUNT
    set /a _ONTOP_FILES_COUNT_SUM=_ONTOP_FILES_COUNT_SUM+_ONTOP_FILES_COUNT
    set /a _REF_TIFF_FILES_COUNT_SUM=_REF_TIFF_FILES_COUNT_SUM+_REF_TIFF_FILES_COUNT

    REM Collect counts of suspected files	
    if "!_STAT_SUSPECTEDFILESCOUNTARRAY!" NEQ "" (set _THIS_DELIM=:)
    set _STAT_SUSPECTEDFILESCOUNTARRAY=!_STAT_SUSPECTEDFILESCOUNTARRAY!!_THIS_DELIM!!_ONTOP_FILES_COUNT!

    REM Builds the stat.xml file from variables
    xml ed -P -O ^
    -s "/stat/tasks" -t elem -n "task" -v "" ^
    -s "/stat/tasks/task[not(string())]" -t attr -n "taskname" -v !_THIS_TASKNAME! ^
    -s "/stat/tasks/task[@taskname='!_THIS_TASKNAME!']" -t elem -n "files" -v !_INPUT_FILES_COUNT! ^
    -s "/stat/tasks/task[@taskname='!_THIS_TASKNAME!']/files" -t attr -n "type" -v "inputfiles" ^
    -s "/stat/tasks/task[@taskname='!_THIS_TASKNAME!']" -t elem -n "files" -v !_PROCESS_OUT_FILES_COUNT! ^
    -s "/stat/tasks/task[@taskname='!_THIS_TASKNAME!']/files[not(@type)]" -t attr -n "type" -v "processedfiles" ^
    -s "/stat/tasks/task[@taskname='!_THIS_TASKNAME!']" -t elem -n "files" -v !_REIMPORT_OUT_FILES_COUNT! ^
    -s "/stat/tasks/task[@taskname='!_THIS_TASKNAME!']/files[not(@type)]" -t attr -n "type" -v "reimportedfilesout" ^
    -s "/stat/tasks/task[@taskname='!_THIS_TASKNAME!']" -t elem -n "files" -v !_PRECMP_OUT_FILES_COUNT! ^
    -s "/stat/tasks/task[@taskname='!_THIS_TASKNAME!']/files[not(@type)]" -t attr -n "type" -v "precomparefiles" ^
    -s "/stat/tasks/task[@taskname='!_THIS_TASKNAME!']" -t elem -n "files" -v !_ONTOP_FILES_COUNT! ^
    -s "/stat/tasks/task[@taskname='!_THIS_TASKNAME!']/files[not(@type)]" -t attr -n "type" -v "ontopfiles" ^
    -s "/stat/tasks/task[@taskname='!_THIS_TASKNAME!']" -t elem -n "files" -v !_REF_TIFF_FILES_COUNT! ^
    -s "/stat/tasks/task[@taskname='!_THIS_TASKNAME!']/files[not(@type)]" -t attr -n "type" -v "reffiles" ^
    %_STAT_XMLTMPFILE% | xml fo -s 4 > %_STAT_STATISTICSCOMMONFILE%
    copy /Y %_STAT_STATISTICSCOMMONFILE% %_STAT_XMLTMPFILE% >nul

    echo For task !_THIS_TASKNAME! found in output:
    echo Input %_INPUTFILETYPE% files found: !_INPUT_FILES_COUNT!
    echo Processed %_OUTPUTFILETYPE% output files found: !_PROCESS_OUT_FILES_COUNT!
    REM     if defined _REIMPORTFOLDERNAME (
    REM         echo Reimported %_OUTPUTFILETYPE% output files found: !_REIMPORT_OUT_FILES_COUNT!
    REM     )
    echo Pre-compare %_STAT_CMPOUTPUTFILETYPE% output files found: !_PRECMP_OUT_FILES_COUNT!
    echo Diff files found: !_ONTOP_FILES_COUNT!
    echo Reference files found: !_REF_TIFF_FILES_COUNT!
    echo=======================================
    echo For task !_THIS_TASKNAME! found in output:>>%_LOGFILE%
    echo Input %_INPUTFILETYPE% files found: !_INPUT_FILES_COUNT!>>%_LOGFILE%
    echo Processed %_OUTPUTFILETYPE% output files found: !_PROCESS_OUT_FILES_COUNT!>>%_LOGFILE%
    REM     if defined _REIMPORTFOLDERNAME (
    REM         echo Reimported %_OUTPUTFILETYPE% output files found: !_REIMPORT_OUT_FILES_COUNT!>>%_LOGFILE%
    REM     )
    echo Pre-compare %_STAT_CMPOUTPUTFILETYPE% output filesfound: !_PRECMP_OUT_FILES_COUNT!>>%_LOGFILE%
    echo Diff files found: !_ONTOP_FILES_COUNT!>>%_LOGFILE%
    echo Reference files found: !_REF_TIFF_FILES_COUNT!>>%_LOGFILE%
    echo=======================================>>%_LOGFILE%
    
    REM Append report without a header
    more +1 !_THIS_TESTREPORTFILE! >> %_STAT_TESTREPORTCOMMONFILE%

)

REM get the array out of the local area
(
    endlocal
    set "_OUT=%_STAT_SUSPECTEDFILESCOUNTARRAY%"

    set _INPUT_FILES_COUNT_SUM_OUT=%_INPUT_FILES_COUNT_SUM%
    set _PROCESS_OUT_FILES_COUNT_SUM_OUT=%_PROCESS_OUT_FILES_COUNT_SUM%
    REM     if defined _REIMPORTFOLDERNAME (
    REM         set _REIMPORT_OUT_FILES_COUNT_SUM_OUT=%_REIMPORT_OUT_FILES_COUNT_SUM%
    REM     )
    set _PRECMP_OUT_FILES_COUNT_SUM_OUT=%_PRECMP_OUT_FILES_COUNT_SUM%
    set _ONTOP_FILES_COUNT_SUM_OUT=%_ONTOP_FILES_COUNT_SUM%
    set _REF_TIFF_FILES_COUNT_SUM_OUT=%_REF_TIFF_FILES_COUNT_SUM%
)

set _OUT >nul
set _STAT_SUSPECTEDFILESCOUNTARRAY=%_OUT% >nul

REM Override input files count if input has only flat structure
if "%_INPUTFILESSTRUCTURE%" EQU "FLAT" (
    dir %_STAT_SOURCEFOLDER%\*.%_INPUTFILETYPE% /A-D /B | FIND /C /V "" > %_DATATMPFILE% 2> nul
    set /p _INPUT_FILES_COUNT_SUM= < %_DATATMPFILE%
) else (
    set _INPUT_FILES_COUNT_SUM=%_INPUT_FILES_COUNT_SUM_OUT%
)

set _PROCESS_OUT_FILES_COUNT_SUM=%_PROCESS_OUT_FILES_COUNT_SUM_OUT%
REM if defined _REIMPORTFOLDERNAME (
REM     set _REIMPORT_OUT_FILES_COUNT_SUM=%_REIMPORT_OUT_FILES_COUNT_SUM_OUT%
REM ) else (
REM     set _REIMPORT_OUT_FILES_COUNT_SUM=N/A
REM )
set _REIMPORT_OUT_FILES_COUNT_SUM=N/A
set _PRECMP_OUT_FILES_COUNT_SUM=%_PRECMP_OUT_FILES_COUNT_SUM_OUT%
set _ONTOP_FILES_COUNT_SUM=%_ONTOP_FILES_COUNT_SUM_OUT%
set _REF_TIFF_FILES_COUNT_SUM=%_REF_TIFF_FILES_COUNT_SUM_OUT%
    
REM Append ending of the root node to the collected report 
echo ^</NMTCompareReport^> >> %_STAT_TESTREPORTCOMMONFILE%
copy %_STAT_TESTREPORTCOMMONFILE% %_STAT_XMLTMPFILE% >nul

REM Format the output
xml fo -s 4 %_STAT_XMLTMPFILE% > %_STAT_TESTREPORTCOMMONFILE%

del %_DATATMPFILE% > nul
