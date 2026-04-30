REM -------------------------------------------------------------------
REM --- Deletes old log files and cleans a mess in Reference folder ---
REM --- Single/Multifolder version ------------------------------------
REM -------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM _LOGFILE - Common log file name

REM --- Tester specific variables
REM _TOPIC - Tester's name or abbreviation
REM _REFFOLDER
REM _MULTIFOLDER_CMP - General switch indicating the output mode multifolder/flat

REM --- Optional
REM _SUBTASKSLISTFILE - File where to write the actual list of processed tickets, needid in Multifolder mode

REM --- Output variables
REM _CLEANUPERROR

call %G_TIMESTAMP%

echo ^>Entering CLEANUP_REFERENCE.bat /%_TOPIC%/>>%_LOGFILE%
echo ^>Entering CLEANUP_REFERENCE.bat /%_TOPIC%/

set _CLEANUPERROR=0

REM CLEANUP REFERENCE

if not defined _REFFOLDER (
    echo Reference folder parameter not defined!
    echo Reference folder parameter not defined! >>%_LOGFILE%
    set _CLEANUPERROR=1
    goto :END
    )
if not exist %_REFFOLDER% (
    echo Reference folder doesn't exist!
    echo Reference folder doesn't exist! >>%_LOGFILE%
    set _CLEANUPERROR=2
    goto :END
    )
    
del /F/Q/S %_REFFOLDER%\*.*>nul 2>nul
if %errorlevel% NEQ 0 (
    echo Some problem with deleting old files occurred!
    echo Some problem with deleting old files occurred! >>%_LOGFILE%
    set _CLEANUPERROR=3
    goto :END
    )

if "%_MULTIFOLDER_CMP%" NEQ "YES" goto :SKIPMULTIFOLDER
if exist %_SUBTASKSLISTFILE% (
    for /F "skip=1" %%i in (%_SUBTASKSLISTFILE%) do (
        echo Deleting %_REFFOLDER%\%%i
        echo Deleting %_REFFOLDER%\%%i>>%_LOGFILE%
        rd /Q/S %_REFFOLDER%\%%i>>nul 2>nul
        )
    )
    
:SKIPMULTIFOLDER
echo Cleanup %_REFFOLDER% done.
echo Cleanup %_REFFOLDER% done.>>%_LOGFILE%

:END

echo Cleanup status: %_CLEANUPERROR%
echo Cleanup status: %_CLEANUPERROR% >>%_LOGFILE%

goto :eof