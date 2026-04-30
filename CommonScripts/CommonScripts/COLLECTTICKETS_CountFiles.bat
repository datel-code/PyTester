REM -------------------------------------------------------------------
REM --- Collects subtask names for further subfolder processing -------
REM --- Collects tickets ----------------------------------------------
REM -------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM _LOGFILE - Common log file name

REM --- Tester specific variables
REM _TOPIC - Tester's name or abbreviation
REM _SUBTASKSLISTFILE - File where to write the actual list of processed tickets

REM _TICKETS - Source of subtasks names

call %G_TIMESTAMP%

echo ^>Entering COLLECTTICKETS_CountFiles.bat /%_TOPIC%/>>%_LOGFILE%
echo ^>Entering COLLECTTICKETS_CountFiles.bat /%_TOPIC%/

echo Collecting %_TASKFILETYPE% files>>%_LOGFILE%
echo Collecting %_TASKFILETYPE% files

echo Collecting subtask names...
echo Collecting subtask names...>>%_LOGFILE%

set NUMOFTASKS=0

SETLOCAL EnableDelayedExpansion 

set _THIS_NUMOFTASKS=0

Echo List of subtask names of %_TOPIC% tester>%_SUBTASKSLISTFILE%
for /F "usebackq delims=" %%i in (`dir %_TICKETS%\*.%_TASKFILETYPE% /B /A:-D`) do (
    set _THIS_TASKNAME=%%~ni
    echo !_THIS_TASKNAME! >>%_SUBTASKSLISTFILE%
	echo !_THIS_TASKNAME! >>%_LOGFILE%
 	echo !_THIS_TASKNAME!
    set /A _THIS_NUMOFTASKS=!_THIS_NUMOFTASKS!+1
   )
(
endlocal
set _NUMOFTASKS=%_THIS_NUMOFTASKS%
)
echo Collected %_NUMOFTASKS% tasks.
echo Collected %_NUMOFTASKS% tasks.>>%_LOGFILE%
