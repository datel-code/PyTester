REM -------------------------------------------------------------------
REM --- Collects subtask names for further subfolder processing -------
REM --- Collects subtask names from the output folder -----------------
REM -------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM _LOGFILE - Common log file name

REM --- Tester specific variables
REM _TOPIC - Tester's name or abbreviation
REM _SUBTASKSLISTFILE - File where to write the actual list of processed tickets
REM _OUTFOLDER

REM Defined variables
REM _NUMOFTASKS

call %G_TIMESTAMP%

echo ^>Entering COLLECTTICKETS-CountOutputFolders.bat /%_TOPIC%/>>%_LOGFILE%
echo ^>Entering COLLECTTICKETS-CountOutputFolders.bat /%_TOPIC%/

echo Collecting TestQ file names...
echo Collecting TestQ file names...>>%_LOGFILE%

set _NUMOFTASKS=0

SETLOCAL EnableDelayedExpansion 
Echo List of tickets of %_TOPIC% tester>%_SUBTASKSLISTFILE%
for /F "usebackq delims=" %%i in (`dir %_OUTFOLDER% /b /ad-h`) do (
    set _THIS_TASKNAME=%%~ni
    echo !_THIS_TASKNAME! >>%_SUBTASKSLISTFILE%
	echo !_THIS_TASKNAME! >>%_LOGFILE%
 	echo !_THIS_TASKNAME!
    set /A _NUMOFTASKS=_NUMOFTASKS+1
   )
echo Collected.
echo Collected.>>%_LOGFILE%
