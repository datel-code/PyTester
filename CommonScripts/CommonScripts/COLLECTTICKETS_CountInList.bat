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

echo ^>Entering COLLECTTICKETS_CountInList.bat /%_TOPIC%/>>%_LOGFILE%
echo ^>Entering COLLECTTICKETS_CountInList.bat /%_TOPIC%/

echo Getting a number of subtask...
echo Getting a number of subtask...>>%_LOGFILE%

set _NUMOFTASKS=0

for /F "skip=1" %%j in (%_SUBTASKSLISTFILE%) do (
    set /A _NUMOFTASKS=_NUMOFTASKS+1
)
echo Counted %_NUMOFTASKS% task(s)>>%_LOGFILE%
echo Counted %_NUMOFTASKS% task(s)