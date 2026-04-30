REM  Try to quit Illustrator if runs

echo Checking if Illustrator is running... 

set /A COUNTTOT=1
set /A COUNT=0

tasklist /FI "IMAGENAME eq illustrator.exe" 2>NUL | find /I /N "illustrator.exe">NUL
if "%ERRORLEVEL%"=="128" (
	echo Illustrator is already killed.
	EXIT /B 0
	)
if "%ERRORLEVEL%"=="0" taskkill /f /im illustrator.exe

:CHECK

if %COUNTTOT%==5 goto :CANNOTQUITTOT

if %COUNT%==10 goto :CANNOTQUIT
set /A COUNT=COUNT+1
echo Checking if Illustrator is running. %COUNT%... 
timeout /T 3 > nul
tasklist /FI "IMAGENAME eq illustrator.exe" 2>NUL | find /I /N "illustrator.exe">NUL
if "%ERRORLEVEL%"=="0" goto :CHECK
goto :eof

:CANNOTQUIT
echo Cannot quit Illustrator gracefully, trying to kill. Attempt no. %COUNTTOT% 
taskkill /f /im illustrator.exe 
timeout /T 5 >nul
set /A COUNTTOT=COUNTTOT+1
set /A COUNT=0
goto :CHECK

:CANNOTQUITTOT
echo Illustrator still runnig, cannot continue. 
EXIT /B 99
