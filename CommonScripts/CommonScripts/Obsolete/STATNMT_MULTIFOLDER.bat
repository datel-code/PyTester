REM -----------------------------------------------------------------------
REM --- Data collector for TIFF based Neo Model Test compare engine -------
REM --- Version for multi-folder outputs ----------------------------------
REM -----------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM _BUILDNUMBER - Standard build no.
REM _NDLBUILDNUMBER - NDL build no.
REM _NMTBUILDNUMBER - Neo ModelTest build no.
REM _INPUTFILETYPE - What file type is used as AET input
REM _SOURCEFOLDER - Folder with source files
REM _SUBTASKSLISTFILE - File with actual list of processed tickets (generated during AET run)
REM _LOGFILE - Common Log file

REM --- Tester specific variables
REM _TOPIC - Tester's name or abbreviation
REM _STAT_ROOT - Root for collecting statistics, i.e. Processed\Compared (=_CMP_OUT)
REM _STAT_ROOT_UNC - its UNC version 
REM _STAT_STATISTICSCOMMONFILE - Statistics collector XML file
REM _STAT_STATISTICSCOMMONFILE_UNC - its UNC version 
REM _STAT_TESTREPORTCOMMONFILE - Report collector XML
REM _STAT_TESTREPORTCOMMONFILE_UNC - its UNC version 
REM _STAT_SOURCEFOLDER_UNC - UNC version of _SOURCEFOLDER
REM _STAT_REFFOLDER_UNC - UNC version of _REFFOLDER
REM _STAT_PRECMPFOLDER_UNC - UNC version of _OUTFOLDER
REM _STAT_INITIALSTATFILE - Empty XML
REM _STAT_XMLTMPFILE - Temporary intermediate XML 
REM _DATATMPFILE - Temporary intermediate file
REM _STAT_CMPOUTPUTFILETYPE - Which compare output file type present in the report
REM _PRECMPLOGFILE - Neo ModelTest reference error log file 

REM Optionally:
REM _LOGPROC_PREVIOUSTIMESPENT
REM _LOGPROC_CURRENTTIMESPENT

REM Defines following:
REM _STAT_CURRENTTIMESPENT
REM _STAT_PREVIOUSTIMESPENT

call %G_TIMESTAMP%

echo ^>Entering STATNMT_MULTIFOLDER.bat>>%_LOGFILE%
echo ^>Entering STATNMT_MULTIFOLDER.bat

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

REM Statistics XML file clean-up done by replacing it by an empty InitialStatistics.xml
copy %_STAT_INITIALSTATFILE% %_STAT_XMLTMPFILE% 
rem > nul

REM Get number of input files
dir %_SOURCEFOLDER%\*.%_INPUTFILETYPE% /A-D /B /S | FIND /C /V "" > %_DATATMPFILE% 2> nul
set /p _INPUT_FILES_COUNT= < %_DATATMPFILE%

REM Put common data to Statistic XML
xml ed -P -O ^
-s "/stat" -t elem -n "inputfiles" -v %_INPUT_FILES_COUNT% ^
-s "/stat/inputfiles" -t attr -n "type" -v "%_INPUTFILETYPE%" ^
-s "/stat" -t elem -n "cmpoutputfiletype" -v %_STAT_CMPOUTPUTFILETYPE% ^
-s "/stat" -t elem -n "topic" -v %_TOPIC% ^
-s "/stat" -t elem -n "NMTVersion" -v %_NMTBUILDNUMBER% ^
-s "/stat" -t elem -n "DPBuild" -v %_BUILDNUMBER% ^
-s "/stat" -t elem -n "NDLBuild" -v %_NDLBUILDNUMBER% ^
-s "/stat" -t elem -n "timesPrevious" -v "%_STAT_PREVIOUSTIMESPENT%" ^
-s "/stat" -t elem -n "timesCurrent" -v "%_STAT_CURRENTTIMESPENT%" ^
-s "/stat" -t elem -n "statroot" -v %_STAT_ROOT_UNC% ^
-s "/stat" -t elem -n "statfile" -v %_STAT_STATISTICSCOMMONFILE_UNC% ^
-s "/stat" -t elem -n "reportfile" -v %_STAT_TESTREPORTCOMMONFILE_UNC% ^
-s "/stat" -t elem -n "sourcefolder" -v %_STAT_SOURCEFOLDER_UNC% ^
-s "/stat" -t elem -n "reffolder" -v %_STAT_REFFOLDER_UNC% ^
-s "/stat" -t elem -n "outfolder" -v %_STAT_PRECMPFOLDER_UNC% ^
-s "/stat" -t elem -n "tasks" -v "" ^
%_STAT_XMLTMPFILE% | xml fo -s 4 > %_STAT_STATISTICSCOMMONFILE%

REM Prepare new tmp stat file from the existing Common data XML
copy /Y %_STAT_STATISTICSCOMMONFILE% %_STAT_XMLTMPFILE% > nul

REM Start a collected report file by the XML header and a common root node
echo ^<?xml version="1.0"?^>^<NMTCompareReport^> > %_STAT_TESTREPORTCOMMONFILE%

setlocal EnableDelayedExpansion
for /F "skip=1" %%i in (%_SUBTASKSLISTFILE%) do (
    set _THIS_TASKNAME=%%i
    set _THIS_INPUTFOLDER=%_STAT_SOURCEFOLDER%\!_THIS_TASKNAME!
    set _THIS_PROCESSOUTFOLDER=%_STAT_PROCESSOUTFOLDER%\!_THIS_TASKNAME!
    set _THIS_CMPOUTFOLDER=%_STAT_ROOT%\!_THIS_TASKNAME!
    set _THIS_PRECMPFOLDER=%_STAT_PRECMPFOLDER%\!_THIS_TASKNAME!
    set _THIS_TESTREPORTFILE=!_THIS_CMPOUTFOLDER!\!_THIS_TASKNAME!.xml

    REM Get number of input files
    dir !_THIS_INPUTFOLDER!\*.%_INPUTFILETYPE% /A-D /B | FIND /C /V "" > %_DATATMPFILE% 2> nul
    set /p _INPUT_FILES_COUNT= < %_DATATMPFILE%
    dir "!_THIS_PROCESSOUTFOLDER!\*.%_OUTPUTFILETYPE%" /A-D /B /S 2> nul | FIND /C /V "" > %_DATATMPFILE% 2> nul
    set /p _PROCESS_OUT_FILES_COUNT= < %_DATATMPFILE%
    dir "!_THIS_PRECMPFOLDER!\*.%_STAT_CMPOUTPUTFILETYPE%" /A-D /B /S 2> nul | FIND /C /V "" > %_DATATMPFILE% 2> nul
    set /p _PRECMP_OUT_FILES_COUNT= < %_DATATMPFILE%
    dir "!_THIS_CMPOUTFOLDER!\diff\*.ontop" /A-D  /B /S 2> nul | FIND /C /V "" > %_DATATMPFILE% 2> nul
    set /p _ONTOP_FILES_COUNT= < %_DATATMPFILE%
    dir "%_STAT_REFFOLDER%\!_THIS_TASKNAME!\*.%_STAT_CMPOUTPUTFILETYPE%" /A-D /B 2> nul | FIND /C /V "" > %_DATATMPFILE% 2> nul
    set /p _REF_TIFF_FILES_COUNT= < %_DATATMPFILE%

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
    -s "/stat/tasks/task[@taskname='!_THIS_TASKNAME!']/files[not(@type)]" -t attr -n "type" -v "PROCESS_OUT_FILES_COUNT" ^
    -s "/stat/tasks/task[@taskname='!_THIS_TASKNAME!']" -t elem -n "files" -v !_PRECMP_OUT_FILES_COUNT! ^
    -s "/stat/tasks/task[@taskname='!_THIS_TASKNAME!']/files[not(@type)]" -t attr -n "type" -v "PRECMP_OUT_FILES_COUNT" ^
    -s "/stat/tasks/task[@taskname='!_THIS_TASKNAME!']" -t elem -n "files" -v !_ONTOP_FILES_COUNT! ^
    -s "/stat/tasks/task[@taskname='!_THIS_TASKNAME!']/files[not(@type)]" -t attr -n "type" -v "ONTOP_FILES_COUNT" ^
    -s "/stat/tasks/task[@taskname='!_THIS_TASKNAME!']" -t elem -n "files" -v !_REF_TIFF_FILES_COUNT! ^
    -s "/stat/tasks/task[@taskname='!_THIS_TASKNAME!']/files[not(@type)]" -t attr -n "type" -v "REF_TIFF_FILES_COUNT" ^
    %_STAT_XMLTMPFILE% | xml fo -s 4 > %_STAT_STATISTICSCOMMONFILE%

    echo For TestQ !_THIS_TASKNAME! found in output:
    echo Pre-compare %_STAT_CMPOUTPUTFILETYPE% output files found: !_PRECMP_OUT_FILES_COUNT!
    echo Diff files found: !_ONTOP_FILES_COUNT!
    echo Reference files found: !_REF_TIFF_FILES_COUNT!
    echo=======================================
    echo For TestQ !_THIS_TASKNAME! found in output:>>%_LOGFILE%
    echo Pre-compare %_STAT_CMPOUTPUTFILETYPE% output filesfound: !_PRECMP_OUT_FILES_COUNT!>>%_LOGFILE%
    echo Diff files found: !_ONTOP_FILES_COUNT!>>%_LOGFILE%
    echo Reference files found: !_REF_TIFF_FILES_COUNT!>>%_LOGFILE%
    echo=======================================>>%_LOGFILE%
    
    copy /Y %_STAT_STATISTICSCOMMONFILE% %_STAT_XMLTMPFILE% > nul
    
    REM Append report without a header
    more +1 !_THIS_TESTREPORTFILE! >> %_STAT_TESTREPORTCOMMONFILE%
	)

REM get the array out of the local area

(
  endlocal
  set "_OUT=%_STAT_SUSPECTEDFILESCOUNTARRAY%"
)
set _OUT >nul
set _STAT_SUSPECTEDFILESCOUNTARRAY=%_OUT% >nul

REM Append ending of the root node to the collected report 
echo ^</NMTCompareReport^> >> %_STAT_TESTREPORTCOMMONFILE%
copy %_STAT_TESTREPORTCOMMONFILE% %_STAT_XMLTMPFILE% >nul

REM Format the output
xml fo -s 4 %_STAT_XMLTMPFILE% > %_STAT_TESTREPORTCOMMONFILE%

echo Suspected files (collected): %_STAT_SUSPECTEDFILESCOUNTARRAY%
echo Suspected files (collected): %_STAT_SUSPECTEDFILESCOUNTARRAY%>>%_LOGFILE%

del %_STAT_XMLTMPFILE%  > nul
del %_DATATMPFILE% > nul