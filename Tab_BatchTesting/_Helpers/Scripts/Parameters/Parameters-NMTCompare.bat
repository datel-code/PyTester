REM -----------------------------------------------------------------------
REM --- NeoModelTest Compare Engine PARAMETERS ----------------------------
REM -----------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM _GLOBALHELPERSFOLDER - Path to the global helpers 
REM G_NMTDEFINE - full path to Neo Model Test initiation batch

REM --- Tester specific variables ---
REM _PROCESSEDFOLDER - Root folder of all processing (AET + NMT)
REM _OUTFOLDER - Automatic Esko Tester output folder (_PROCESSEDFOLDER + _TOPIC)
REM _HELPERSFOLDER - Path to tester specific helpers

call %G_TIMESTAMP%

echo ^>Entering Parameters-NMTCompare.bat>>%_LOGFILE%
echo ^>Entering Parameters-NMTCompare.bat

set _CMP_IN=%_OUTFOLDER%
set _CMP_OUT=%_PROCESSEDFOLDER%\%_TOPIC%_%_CMP_FOLDERNAME%
set _CMPNMT_TESTQFOLDER=%_HELPERSFOLDER%\TestQ\%_TOPIC%_%_CMP_FOLDERNAME%

REM Pre-compare render log file
set _PRECMPLOGFILE=%_CMP_OUT%\%_TOPIC%_Pre-Compare.log
REM Compare log file
set _CMPLOGFILE=%_CMP_OUT%\%_TOPIC%_Compare.log
