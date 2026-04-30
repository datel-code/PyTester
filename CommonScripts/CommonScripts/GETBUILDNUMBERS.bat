REM -----------------------------------------------------------------------
REM --- Get build numbers from Ai, Homer and Neo ModelTest ----------------
REM -----------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM _PLUGINSOURCEFOLDER - Plugins depository root folder on Homer
REM _NDLPLUGINSOURCEFOLDER - NDL Plugins depository root folder on Homer
REM _NMTROOT - NeoModelTest exe base folder

REM _LOGFILE - Common Log file

REM _GTMP

call %G_TIMESTAMP%

set _BUILDNUMBERFILE=%_PLUGINSOURCEFOLDER%\buildnumber.txt
set _NDLBUILDNUMBERFILE=%_NDLPLUGINSOURCEFOLDER%\buildnumber.txt

echo ^>Entering GETBUILDNUMBERS.bat >>%_LOGFILE%
echo ^>Entering GETBUILDNUMBERS.bat

REM Connect to servers
set _PPATH=c:\Esko
call :CONNECTTOSERVER

REM Get day variable for distinguishing builds with same numbers
set _DAY=%date:~6,2%
echo Day: %_DAY%

set _KITINFOTMPFILE=%_GTMP%\kitinfo.tmp
echo Getting the build numbers...
echo Getting the build numbers... >>%_LOGFILE%

REM Test if the build number file exists
for /f "delims=" %%a in ('powershell "Test-Path %_BUILDNUMBERFILE% -PathType Leaf"') do Set "_PSRESULT=%%a"
IF "%_PSRESULT%" == "False" (
	echo The build number file cannot be found. >>%_LOGFILE%
	echo The build number file cannot be found. 
    goto :BuildNoNotFound
)
set _BUILDNUMBER=N/A
set /p _RAWBUILDNUMBER=<%_BUILDNUMBERFILE%
for /f "delims=" %%i in ('echo %_RAWBUILDNUMBER%') do set _BUILDNUMBER=%%i 
call :TRIMBUILDNO %_BUILDNUMBER% _BUILDNUMBER


rem set _BUILDNUMBER=4b

REM For NMT reporter - create build number with leading spaces and added day of month
set "_FILLED_BUILDNUMBER=    %_BUILDNUMBER%"
set _FILLED_BUILDNUMBER=%_FILLED_BUILDNUMBER:~-3%
set _FULLBUILDNUMBER=%_MAJORVERSION%.%_FILLED_BUILDNUMBER%-%_DAY%

rem set _FULLBUILDNUMBER=%_MAJORVERSION%.%_BUILDNUMBER%

:BuildNoNotFound
echo Build number: [%_MAJORVERSION%.]%_BUILDNUMBER%
echo Build number: [%_MAJORVERSION%.]%_BUILDNUMBER% >>%_LOGFILE%

set _NDLBUILDNUMBER=N/A
REM Test if the build number file exists
for /f "delims=" %%a in ('powershell "Test-Path %_NDLBUILDNUMBERFILE% -PathType Leaf"') do Set "_PSRESULT=%%a"
IF "%_PSRESULT%" == "False" (
	echo The NDL build number file cannot be found. >>%_LOGFILE%
	echo The NDL build number file cannot be found. 
    goto :NDLBuildNoNotFound
)
set /p _RAWBUILDNUMBER=<%_NDLBUILDNUMBERFILE%
for /f "delims=" %%i in ('echo %_RAWBUILDNUMBER%') do set _NDLBUILDNUMBER=%%i 
call :TRIMBUILDNO %_NDLBUILDNUMBER% _NDLBUILDNUMBER

REM For NMT reporter - create build number with leading spaces and added day of month
set "_FILLED_NDLBUILDNUMBER=    %_NDLBUILDNUMBER%"
set _FILLED_NDLBUILDNUMBER=%_FILLED_NDLBUILDNUMBER:~-3%
set _FULLNDLBUILDNUMBER=%_MAJORVERSION%.%_FILLED_NDLBUILDNUMBER%-%_DAY%

rem set _FULLNDLBUILDNUMBER=%_MAJORVERSION%.%_NDLBUILDNUMBER%
:NDLBuildNoNotFound
echo NDL Build number: [%_MAJORVERSION%.]%_NDLBUILDNUMBER%
echo NDL Build number: [%_MAJORVERSION%.]%_NDLBUILDNUMBER% >>%_LOGFILE%

type %_NMTROOT%\uninstall\bpuninstall\kitinfo.dat | find "KITIDENT" > %_KITINFOTMPFILE%

set _NMTBUILDNUMBER=N/A
for /f "delims=" %%x in ('type %_KITINFOTMPFILE%') do set "Var=%%x"
set _NMTBUILDNUMBER=%Var:~22,12%
del %_KITINFOTMPFILE%
echo NMT Build number: %_NMTBUILDNUMBER%
echo NMT Build number: %_NMTBUILDNUMBER% >>%_LOGFILE%

echo Ai build: %_AIBUILD%
echo Ai build: %_AIBUILD% >>%_LOGFILE%

goto :eof

:TRIMBUILDNO
set %2=%1
goto :eof

REM -------------------------------------------------------------------------------------------------------------------- Connect to servers

:CONNECTTOSERVER
echo Checking servers... >>%_LOGFILE%
echo Checking servers... 

echo Checking presence of %_PLUGINSOURCEFOLDER%\buildnumber.txt >>%_LOGFILE%
echo Checking presence of %_PLUGINSOURCEFOLDER%\buildnumber.txt

if exist "%_PLUGINSOURCEFOLDER%\buildnumber.txt" (
echo Servers seem to be connected. >>%_LOGFILE%
echo Servers seem to be connected.
goto :eof
)

echo Trying to re-connect... >>%_LOGFILE%
echo Trying to re-connect... 
set /p _PWD= < %_PPATH%\PWD
rem echo %_PWD%

net use H: \\homer\deskpackplugins /user:esko-graphics\tota %_PWD% >>%_LOGFILE% 2>&1

if "%ERRORLEVEL%" NEQ "0" (
echo Trying to re-connect again... >>%_LOGFILE%
echo Trying to re-connect again... 
net use H: /delete /y >>%_LOGFILE% 2>&1
net use H: \\homer\deskpackplugins /user:esko-graphics\tota %_PWD% >>%_LOGFILE% 2>&1
)

if "%ERRORLEVEL%" NEQ "0" (
	echo Something wrong with server connection! >>%_LOGFILE%
	echo Something wrong with server connection! 
    EXIT /B 99
	)
goto :eof
