REM -------------------------------------------------------------------
REM --- Collects subtask names for further subfolder processing -------
REM --- Counts input folders ------------------------------------------
REM -------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM _LOGFILE - Common log file name

REM --- Tester specific variables
REM _TOPIC - Tester's name or abbreviation
REM _SUBTASKSLISTFILE - File where to write the actual list of processed tickets

call %G_TIMESTAMP%

echo ^>Entering COLLECTTICKETS_CountInputFolders.bat /%_TOPIC%/>>%_LOGFILE%
echo ^>Entering COLLECTTICKETS_CountInputFolders.bat /%_TOPIC%/

echo Getting a number of subtask by counting input folders...
echo Getting a number of subtask by counting input folders...>>%_LOGFILE%

set _NUMOFTASKS=0

SETLOCAL EnableDelayedExpansion 
Echo List of tasks of %_TOPIC% tester>%_SUBTASKSLISTFILE%
for /F "usebackq delims=" %%i in (`dir %_SOURCEFOLDER% /b /ad-h`) do (
    set _THIS_TASKNAME=%%~ni
    echo !_THIS_TASKNAME! >>%_SUBTASKSLISTFILE%
	echo !_THIS_TASKNAME! >>%_LOGFILE%
 	echo !_THIS_TASKNAME!
    set /A _NUMOFTASKS=_NUMOFTASKS+1
   )
endlocal

for /F "skip=1" %%j in (%_SUBTASKSLISTFILE%) do (
    set /A _NUMOFTASKS=_NUMOFTASKS+1
)
echo Counted %_NUMOFTASKS% task(s)>>%_LOGFILE%
echo Counted %_NUMOFTASKS% task(s)