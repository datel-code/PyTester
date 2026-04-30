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

echo ^>Entering STAT.bat /%_TOPIC%/ >>%_LOGFILE%
echo ^>Entering STAT.bat /%_TOPIC%/

if not exist %_STAT_ROOT% (
    echo %_STAT_ROOT% does not exist! >>%_LOGFILE%
    echo %_STAT_ROOT% does not exist!
    EXIT /B 99
)


echo oon 


REM Statistics XML file clean-up done by replacing it by an empty InitialStatistics.xml
copy /y %_STAT_INITIALSTATFILE% %_STAT_XMLTMPFILE% > nul

REM Building up the common root node in the Statistics XML

xml ed -P -O -s "/stat" -t elem -n "tasks" -v "" %_STAT_XMLTMPFILE% | xml fo -s 4 > %_STAT_STATISTICSCOMMONFILE%

copy /Y %_STAT_STATISTICSCOMMONFILE% %_STAT_XMLTMPFILE% 
REM Init Common statistics sums
set _INPUT_FILES_COUNT_SUM=0
set _PROCESS_OUT_FILES_COUNT_SUM=0
set _REIMPORT_OUT_FILES_COUNT_SUM=N/A
set _PRECMP_OUT_FILES_COUNT_SUM=0
set _ONTOP_FILES_COUNT_SUM=0
set _REF_TIFF_FILES_COUNT_SUM=0

if "%_CMPENGINE%" EQU "NMT" (
    REM NMT: Start a collected report file by the XML header and a common root node
    echo ^<?xml version="1.0"?^>^<NMTCompareReport^> > %_STAT_TESTREPORTCOMMONFILE%
)

REM Collect data from task folders
echo Input parameters for statistics: >>%_LOGFILE%
echo Source folder         : %_STAT_SOURCEFOLDER% >>%_LOGFILE%
echo Processing folder     : %_STAT_PROCESSOUTFOLDER% >>%_LOGFILE%
echo Output root folder    : %_STAT_ROOT% >>%_LOGFILE%
echo Pre-compare output    : %_STAT_PRECMPFOLDER% >>%_LOGFILE%
echo Reference             : %_STAT_REFFOLDER% >>%_LOGFILE%
echo Input file type       : %_INPUTFILETYPE% >>%_LOGFILE%
echo Output file type      : %_OUTPUTFILETYPE% >>%_LOGFILE%
echo Input file structure  : %_INPUTFILESSTRUCTURE% >>%_LOGFILE%
echo Multifolder compare   : %_MULTIFOLDER_CMP% >>%_LOGFILE%
echo Multifolder processing: %_MULTIFOLDER_PROCESS% >>%_LOGFILE%
echo ===================================================== >>%_LOGFILE%

echo Input parameters for statistics: 
echo Source folder         : %_STAT_SOURCEFOLDER% 
echo Processing folder     : %_STAT_PROCESSOUTFOLDER% 
echo Output root folder    : %_STAT_ROOT% 
echo Pre-compare output    : %_STAT_PRECMPFOLDER% 
echo Reference             : %_STAT_REFFOLDER% 
echo Input file type       : %_INPUTFILETYPE%
echo Output file type      : %_OUTPUTFILETYPE% 
echo Input file structure  : %_INPUTFILESSTRUCTURE% 
echo Multifolder compare   : %_MULTIFOLDER_CMP% 
echo Multifolder processing: %_MULTIFOLDER_PROCESS% 
echo ===================================================== 

setlocal EnableDelayedExpansion
for /F "skip=1" %%i in (%_SUBTASKSLISTFILE%) do (
    set _THIS_TASKNAME=%%i
    set _THIS_SOURCEFOLDER=%_STAT_SOURCEFOLDER%\!_THIS_TASKNAME!
    set _THIS_PROCESSOUTFOLDER=%_STAT_PROCESSOUTFOLDER%\!_THIS_TASKNAME!
    set _THIS_CMPOUTFOLDER=%_STAT_ROOT%\!_THIS_TASKNAME!
    set _THIS_PRECMPFOLDER=%_STAT_PRECMPFOLDER%\!_THIS_TASKNAME!
    set _THIS_REFFOLDER=%_STAT_REFFOLDER%\!_THIS_TASKNAME!
    if "%_CMPENGINE%" EQU "NMT" (set _THIS_TESTREPORTFILE=!_THIS_CMPOUTFOLDER!\!_THIS_TASKNAME!.xml)
    if "%_CMPENGINE%" EQU "EGC" (set _THIS_TESTREPORTFILE=!_THIS_CMPOUTFOLDER!\log\index.html)

    set _THIS_ERRORS=!_THIS_CMPOUTFOLDER!\Errors_!_THIS_TASKNAME!.log

    set /a _INPUT_FILES_COUNT=0

    REM Get number of input files
    if "%_INPUTFILESSTRUCTURE%" EQU "FLAT" (
        set _INPUT_FILES_COUNT=N/A
    )
    if "%_INPUTFILESSTRUCTURE%" EQU "FOLDERS" (
        dir !_THIS_SOURCEFOLDER!\*.%_INPUTFILETYPE% /A-D /B /S | FIND /C /V "" > %_DATATMPFILE% 2> nul
        set /p _INPUT_FILES_COUNT= < %_DATATMPFILE%
    )
    if "%_INPUTFILESSTRUCTURE%" EQU "MULTICFG" (
        for /f %%N in ('find /v /c "" ^<"%_STAT_SOURCEFOLDER%\!_THIS_TASKNAME!.%_TASKFILETYPE%"') do set /a _INPUT_FILES_COUNT+=%%N
    )

    dir "!_THIS_PROCESSOUTFOLDER!\*.%_OUTPUTFILETYPE%" /A-D /B 2> nul | FIND /C /V "" > %_DATATMPFILE% 2> nul
    set /p _PROCESS_OUT_FILES_COUNT= < %_DATATMPFILE%
    dir "!_THIS_PRECMPFOLDER!\*.%_STAT_CMPOUTPUTFILETYPE%" /A-D /B 2> nul | FIND /C /V "" > %_DATATMPFILE% 2> nul
    set /p _PRECMP_OUT_FILES_COUNT= < %_DATATMPFILE%
    dir "!_THIS_CMPOUTFOLDER!\diff\*.%_DIFFTYPE%" /A-D /B 2> nul | FIND /C /V "" > %_DATATMPFILE% 2> nul
    set /p _ONTOP_FILES_COUNT= < %_DATATMPFILE%
    dir "!_THIS_REFFOLDER!\*.%_STAT_CMPOUTPUTFILETYPE%" /A-D /B 2> nul | FIND /C /V "" > %_DATATMPFILE% 2> nul
    set /p _REF_TIFF_FILES_COUNT= < %_DATATMPFILE%
    set _REIMPORT_OUT_FILES_COUNT=N/A
    if "%_INPUTFILESSTRUCTURE%" NEQ "FLAT" set /a _INPUT_FILES_COUNT_SUM=_INPUT_FILES_COUNT_SUM+_INPUT_FILES_COUNT
    set /a _PROCESS_OUT_FILES_COUNT_SUM=_PROCESS_OUT_FILES_COUNT_SUM+_PROCESS_OUT_FILES_COUNT
    set /a _PRECMP_OUT_FILES_COUNT_SUM=_PRECMP_OUT_FILES_COUNT_SUM+_PRECMP_OUT_FILES_COUNT
    set /a _ONTOP_FILES_COUNT_SUM=_ONTOP_FILES_COUNT_SUM+_ONTOP_FILES_COUNT
    set /a _REF_TIFF_FILES_COUNT_SUM=_REF_TIFF_FILES_COUNT_SUM+_REF_TIFF_FILES_COUNT

    if "%_CMPENGINE%" EQU "EGC" (
        REM EGC: Original log simplification
        REM Extract rows with errors from the HTML report
        type %_STAT_HTMLTABHEADER% >!_THIS_ERRORS!
        REM Find rows with 2 errors in the report
        find ">2<" !_THIS_TESTREPORTFILE! > %_FINDTMPFILE%
        REM Delete first line of the FIND command result
        more +2  %_FINDTMPFILE% >> !_THIS_ERRORS!
        REM Find rows with 1 errors
        find ">1<" !_THIS_TESTREPORTFILE! > %_FINDTMPFILE%
        REM Delete first line of the FIND command result
        more +2 %_FINDTMPFILE% >>!_THIS_ERRORS!
        type %_STAT_HTMLTABFOOTER% >>!_THIS_ERRORS!
        REM Cleanup the temp file
        del %_FINDTMPFILE%
        
        REM Escape strings not allowed in XML
        powershell -Command "(gc !_THIS_ERRORS!) -replace 'bgColor=#FFD0D0', 'bgColor=\"#FFD0D0\"' -replace 'bgColor=#FF0000', 'bgColor=\"#FF0000\"' -replace 'bgColor=red', 'bgColor=\"red\"' -replace '&', '*and*' -replace 'bgColor=#D0D0D0', 'bgColor=\"#D0D0D0\"' -replace '.html', '.ontop' -replace 'HREF=\"', 'HREF=\"!_THIS_CMPOUTFOLDER!\diff\' | Out-File -encoding ASCII !_THIS_ERRORS!"
    )
                                                    
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
    
    copy /Y %_STAT_STATISTICSCOMMONFILE% %_STAT_XMLTMPFILE% 

    echo For task !_THIS_TASKNAME! found in output:
    echo Input %_INPUTFILETYPE% files found: !_INPUT_FILES_COUNT!
    echo Processed %_OUTPUTFILETYPE% output files found: !_PROCESS_OUT_FILES_COUNT!
    echo Pre-compare %_STAT_CMPOUTPUTFILETYPE% output files found: !_PRECMP_OUT_FILES_COUNT!
    echo Diff files found: !_ONTOP_FILES_COUNT!
    echo Reference files found: !_REF_TIFF_FILES_COUNT!
    echo=======================================
    echo For task !_THIS_TASKNAME! found in output:>>%_LOGFILE%
    echo Input %_INPUTFILETYPE% files found: !_INPUT_FILES_COUNT!>>%_LOGFILE%
    echo Processed %_OUTPUTFILETYPE% output files found: !_PROCESS_OUT_FILES_COUNT!>>%_LOGFILE%
    echo Pre-compare %_STAT_CMPOUTPUTFILETYPE% output files found: !_PRECMP_OUT_FILES_COUNT!>>%_LOGFILE%
    echo Diff files found: !_ONTOP_FILES_COUNT!>>%_LOGFILE%
    echo Reference files found: !_REF_TIFF_FILES_COUNT!>>%_LOGFILE%
    echo=======================================>>%_LOGFILE%

    if "%_CMPENGINE%" EQU "NMT" (
        REM Chop the report file to smaller chunks
        powershell -Command "(gc !_THIS_TESTREPORTFILE!) -replace "^""<inputfile"^"", "^""`n<inputfile"^"" | Out-File -encoding ASCII %_STAT_TESTREPORTTMPFILE%"
        REM NMT: Append report without a header
        more +1 %_STAT_TESTREPORTTMPFILE% >> %_STAT_TESTREPORTCOMMONFILE%
    )
)

REM get the array out of the local area
(
    endlocal
    set "_OUT=%_STAT_SUSPECTEDFILESCOUNTARRAY%"

    set _INPUT_FILES_COUNT_SUM_OUT=%_INPUT_FILES_COUNT_SUM%
    set _PROCESS_OUT_FILES_COUNT_SUM_OUT=%_PROCESS_OUT_FILES_COUNT_SUM%
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
set _REIMPORT_OUT_FILES_COUNT_SUM=N/A
set _PRECMP_OUT_FILES_COUNT_SUM=%_PRECMP_OUT_FILES_COUNT_SUM_OUT%
set _ONTOP_FILES_COUNT_SUM=%_ONTOP_FILES_COUNT_SUM_OUT%
set _REF_TIFF_FILES_COUNT_SUM=%_REF_TIFF_FILES_COUNT_SUM_OUT%
    
if "%_CMPENGINE%" EQU "NMT" (
    REM NMT: Append ending of the root node to the collected report 
    echo ^</NMTCompareReport^> >> %_STAT_TESTREPORTCOMMONFILE%
    copy %_STAT_TESTREPORTCOMMONFILE% %_STAT_XMLTMPFILE% >nul
    REM NMT: Format the output
    xml fo -s 4 %_STAT_XMLTMPFILE% > %_STAT_TESTREPORTCOMMONFILE%
)
del %_DATATMPFILE% > nul

REM Processing time logging
if not defined _LOGPROC_PREVIOUSTIMESPENT (
    set _STAT_PREVIOUSTIMESPENT=x, x, x 
) else (
    set _STAT_PREVIOUSTIMESPENT=%_LOGPROC_PREVIOUSTIMESPENT%
)
if not defined _LOGPROC_CURRENTTIMESPENT (
    set _STAT_CURRENTTIMESPENT=x, x, x 
) else (
    set _STAT_CURRENTTIMESPENT=%_LOGPROC_CURRENTTIMESPENT%
)

copy /Y %_STAT_STATISTICSCOMMONFILE% %_STAT_XMLTMPFILE% 

if "%_INPUTFILESSTRUCTURE%" EQU "FLAT" (
    set /A _ALL_INPUT_FILES=%_NUMOFTASKS% * %_INPUT_FILES_COUNT_SUM%
) else (
    set _ALL_INPUT_FILES=%_INPUT_FILES_COUNT_SUM%
)

if "%_INPUTFILESSTRUCTURE%" NEQ "MULTICFG" (
    echo Input %_INPUTFILETYPE% files found: %_INPUT_FILES_COUNT_SUM%
) else (
    echo Input %_TASKFILETYPE% records found: %_INPUT_FILES_COUNT_SUM%
)
echo Total no. of %_INPUTFILETYPE% input files found: %_ALL_INPUT_FILES%
echo Processed %_OUTPUTFILETYPE% output files found: %_PROCESS_OUT_FILES_COUNT_SUM%
REM echo Reimported %_OUTPUTFILETYPE% output files found: %_REIMPORT_OUT_FILES_COUNT_SUM%
echo Pre-compare %_STAT_CMPOUTPUTFILETYPE% output files found: %_PRECMP_OUT_FILES_COUNT_SUM%
echo Diff files found: %_ONTOP_FILES_COUNT_SUM%
echo Reference files found: %_REF_TIFF_FILES_COUNT_SUM%

if "%_INPUTFILESSTRUCTURE%" NEQ "MULTICFG" (
    echo Input %_INPUTFILETYPE% files found: %_INPUT_FILES_COUNT_SUM% >>%_LOGFILE%
) else (
    echo Input %_TASKFILETYPE% records found: %_INPUT_FILES_COUNT_SUM% >>%_LOGFILE%
)
echo Total no. of %_INPUTFILETYPE% input files found: %_ALL_INPUT_FILES% >>%_LOGFILE%
echo Processed %_OUTPUTFILETYPE% output files found: %_PROCESS_OUT_FILES_COUNT_SUM% >>%_LOGFILE%
REM echo Reimported %_OUTPUTFILETYPE% output files found: %_REIMPORT_OUT_FILES_COUNT_SUM%>>%_LOGFILE%
echo Pre-compare %_STAT_CMPOUTPUTFILETYPE% output files found: %_PRECMP_OUT_FILES_COUNT_SUM% >>%_LOGFILE%
echo Diff files found: %_ONTOP_FILES_COUNT_SUM% >>%_LOGFILE%
echo Reference files found: %_REF_TIFF_FILES_COUNT_SUM% >>%_LOGFILE%

if not defined _INPUTFILESSTRUCTURE set _INPUTFILESSTRUCTURE=N/A
if not defined _STAT_REIMPORT_OUTFOLDER_UNC set _STAT_REIMPORT_OUTFOLDER_UNC=N/A

goto :COMMENT_END
echo %_INPUT_FILES_COUNT_SUM%
echo %_INPUTFILESSTRUCTURE% 
echo "%_INPUTFILETYPE%" 
echo %_PROCESS_OUT_FILES_COUNT_SUM% 
echo "%_OUTPUTFILETYPE%" 
echo %_REIMPORT_OUT_FILES_COUNT_SUM% 
echo "%_OUTPUTFILETYPE%" 
echo %_PRECMP_OUT_FILES_COUNT_SUM% 
echo "%_STAT_CMPOUTPUTFILETYPE%" 
echo %_ONTOP_FILES_COUNT_SUM% 
echo %_REF_TIFF_FILES_COUNT_SUM% 
echo %_NUMOFTASKS% 
echo %_ALL_INPUT_FILES% 
echo %_TOPIC% 
echo %_NMTBUILDNUMBER% 
echo %_BUILDNUMBER% 
echo %_NDLBUILDNUMBER% 
echo "%_STAT_PREVIOUSTIMESPENT%" 
echo "%_STAT_CURRENTTIMESPENT%" 
echo "%_STAT_SUSPECTEDFILESCOUNTARRAY%" 
echo %_STAT_TESTREPORTCOMMONFILE_UNC% 
echo %_STAT_KNOWNISSUESFILE_UNC% 
echo %_STAT_STATISTICSCOMMONFILE_UNC% 
echo %_STAT_ROOT_UNC% 
echo %_STAT_SOURCEFOLDER_UNC% 
echo %_STAT_PRECMPFOLDER_UNC% 
echo %_STAT_PROCESSOUTFOLDER_UNC% 
echo %_STAT_REIMPORT_OUTFOLDER_UNC% 
echo %_STAT_REFFOLDER_UNC% 
echo %_STAT_ARCHIVE_UNC% 

pause
:COMMENT_END

REM Put common data to Statistic XML
xml ed -P -O ^
-s "/stat" -t elem -n "suminputfiles" -v %_INPUT_FILES_COUNT_SUM% ^
-s "/stat" -t elem -n "inputfilesstructure" -v %_INPUTFILESSTRUCTURE% ^
-s "/stat/inputfiles" -t attr -n "type" -v "%_INPUTFILETYPE%" ^
-s "/stat" -t elem -n "sumprocessedfiles" -v %_PROCESS_OUT_FILES_COUNT_SUM% ^
-s "/stat/processedfiles" -t attr -n "type" -v "%_OUTPUTFILETYPE%" ^
-s "/stat" -t elem -n "sumreimportedfilesout" -v %_REIMPORT_OUT_FILES_COUNT_SUM% ^
-s "/stat/reimportedfilesout" -t attr -n "type" -v "%_OUTPUTFILETYPE%" ^
-s "/stat" -t elem -n "sumprecomparefiles" -v %_PRECMP_OUT_FILES_COUNT_SUM% ^
-s "/stat/precomparefiles" -t attr -n "type" -v "%_STAT_CMPOUTPUTFILETYPE%" ^
-s "/stat" -t elem -n "sumontopfiles" -v %_ONTOP_FILES_COUNT_SUM% ^
-s "/stat" -t elem -n "sumreffiles" -v %_REF_TIFF_FILES_COUNT_SUM% ^
-s "/stat" -t elem -n "numoftasks" -v %_NUMOFTASKS% ^
-s "/stat" -t elem -n "allinputfiles" -v %_ALL_INPUT_FILES% ^
-s "/stat" -t elem -n "topic" -v %_TOPIC% ^
-s "/stat" -t elem -n "NMTVersion" -v %_NMTBUILDNUMBER% ^
-s "/stat" -t elem -n "DPBuild" -v %_BUILDNUMBER% ^
-s "/stat" -t elem -n "NDLBuild" -v %_NDLBUILDNUMBER% ^
-s "/stat" -t elem -n "timesPrevious" -v "%_STAT_PREVIOUSTIMESPENT%" ^
-s "/stat" -t elem -n "timesCurrent" -v "%_STAT_CURRENTTIMESPENT%" ^
-s "/stat" -t elem -n "ontopfilesarray" -v "%_STAT_SUSPECTEDFILESCOUNTARRAY%" ^
-s "/stat" -t elem -n "reportfile_unc" -v %_STAT_TESTREPORTCOMMONFILE_UNC% ^
-s "/stat" -t elem -n "knownissuesfile_unc" -v %_STAT_KNOWNISSUESFILE_UNC% ^
-s "/stat" -t elem -n "statfile_unc" -v %_STAT_STATISTICSCOMMONFILE_UNC% ^
-s "/stat" -t elem -n "statroot_unc" -v %_STAT_ROOT_UNC% ^
-s "/stat" -t elem -n "sourcefolder_unc" -v %_STAT_SOURCEFOLDER_UNC% ^
-s "/stat" -t elem -n "precmp_unc" -v %_STAT_PRECMPFOLDER_UNC% ^
-s "/stat" -t elem -n "processoutfolder_unc" -v %_STAT_PROCESSOUTFOLDER_UNC% ^
-s "/stat" -t elem -n "reimportoutfolder_unc" -v %_STAT_REIMPORT_OUTFOLDER_UNC% ^
-s "/stat" -t elem -n "reffolder_unc" -v %_STAT_REFFOLDER_UNC% ^
-s "/stat" -t elem -n "archive_unc" -v %_STAT_ARCHIVE_UNC% ^
-s "/stat" -t elem -n "nmtreportlink_unc" -v %_NMTREPORTLINK_UNC% ^
%_STAT_XMLTMPFILE% | xml fo -s 4 > %_STAT_STATISTICSCOMMONFILE%

del %_STAT_XMLTMPFILE%  > nul

REM Write statistic summary

if "%REGIME%" EQU "AUTO" (
    if not exist %_STAT_SUMMARYFILE% (echo BatchTesting Summary > %_STAT_SUMMARYFILE%)
    if "%_CMPENGINE%" EQU "EGC" (
        echo %_SAFEDATE% #Diff/Input/Processed/Pre-compared: %_ONTOP_FILES_COUNT_SUM%/%_ALL_INPUT_FILES%/%_PROCESS_OUT_FILES_COUNT_SUM%/%_PRECMP_OUT_FILES_COUNT_SUM% #Time: %_STAT_CURRENTTIMESPENT% #Ai: %_AIBUILD% #Builds: Rel/DP/NDL %_DPVERSION%/%_BUILDNUMBER%/%_NDLBUILDNUMBER% #Report: %_LOGFOLDER%\%_TOPIC%_%_SAFEDATE%-CompareReport.html >> %_STAT_SUMMARYFILE%
    ) else (
        echo %_SAFEDATE% #Diff/Input/Processed/Pre-compared: %_ONTOP_FILES_COUNT_SUM%/%_ALL_INPUT_FILES%/%_PROCESS_OUT_FILES_COUNT_SUM%/%_PRECMP_OUT_FILES_COUNT_SUM% #Time: %_STAT_CURRENTTIMESPENT% #Ai: %_AIBUILD% #Builds: Rel/DP/NDL/NMT %_DPVERSION%/%_BUILDNUMBER%/%_NDLBUILDNUMBER%/%_NMTBUILDNUMBER% #Report: %_LOGFOLDER%\%_TOPIC%_%_SAFEDATE%-CompareReport.html >> %_STAT_SUMMARYFILE%
    )
        
)