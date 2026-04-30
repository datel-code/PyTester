REM -----------------------------------------------------------------------
REM --- Statistic Maker PARAMETERS ----------------------------------------
REM -----------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM _GTMP - Common tmp folder
REM _LOGFILE

REM --- Tester specific variables ---
REM _STAT_ROOT - Root for collecting statistics, i.e. Processed\Compared (=_CMP_OUT)
REM _CMP_OUT - Report input = Compare output folder
REM _GLOBALSCRIPTSFOLDER - Common scripts folder
REM _SOURCEFOLDER - Root of the source files
REM _REFFOLDER - Root of reference files
REM _OUTFOLDER - Root of output files

call %G_TIMESTAMP%

echo ^>Entering Parameters-Statistics.bat>>%_LOGFILE%
echo ^>Entering Parameters-Statistics.bat

REM Set which process output file type present in the report
set _STAT_CMPOUTPUTFILETYPE=TIF

set _STAT_ROOT=%_CMP_OUT%
set _STAT_TESTREPORTCOMMONFILE=%_STAT_ROOT%\NMTCompareReport.xml
set _STAT_TESTREPORTTMPFILE=%_GTMP%\reporttmp.xml
set _STAT_KNOWNISSUESFILE=%_KNOWNISSUES%
set _STAT_XMLTMPFILE=%_GTMP%\stattmp.xml
set _STAT_INITIALSTATFILENAME=InitialStatistics.xml
set _STAT_INITIALSTATFILE="%_GLOBALSCRIPTSFOLDER%\AuxiliaryFiles\%_STAT_INITIALSTATFILENAME%"
set _STAT_STATISTICSCOMMONFILE=%_STAT_ROOT%\%_TOPIC%_Statistics.xml
set _STAT_SOURCEFOLDER=%_TICKETS%
set _STAT_PRECMPFOLDER=%_CMP_OUT%
set _STAT_PROCESSOUTFOLDER=%_OUTFOLDER%
set _STAT_REFFOLDER=%_REFFOLDER%
set _STAT_ARCHIVE=%_ARCHIVE_OUT%
set _STAT_SUSPECTEDFILESCOUNTARRAY=

REM Create UNC paths for report
set "_STAT_ROOT_UNC=file://%_STAT_ROOT:\=/%"
set "_STAT_TESTREPORTCOMMONFILE_UNC=file://%_STAT_TESTREPORTCOMMONFILE:\=/%"
set "_STAT_KNOWNISSUESFILE_UNC=file://%_STAT_KNOWNISSUESFILE:\=/%"
set "_STAT_STATISTICSCOMMONFILE_UNC=file://%_STAT_STATISTICSCOMMONFILE:\=/%"
set "_STAT_SOURCEFOLDER_UNC=file://%_STAT_SOURCEFOLDER:\=/%"
set "_STAT_PRECMPFOLDER_UNC=file://%_STAT_PRECMPFOLDER:\=/%"
set "_STAT_PROCESSOUTFOLDER_UNC=file://%_STAT_PROCESSOUTFOLDER:\=/%"
set "_STAT_REFFOLDER_UNC=file://%_STAT_REFFOLDER:\=/%"
set "_STAT_ARCHIVE_UNC=file://%_STAT_ARCHIVE:\=/%"
