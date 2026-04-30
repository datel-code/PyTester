REM -----------------------------------------------------------------------
REM ----------------------- NDL ModelTest Restart -------------------------
REM -----------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global helpers ---
REM G_TIMESTAMP

REM --- Global variables ---
REM _LOGFILE

call %G_TIMESTAMP%

echo.
echo.>>%_LOGFILE%
echo ^>Entering RESTART_NMT.bat>>%_LOGFILE%
echo ^>Entering RESTART_NMT.bat


REM --- NDL ModelTest App ---------------------------------------------------------------

set /A COUNT=0
echo on

:CHECK
if %COUNT%==10 goto :CANNOTQUIT
set /A COUNT=COUNT+1
echo Checking if NDLModelTestReportServer is running... Attempt %COUNT% >>%_LOGFILE%
echo Checking if NDLModelTestReportServer is running... Attempt %COUNT%

tasklist /FI "IMAGENAME eq NDLModelTestReportServer.exe" 2>NUL | find /I /N "NDLModelTestReportServer">NUL
echo %ERRORLEVEL%
if "%ERRORLEVEL%"=="128" (
	echo NDLModelTestReportServer is already killed.
    call :launchNMT
	EXIT /B 0
	)
if "%ERRORLEVEL%"=="1" (
	echo NDLModelTestReportServer is already killed.
    call :launchNMT
	EXIT /B 0
	)
if "%ERRORLEVEL%"=="0" (
	echo NMT process found running. Going to kill it.
	call :killNMT
	)

goto :CHECK


:CANNOTQUIT
echo Cannot kill NDLModelTestReportServer. >>%_LOGFILE%
echo Cannot kill NDLModelTestReportServer. 
EXIT /B 99

:launchNMT
REM Launch NDLModelTest
start %_NMTRSEXE%
rem start %_NMTEXE%
goto :eof


:killNMT
echo Killing NDLModelTestReportServer... >>%_LOGFILE%
echo Killing NDLModelTestReportServer... 
taskkill /f /im NDLModelTestReportServer.exe /T >>%_LOGFILE%
timeout /T 3 > nul
goto :eof
