@echo off
REM Global plugins updater

REM Define working path
REM set _MAINPATH=%~dp0
REM IF %_MAINPATH:~-1%==\ SET _MAINPATH=%_MAINPATH:~0,-1%

call %G_TIMESTAMP%

REM Connect to servers
set _PPATH=D:\PWD
call :CONNECTTOSERVER

call %G_KILLILL%

if "%ERRORLEVEL%"=="99" (
	echo Illustrator still running, cannot continue. >>%_LOGFILE%
	echo Illustrator still running, cannot continue. 
	goto :ERREND
	)

call %G_TIMESTAMP%
echo. >>%_LOGFILE%
echo.
echo Copying plugins... >>%_LOGFILE%
echo Copying plugins...

REM Start parsing the list of files and copying

SETLOCAL ENABLEDELAYEDEXPANSION

set COPYOK=1
for /F "tokens=1,2 skip=1 delims=," %%G IN (%_PLUGINSLISTFILE%) DO (
    if %%G EQU SKIP (
        echo Skipping %%H...
        echo Skipping %%H...>>%_LOGFILE%
        )
    if %%G NEQ SKIP (
        set _SUBTYPE=
        if %%G EQU AI (set _SUBTYPE=\Esko)
        set _THISPLUGINSOURCEFOLDER=%_PLUGINSFOLDERSOURCE%\%%G\Win_%_AIVERSION%!_SUBTYPE!\%%H
        set _THISPLUGINDESTINATION=%_PLUGINSFOLDERDESTINATION%\%%H
        
        echo Copying from !_THISPLUGINSOURCEFOLDER! >>%_LOGFILE%
        echo to !_THISPLUGINDESTINATION! >>%_LOGFILE%
        echo Copying from !_THISPLUGINSOURCEFOLDER! 
        echo to !_THISPLUGINDESTINATION!
        
        if not exist "!_THISPLUGINDESTINATION!" md "!_THISPLUGINDESTINATION!"
        robocopy /S /XO /Z /R:0 /W:0 /NJH /NJS /NP /NDL "!_THISPLUGINSOURCEFOLDER!" "!_THISPLUGINDESTINATION!" "*.*" >>%_LOGFILE% 2>&1
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

:COPYBUNDLES
REM Updating bundles
call %G_TIMESTAMP%
echo. >>%_LOGFILE%
echo.
echo Copying bundles... >>%_LOGFILE%
echo Copying bundles...

set _THISPLUGINSOURCEFOLDER=%_PLUGINSFOLDERSOURCE%\Localisation_Win\Esko
set _THISPLUGINDESTINATION=%_BUNDLESFOLDERDESTINATION%
echo Copying from %_THISPLUGINSOURCEFOLDER% >>%_LOGFILE%
echo to %_THISPLUGINDESTINATION% >>%_LOGFILE%
echo Copying from %_THISPLUGINSOURCEFOLDER% 
echo to %_THISPLUGINDESTINATION%

robocopy /S /XO /Z /R:0 /W:0 /NJH /NJS /NP /NDL "%_THISPLUGINSOURCEFOLDER%" "%_THISPLUGINDESTINATION%" "*.*" >>%_LOGFILE% 2>&1
set _ERR=%ERRORLEVEL%
if %ERRORLEVEL% EQU 1 (
    echo --- Copied.
    echo --- Copied. >>%_LOGFILE%
    ) else (
    if %ERRORLEVEL% EQU 0 (
        echo *** Nothing to copy.
        echo *** Nothing to copy. >>%_LOGFILE%
        ) else (
        echo ### !_ERR! Difference or error! 
        echo ### !_ERR! Difference or error! >>%_LOGFILE%
        set COPYOK=%ERRORLEVEL%
        )
    )
)

if %COPYOK% EQU 0 goto :ERREND

:ALLDONE
call %G_TIMESTAMP%
echo Plugin extraction finished without error.>>%_LOGFILE%
echo Plugin extraction finished without error.
echo.
echo. >>%_LOGFILE%

exit /B 0
REM ---------------------------------------------------------------------------------------------------------------------------- Bad ends here

:ERREND
echo Error: %ERRORLEVEL%
echo Cannot extract some new plugins! >>%_LOGFILE%
echo Cannot extract some new plugins! 

EXIT /B 99

REM ---------------------------------------------------------------------------------------------------------------------------- Good ends here

:END
echo Plugin extraction finished without error.>>%_LOGFILE%
echo Plugin extraction finished without error.

exit /B 0

REM -------------------------------------------------------------------------------------------------------------------- Connect to servers

:CONNECTTOSERVER
echo Checking servers... >>%_LOGFILE%
echo Checking servers... 

echo Checking presence of %_PLUGINSFOLDERSOURCE%\buildnumber.txt >>%_LOGFILE%
echo Checking presence of %_PLUGINSFOLDERSOURCE%\buildnumber.txt

if exist "%_PLUGINSFOLDERSOURCE%\buildnumber.txt" (
echo Servers seem to be connected. >>%_LOGFILE%
echo Servers seem to be connected.
goto :eof
)

echo Trying to re-connect... >>%_LOGFILE%
echo Trying to re-connect... 
set /p _PWD= < %_P  %\PWD
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
