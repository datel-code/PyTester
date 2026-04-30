REM -----------------------------------------------------------------------
REM ----------------------- Global plugins updater ------------------------
REM -----------------------------------------------------------------------

if "%REGIME%" EQU "AUTO" goto :UPDATING

set /P _ANSWER=Update all plugins (Y/N)?
if /i {%_ANSWER%}=={y} (
    goto :UPDATING
) else (
    goto :eof
)

:UPDATING

set UPDATE_REGIME=%1

if "%UPDATE_REGIME%"=="STANDALONE" (
    echo off
    set _GLOBALHELPERSFOLDER=\\ESKW180139\CommonHelpers
    set _GLOBALSCRIPTSFOLDER=%_GLOBALHELPERSFOLDER%\CommonScripts
    set _GLOBALPARAMETERSFOLDER=%_GLOBALSCRIPTSFOLDER%\Parameters
    set _LOGFILE=%_GLOBALSCRIPTSFOLDER%\Logging\GlobalPluginsUpdater.log
)

if "%UPDATE_REGIME%"=="STANDALONE" (
    call %_GLOBALPARAMETERSFOLDER%\Parameters-GLOBAL.bat
    call %_GLOBALPARAMETERSFOLDER%\Parameters-COMMON.bat
    echo ^>Entering UPDATEALLPLUGINS.bat /%_TOPIC%/>%_LOGFILE%
) else (
    echo ^>Entering UPDATEALLPLUGINS.bat /%_TOPIC%/>>%_LOGFILE%
    echo ^>Entering UPDATEALLPLUGINS.bat /%_TOPIC%/
)

call %G_TIMESTAMP%

SETLOCAL ENABLEDELAYEDEXPANSION
for /F %%R IN (%_PLUGINSLISTFILE%) DO (
    if "%%R" EQU "RUN" (
        goto :RUN_UPDATE
        ) else (
        goto :SKIP_UPDATE
        )
    )

:RUN_UPDATE
    
REM Connect to servers
set _PPATH=c:\Esko
call :CONNECTTOSERVER

call %G_KILLILL%

if "%ERRORLEVEL%"=="99" (
	echo Illustrator still running, cannot continue. >>%_LOGFILE%
	echo Illustrator still running, cannot continue. 
	goto :ERREND
	)

call %G_TIMESTAMP%

rem goto :COPYBUNDLE

echo. >>%_LOGFILE%
echo.
echo Copying plugins... >>%_LOGFILE%
echo Copying plugins...

REM Start parsing the list of files and copying

set COPYOK=1
for /F "tokens=1,2 skip=2 delims=," %%G IN (%_PLUGINSLISTFILE%) DO (
    if %%G EQU SKIP (
        echo Skipping %%H...
        echo Skipping %%H...>>%_LOGFILE%
        )
    if %%G NEQ SKIP (
        set _SUBTYPE=
        if %%G EQU AI (set _SUBTYPE=\Esko)
        set _THISPLUGINSOURCEFOLDER=%_PLUGINSOURCEFOLDER%\%%G\Win_%_AIVERSION%!_SUBTYPE!\%%H
        set _THISPLUGINDESTINATION=%_PLUGINDESTINATIONFOLDER%\%%H
        
        echo Copying from !_THISPLUGINSOURCEFOLDER! >>%_LOGFILE%
        echo to !_THISPLUGINDESTINATION! >>%_LOGFILE%
        echo Copying from !_THISPLUGINSOURCEFOLDER! 
        echo to !_THISPLUGINDESTINATION!
        
        if not exist "!_THISPLUGINDESTINATION!" md "!_THISPLUGINDESTINATION!"
        robocopy /S /XO /Z /R:3 /W:0 /NJH /NJS /NP /NDL "!_THISPLUGINSOURCEFOLDER!" "!_THISPLUGINDESTINATION!" "*.*" >>%_LOGFILE% 2>&1
        set _ERR=!ERRORLEVEL!
        if !ERRORLEVEL! EQU 1 (
            echo --- Copied.
            echo --- Copied. >>%_LOGFILE%
            ) else (
            if !ERRORLEVEL! EQU 0 (
                echo *** Nothing to copy.
                echo *** Nothing to copy. >>%_LOGFILE%
                ) else (
                echo ### !_ERR! Difference or error! 
                echo ### !_ERR! Difference or error! >>%_LOGFILE%
                set COPYOK=!ERRORLEVEL!
                )
            )
        )
    )

if %COPYOK% EQU 0 goto :ERREND

:COPYBUNDLE
REM Updating bundles
call %G_TIMESTAMP%
echo. >>%_LOGFILE%
echo.

echo Copying bundles archive from %_BUNDLESOURCEFOLDER% >>%_LOGFILE%
echo to %_BUNDLEDESTINATIONFOLDER% >>%_LOGFILE%
echo Copying bundles archive from %_BUNDLESOURCEFOLDER% 
echo to %_BUNDLEDESTINATIONFOLDER%

robocopy /Z /R:3 /W:0 /NJH /NJS /NP /NDL "%_BUNDLESOURCEFOLDER%" "%_BUNDLEDESTINATIONFOLDER%" "*Win_Localisation.7z" >>%_LOGFILE% 2>&1

IF %ERRORLEVEL% EQU 0 (
	echo No new bundles found... >>%_LOGFILE%
	echo No new bundles found... 
)

IF %ERRORLEVEL% GTR 7 (
    echo Copying bundles using Robocopy finished with error %ERRORLEVEL% >>%_LOGFILE%
    echo Copying bundles using Robocopy finished with error %ERRORLEVEL%
    goto :ERREND
)

:EXTRACTBUNDLE
set _DIRCMD=dir "%_BUNDLEDESTINATIONFOLDER%\*.7z"
for /F "delims=" %%x in ('%_DIRCMD% /O:-D /B') do (
    set "_BUNDLEARCHIVEFILE=%_BUNDLEDESTINATIONFOLDER%\%%x"
    goto :ENDBUNDLEARCHIVE
    )
:ENDBUNDLEARCHIVE

echo Extracting bundles archive from %_BUNDLEARCHIVEFILE% >>%_LOGFILE%
echo to %_BUNDLEDESTINATIONFOLDER% >>%_LOGFILE%
echo Extracting bundles archive from %_BUNDLEARCHIVEFILE% 
echo to %_BUNDLEDESTINATIONFOLDER%

echo Running:
echo %_7Zip% x "%_BUNDLEARCHIVEFILE%" -aoa -o"%_BUNDLEDESTINATIONFOLDER%\.."
echo Running: >>%_LOGFILE%
echo %_7Zip% x "%_BUNDLEARCHIVEFILE%" -aoa -o"%_BUNDLEDESTINATIONFOLDER%\.."%\ >>%_LOGFILE%
%_7Zip% x "%_BUNDLEARCHIVEFILE%" -aoa -o"%_BUNDLEDESTINATIONFOLDER%\.."

REM ---------------------------------------------------------------------------------------------------------------------------- Good ends here
:ALLDONE
ENDLOCAL

call %G_TIMESTAMP%
echo Plugin extraction finished without error.>>%_LOGFILE%
echo Plugin extraction finished without error.
echo.
echo. >>%_LOGFILE%

set "_WARNING_UPDATESKIPPED= (plugins updated)"

exit /B 0
REM ---------------------------------------------------------------------------------------------------------------------------- Bad ends here

:ERREND
ENDLOCAL

echo Error: %ERRORLEVEL%
echo Cannot extract some new plugins! >>%_LOGFILE%
echo Cannot extract some new plugins!

del %_GTMP%\fakecopy.tmp>nul

EXIT /B 99

REM ---------------------------------------------------------------------------------------------------------------------------- Skip update

:SKIP_UPDATE
ENDLOCAL

echo Update skipped !!! >>%_LOGFILE%
echo Update skipped !!!
set "_WARNING_UPDATESKIPPED= - PLUGIN UPDATE SKIPPED!"

exit /B 0

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
