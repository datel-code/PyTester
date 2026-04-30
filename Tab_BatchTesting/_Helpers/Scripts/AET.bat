@echo off

REM ------------------------------------------------------------------------------------------
REM --- Automated Esko Tester ----------------------------------------------------------------
REM ------------------------------------------------------------------------------------------

set REGIME=%1

REM Tester's root path
for /f "delims== tokens=1,2" %%G in (.\%~n0.cfg) do set %%G=%%H

set _ROOT=%_UNC_ROOT_SERVER%\%_TESTERFOLDER%

echo ================================================================================================
echo === Tester: %_MAINTOPIC%
echo === Starting %_LAUNCHER% in %_ROOT% (DOS drive %_DOS_ROOT_SERVER%)
echo === Global helpers' path: %_GLOBALHELPERSFOLDER%
if "%REGIME%" NEQ "AUTO" (
    echo === Manual run.
) else (
    echo === Automatic run.
)
echo ================================================================================================ 
echo. 
call .\Specific\%_LAUNCHER%.bat
