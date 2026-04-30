REM -----------------------------------------------------------------------
REM --- Common statistics data collector ----------------------------------
REM -----------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM _BUILDNUMBER - Standard build no.
REM _NDLBUILDNUMBER - NDL build no.
REM _NMTBUILDNUMBER - Neo ModelTest build no.
REM _INPUTFILETYPE - What file type is used as AET input
REM _LOGFILE - Common Log file

REM --- Tester specific variables
REM _TOPIC - Tester's name or abbreviation
REM _STAT_ROOT_UNC - its UNC version 
REM _STAT_STATISTICSCOMMONFILE - Statistics collector XML file
REM _STAT_STATISTICSCOMMONFILE_UNC - its UNC version 
REM _STAT_TESTREPORTCOMMONFILE_UNC - its UNC version 
REM _STAT_SOURCEFOLDER_UNC - UNC version of _SOURCEFOLDER
REM _STAT_REFFOLDER_UNC - UNC version of _REFFOLDER
REM _STAT_PRECMPFOLDER_UNC - UNC version of _OUTFOLDER
REM _STAT_XMLTMPFILE - Temporary intermediate XML 
REM _DATATMPFILE - Temporary intermediate file
REM _STAT_CMPOUTPUTFILETYPE - Which compare output file type present in the report

REM _INPUT_FILES_COUNT_SUM
REM _PROCESS_OUT_FILES_COUNT_SUM
REM _PRECMP_OUT_FILES_COUNT_SUM
REM _ONTOP_FILES_COUNT_SUM
REM _REF_TIFF_FILES_COUNT_SUM

REM Optionally:
REM _LOGPROC_PREVIOUSTIMESPENT
REM _LOGPROC_CURRENTTIMESPENT

REM Defines following:
REM _STAT_CURRENTTIMESPENT
REM _STAT_PREVIOUSTIMESPENT

call %G_TIMESTAMP%

echo ^>Entering STATCOMMON.bat>>%_LOGFILE%
echo ^>Entering STATCOMMON.bat

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

copy /Y %_STAT_STATISTICSCOMMONFILE% %_STAT_XMLTMPFILE% > nul

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

REM Put common data to Statistic XML
xml ed -P -O ^
-s "/stat" -t elem -n "suminputfiles" -v %_INPUT_FILES_COUNT_SUM% ^
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
-s "/stat" -t elem -n "statfile_unc" -v %_STAT_STATISTICSCOMMONFILE_UNC% ^
-s "/stat" -t elem -n "statroot_unc" -v %_STAT_ROOT_UNC% ^
-s "/stat" -t elem -n "sourcefolder_unc" -v %_STAT_SOURCEFOLDER_UNC% ^
-s "/stat" -t elem -n "precmp_unc" -v %_STAT_PRECMPFOLDER_UNC% ^
-s "/stat" -t elem -n "processoutfolder_unc" -v %_STAT_PROCESSOUTFOLDER_UNC% ^
-s "/stat" -t elem -n "reimportoutfolder_unc" -v %_STAT_REIMPORT_OUTFOLDER_UNC% ^
-s "/stat" -t elem -n "reffolder_unc" -v %_STAT_REFFOLDER_UNC% ^
%_STAT_XMLTMPFILE% | xml fo -s 4 > %_STAT_STATISTICSCOMMONFILE%

del %_STAT_XMLTMPFILE%  > nul

REM Write statistic summary

if "%REGIME%" EQU "AUTO" (
    if not exist %_STAT_SUMMARYFILE% (echo BatchTesting Summary > %_STAT_SUMMARYFILE%)
    echo %_SAFEDATE% %_TOPIC% %_ONTOP_FILES_COUNT_SUM%/%_INPUT_FILES_COUNT_SUM% Builds: DP %_BUILDNUMBER%, NDL: %_NDLBUILDNUMBER%, NMT: %_NMTBUILDNUMBER% Report: %_LOGFOLDER%\%_TOPIC%_%_SAFEDATE%-CompareReport.html >> %_STAT_SUMMARYFILE%
)