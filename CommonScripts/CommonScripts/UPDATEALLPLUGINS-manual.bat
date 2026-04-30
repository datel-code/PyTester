@echo off
REM Global plugins updater

REM Define working path
set _ROOT=%~dp0
IF %_ROOT:~-1%==\ SET _ROOT=%_ROOT:~0,-1%

set _PLUGINSLISTFILE="%~dp0\Parameters\Parameters-Update.txt"
set _7Zip="T:\CommonHelpers\7z\7za.exe"

REM Application paths and versions
set _AIFOLDER="Adobe Illustrator CC 2019"
set _AIVERSION=AI23
set _DPVERSION=18_A5

REM Plugin sources
set _PLUGINSOURCEFOLDER=h:\DeskPack%_DPVERSION%
set _LOCALPLUGINPACKSOURCEFOLDER=z:\DP%_DPVERSION%\Current
set _BUNDLESOURCEFOLDER=h:\DeskPack%_DPVERSION%\Archive
REM ---> Only for getting the build number
set _NDLPLUGINSOURCEFOLDER=h:\DeskPack%_DPVERSION%\NDL
REM <---
set "_PLUGINDESTINATIONFOLDER=c:\Program Files\Adobe\%_AIFOLDER%\Plug-ins"
set _PLUGINDESTINATIONFOLDER=%_PLUGINDESTINATIONFOLDER:"=%
set "_BUNDLEDESTINATIONFOLDER=c:\Program Files\Adobe\%_AIFOLDER%"
set _BUNDLEDESTINATIONFOLDER=%_BUNDLEDESTINATIONFOLDER:"=%
set _PLUGINTMPFOLDER=%TMP%\EskoPluginTMP

REM Connect to servers
set _PPATH=D:\PWD
call :CONNECTTOSERVER

call KILLILL-NoLog.bat

if "%ERRORLEVEL%"=="99" (
	echo Illustrator still running, cannot continue. 
	goto :ERREND
	)

echo.
echo Copying plugins...
REM Check whether the plugin local archive is up to date

if not exist %_LOCALPLUGINPACKSOURCEFOLDER% (
    echo Source %_LOCALPLUGINPACKSOURCEFOLDER% not available!
    goto :ERREND
    )
xcopy "%_LOCALPLUGINPACKSOURCEFOLDER%\*Win_%_AIVERSION%.7z" "%_PLUGINDESTINATIONFOLDER%" /D /I /H /R /Y /Z /C /L > %TMP%\fakecopy.tmp

findstr /B "0 File" %TMP%\fakecopy.tmp

IF %ERRORLEVEL% EQU 0 (
    echo Plugin's archove is up to date, nothing to copy.
    goto :EXTRACTPLUGINS
    )

echo Deleting plugins archive "%_PLUGINDESTINATIONFOLDER%\*.7z"

del "%_PLUGINDESTINATIONFOLDER%\*.7z"

echo Copying plugins archive from %_LOCALPLUGINPACKSOURCEFOLDER% 
echo to %_PLUGINDESTINATIONFOLDER% 

robocopy /Z /R:0 /W:0 /NJH /NJS /NP /NDL "%_LOCALPLUGINPACKSOURCEFOLDER%" "%_PLUGINDESTINATIONFOLDER%" "*Win_%_AIVERSION%.7z"  2>&1

set _ERR=%ERRORLEVEL%
if %ERRORLEVEL% EQU 1 (
    echo --- Archive copied.
    echo --- Archive copied. 
    ) else (
    echo ### %_ERR% Something wrong happened! 
    echo ### %_ERR% Something wrong happened 
    goto :ERREND
    )

:EXTRACTPLUGINS
set _DIRCMD=dir "%_PLUGINDESTINATIONFOLDER%\*.7z"
for /F "delims=" %%x in ('%_DIRCMD% /O:-D /B') do (
    set "_PLUGINARCHIVEFILE=%_PLUGINDESTINATIONFOLDER%\%%x"
    goto :EXTRACTPLUGINSTESTEND
    )
:EXTRACTPLUGINSTESTEND

echo Deleting old TMP
del /F/Q/S %_PLUGINTMPFOLDER%\*.* > nul
rd /Q/S %_PLUGINTMPFOLDER%\Esko > nul

echo Extracting plugins archive from %_PLUGINARCHIVEFILE% 
echo to %_PLUGINTMPFOLDER% 

if not exist %_PLUGINTMPFOLDER% MD %_PLUGINTMPFOLDER%

%_7Zip% x "%_PLUGINARCHIVEFILE%" -aoa -o"%_PLUGINTMPFOLDER%" >nul

REM Start parsing the list of files and copying


SETLOCAL ENABLEDELAYEDEXPANSION

set COPYOK=1
for /F "usebackq tokens=1,2 skip=1 delims=," %%G IN (%_PLUGINSLISTFILE%) DO (

    echo %%G, %%H
    if %%G EQU AI (
        set _THISPLUGINSOURCEFOLDER=%_PLUGINTMPFOLDER%\Esko\%%H
        set _THISPLUGINDESTINATION=%_PLUGINDESTINATIONFOLDER%\Esko\%%H
        )
    if %%G EQU NDL (
        set _THISPLUGINSOURCEFOLDER=%_PLUGINSOURCEFOLDER%\%%G\Win_%_AIVERSION%\%%H
        set _THISPLUGINDESTINATION=%_PLUGINDESTINATIONFOLDER%\Esko\%%H
        )
    if %%G EQU SKIP (
        echo Skipping %%H...
        ) else (
        echo Copying !_THISPLUGINSOURCEFOLDER!
        if not exist "!_THISPLUGINDESTINATION!" md "!_THISPLUGINDESTINATION!"
        robocopy /S /XO /Z /R:0 /W:0 /NJH /NJS /NP /NDL "!_THISPLUGINSOURCEFOLDER!" "!_THISPLUGINDESTINATION!" "*.*"  2>&1
        echo Result: !ERRORLEVEL!
        if !ERRORLEVEL! EQU 1 (
            echo --- Copied.
            ) else (
            if !ERRORLEVEL! EQU 0 (
                echo *** Nothing to copy.
                ) else (
                echo ### Difference or error!
                )
            )
        )
    )

if %COPYOK% EQU 0 goto :ERREND

REM Updating bundles
echo.
echo Copying bundles...

REM Check whether the bundle archive is up to date
xcopy "%_BUNDLESOURCEFOLDER%\*Win_Localisation.7z" "%_BUNDLEDESTINATIONFOLDER%" /D /I /H /R /Y /Z /C /L > %TMP%\fakecopy.tmp
findstr /B "0 File" %TMP%\fakecopy.tmp
IF %ERRORLEVEL% EQU 0 (
    echo Bundles are up to date.
    goto :ALLDONE
    )

echo Deleting bundles archive "%_BUNDLEDESTINATIONFOLDER%\*.7z"

del "%_BUNDLEDESTINATIONFOLDER%\*.7z"

echo Copying bundles archive from %_BUNDLESOURCEFOLDER% 
echo to %_BUNDLEDESTINATIONFOLDER%

robocopy /Z /R:0 /W:0 /NJH /NJS /NP /NDL "%_BUNDLESOURCEFOLDER%" "%_BUNDLEDESTINATIONFOLDER%" "*Win_Localisation.7z" >>%_LOGFILE% 2>&1

set _ERR=%ERRORLEVEL%
if %ERRORLEVEL% EQU 1 (
    echo --- Archive copied.
    ) else (
    echo ### %_ERR% Something wrong happened! 
    goto :ERREND
    )
 

:EXTRACTBUNDLE
set _DIRCMD=dir "%_BUNDLEDESTINATIONFOLDER%\*.7z"
for /F "delims=" %%x in ('%_DIRCMD% /O:-D /B') do (
    set "_BUNDLEARCHIVEFILE=%_BUNDLEDESTINATIONFOLDER%\%%x"
    goto :ENDBUNDLEARCHIVE
    )
:ENDBUNDLEARCHIVE

echo Extracting bundles archive from %_BUNDLEARCHIVEFILE% 
echo to %_BUNDLEDESTINATIONFOLDER%

%_7Zip% x "%_BUNDLEARCHIVEFILE%" -aoa -o"%_BUNDLEDESTINATIONFOLDER%\.."

REM ---------------------------------------------------------------------------------------------------------------------------- Good ends here
:ALLDONE
call %G_TIMESTAMP%
echo Plugin extraction finished without error.
echo.

del %TMP%\fakecopy.tmp>nul
pause
exit /B 0
REM ---------------------------------------------------------------------------------------------------------------------------- Bad ends here

:ERREND
echo Error: %ERRORLEVEL%
echo Cannot extract some new plugins! 
pause
EXIT /B 99

REM -------------------------------------------------------------------------------------------------------------------- Connect to servers

:CONNECTTOSERVER
echo Checking servers... 

echo Checking presence of %_PLUGINSOURCEFOLDER%\buildnumber.txt

if exist "%_PLUGINSOURCEFOLDER%\buildnumber.txt" (
echo Servers seem to be connected.
goto :eof
)

echo Trying to re-connect... 
set /p _PWD= < %_P  %\PWD
net use H: \\homer\deskpackplugins /user:esko-graphics\tota %_PWD% 

if "%ERRORLEVEL%" NEQ "0" (
echo Trying to re-connect again... 
net use H: /delete /y 
net use H: \\homer\deskpackplugins /user:esko-graphics\tota %_PWD% 
)

if "%ERRORLEVEL%" NEQ "0" (
	echo Something wrong with server connection! 
    EXIT /B 99
	)
goto :eof
