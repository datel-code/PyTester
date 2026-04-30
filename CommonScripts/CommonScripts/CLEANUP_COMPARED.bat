REM -------------------------------------------------------------------
REM --- Deletes old log files and cleans a mess in Compared folder ----
REM --- Single/Multifolder version ------------------------------------
REM -------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM _LOGFILE - Common log file name

REM --- Tester specific variables
REM _CMP_OUT

REM --- Optional
REM _CMP_OUT_CT

call %G_TIMESTAMP%

echo ^>Entering CLEANUP_COMPARED.bat /%_TOPIC%/>>%_LOGFILE%
echo ^>Entering CLEANUP_COMPARED.bat /%_TOPIC%/

set _CLEANUPERROR=0

if not defined _CMP_OUT (
    echo Compare output folder parameter not defined!
    echo Compare output folder parameter not defined! >>%_LOGFILE%
    set _CLEANUPERROR=1
    goto :CT
)
if not exist %_CMP_OUT% (
    echo Compare output folder doesn't exist, creating a new one.
    echo Compare output folder doesn't exist, creating a new one. >>%_LOGFILE%
    md %_CMP_OUT% >>%_LOGFILE%
    if %ERRORLEVEL% NEQ 0 (set _CLEANUPERROR=2)
    goto :CT
) else (
    echo Cleaning up %_CMP_OUT%
    echo Cleaning up %_CMP_OUT% >>%_LOGFILE%

    del /F/Q/S %_CMP_OUT%\*.pdf >nul 2>&1
    echo %_CMP_OUT%\*.pdf
    echo %_CMP_OUT%\*.pdf >>%_LOGFILE%
    del /F/Q/S %_CMP_OUT%\*.tif >nul 2>&1
    echo %_CMP_OUT%\*.tif
    echo %_CMP_OUT%\*.tif >>%_LOGFILE%
    del /F/Q/S %_CMP_OUT%\*.jpg >nul 2>&1
    echo %_CMP_OUT%\*.jpg
    echo %_CMP_OUT%\*.jpg >>%_LOGFILE%
    del /F/Q/S %_CMP_OUT%\*.log >nul 2>&1
    echo %_CMP_OUT%\*.log
    echo %_CMP_OUT%\*.log >>%_LOGFILE%
    del /F/Q/S %_CMP_OUT%\*.tlog >nul 2>&1
    echo %_CMP_OUT%\*.tlog
    echo %_CMP_OUT%\*.tlog >>%_LOGFILE%
    del /F/Q/S %_CMP_OUT%\*.diff >nul 2>&1
    echo %_CMP_OUT%\*.diff
    echo %_CMP_OUT%\*.diff >>%_LOGFILE%
    del /F/Q/S %_CMP_OUT%\*.html >nul 2>&1
    echo %_CMP_OUT%\*.html
    echo %_CMP_OUT%\*.html >>%_LOGFILE%
    del /F/Q/S %_CMP_OUT%\*.ontop >nul 2>&1
    echo %_CMP_OUT%\*.ontop
    echo %_CMP_OUT%\*.ontop >>%_LOGFILE%
    if not exist %_CMP_OUT% (md %_CMP_OUT%) >>%_LOGFILE%

    echo Cleanup %_CMP_OUT% done.
    echo Cleanup %_CMP_OUT% done.>>%_LOGFILE%
)

:CT

if "%_CMPENGINE%" EQU "NMT" (goto :END)

if not defined _CMP_OUT_CT (
    echo Compare Ct output folder parameter not defined!
    echo Compare Ct output folder parameter not defined! >>%_LOGFILE%
    set _CLEANUPERROR=3
    goto :END
)
if not exist %_CMP_OUT_CT% (
    echo Compare Ct output folder doesn't exist, creating a new one.
    echo Compare Ct output folder doesn't exist, creating a new one. >>%_LOGFILE%
    md %_CMP_OUT_CT% >>%_LOGFILE%
    if %ERRORLEVEL% NEQ 0 (set _CLEANUPERROR=4)
    goto :END
) else (
    echo Deleting %_CMP_OUT_CT%
    echo Deleting %_CMP_OUT_CT%>>%_LOGFILE%

    del /F/Q/S %_CMP_OUT_CT%\*.* >nul 2>&1
    rd /Q/S %_CMP_OUT_CT%        >>%_LOGFILE% 2>&1
    md %_CMP_OUT_CT%             >>%_LOGFILE%

    echo Cleanup %_CMP_OUT_CT% done.
    echo Cleanup %_CMP_OUT_CT% done. >>%_LOGFILE%
)

:END

echo Cleanup status: %_CLEANUPERROR%
echo Cleanup status: %_CLEANUPERROR% >>%_LOGFILE%

goto :eof
