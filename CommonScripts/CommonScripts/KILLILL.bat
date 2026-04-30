REM -----------------------------------------------------------------------
REM ---------------------- Adobe Illustrator Killer -----------------------
REM -----------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global helpers ---
REM G_TIMESTAMP

REM --- Global variables ---
REM _LOGFILE

call %G_TIMESTAMP%

echo ^>Entering KILLILL.bat>>%_LOGFILE%
echo ^>Entering KILLILL.bat

echo Checking if Illustrator is running... >>%_LOGFILE%
echo Checking if Illustrator is running... 

set /A COUNTTOT=1
set /A COUNT=0

tasklist /FI "IMAGENAME eq illustrator.exe" 2>NUL | find /I /N "illustrator.exe">NUL
if "%ERRORLEVEL%"=="128" (
	echo Illustrator is already killed.
	EXIT /B 0
	)
if "%ERRORLEVEL%"=="0" taskkill /f /im illustrator.exe /T >>%_LOGFILE%

:CHECK

if %COUNTTOT%==5 goto :CANNOTQUITTOT

if %COUNT%==10 goto :CANNOTQUIT
set /A COUNT=COUNT+1
echo Checking if Illustrator is running. %COUNT%... >>%_LOGFILE%
timeout /T 3 > nul
tasklist /FI "IMAGENAME eq illustrator.exe" 2>NUL | find /I /N "illustrator.exe">NUL
if "%ERRORLEVEL%"=="0" goto :CHECK
goto :eof

:CANNOTQUIT
echo Cannot quit Illustrator gracefully, trying to kill. Attempt no. %COUNTTOT% >>%_LOGFILE%
taskkill /f /im illustrator.exe /T >>%_LOGFILE%
timeout /T 5 >nul
set /A COUNTTOT=COUNTTOT+1
set /A COUNT=0
goto :CHECK

:CANNOTQUITTOT
echo Illustrator still runnig. >>%_LOGFILE%
EXIT /B 99
