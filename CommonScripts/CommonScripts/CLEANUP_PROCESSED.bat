REM -------------------------------------------------------------------
REM --- Deletes old log files and cleans a mess in Processed folder ---
REM --- Single/Multifolder version ------------------------------------
REM -------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM _LOGFILE - Common log file name

REM --- Tester specific variables
REM _TOPIC - Tester's name or abbreviation
REM _SOURCEFOLDER
REM _OUTFOLDER

REM --- Output variables
REM _CLEANUPERROR

call %G_TIMESTAMP%

echo ^>Entering CLEANUP_PROCESSED.bat /%_TOPIC%/>>%_LOGFILE%
echo ^>Entering CLEANUP_PROCESSED.bat /%_TOPIC%/

set _CLEANUPERROR=0

REM CLEANUP LEFTOVERS
echo Converting .inpfd and .ndl files back to pdf...
echo Converting .inpdf and .ndl files back to pdf...>>%_LOGFILE%

if "%_MULTIFOLDER_PROCESS%" NEQ "YES" (
    for /f "delims=" %%i in ('dir /b /s /a-d %_SOURCEFOLDER%\*.inpdf') do ren "%%~i" "%%~ni"
    for /f "delims=" %%i in ('dir /b /s /a-d %_SOURCEFOLDER%\*.ndl') do ren "%%~i" "%%~ni"
)

if "%_MULTIFOLDER_PROCESS%" EQU "YES" (
    setlocal EnableDelayedExpansion
    for /F "skip=1" %%j in (%_SUBTASKSLISTFILE%) do (
        echo Cleaning up %_SOURCEFOLDER%\%%j
        for /f "delims=" %%i in ('dir /b /s /a-d %_SOURCEFOLDER%\%%j\*.inpdf') do ren "%%~i" "%%~ni"
        for /f "delims=" %%i in ('dir /b /s /a-d %_SOURCEFOLDER%\%%j\*.ndl') do ren "%%~i" "%%~ni"
    )
)

REM CLEANUP PROCESSED

if not defined _OUTFOLDER (
    echo Output folder parameter not defined!
    echo Output folder parameter not defined! >>%_LOGFILE%
    set _CLEANUPERROR=1
    goto :END
)
if not exist %_OUTFOLDER% (
    echo Output folder doesn't exist, creating a new one.
    echo Output folder doesn't exist, creating a new one. >>%_LOGFILE%
    md %_OUTFOLDER% >>%_LOGFILE%
    if %ERRORLEVEL% NEQ 0 (set _CLEANUPERROR=2)
    goto :END
)
    
echo Deleting %_OUTFOLDER%
echo Deleting %_OUTFOLDER% >>%_LOGFILE%

del /F/Q/S %_OUTFOLDER%\*.* >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Some problem with deleting old files occurred!
    echo Some problem with deleting old files occurred! >>%_LOGFILE%
    set _CLEANUPERROR=3
    goto :END
)

rd /Q/S %_OUTFOLDER% >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Some problem with deleting old folder occurred!
    echo Some problem with deleting old folder occurred! >>%_LOGFILE%
    set _CLEANUPERROR=4
    goto :END
)

md %_OUTFOLDER% >>%_LOGFILE%

echo Cleanup %_OUTFOLDER% done.
echo Cleanup %_OUTFOLDER% done.>>%_LOGFILE%

:END

echo Cleanup status: %_CLEANUPERROR%
echo Cleanup status: %_CLEANUPERROR% >>%_LOGFILE%

goto :eof