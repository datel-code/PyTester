@echo off

REM ------------------------------------------------------------------------------------------
REM --- Dynamic Tables Automatic Tester ------------------------------------------------------
REM ------------------------------------------------------------------------------------------

REM Global script and parameter folders
set _GLOBALSCRIPTSFOLDER=%_GLOBALHELPERSFOLDER%\CommonScripts
set _GLOBALPARAMETERSFOLDER=%_GLOBALSCRIPTSFOLDER%\Parameters

REM Set Global and Common Parameters
call %_GLOBALPARAMETERSFOLDER%\Parameters-GLOBAL.bat
call %_GLOBALPARAMETERSFOLDER%\Parameters-COMMON.bat

REM Global script topic
set _TOPIC=%_MAINTOPIC%

REM Perform initial tasks
call %G_STARTLOGGING%
call %G_GETBUILDNUMBERS%

REM Set specific parameters and perform specific tasks
call %_PARAMETERSFOLDER%\Parameters-Tab.bat

REM Check the output folders
if not exist %_PROCESSEDFOLDER% (MD %_PROCESSEDFOLDER%)
if %errorlevel% NEQ 0 (
    echo Processing folder doesn't exist and cannot be created! >>%_LOGFILE%
    echo Processing folder doesn't exist and cannot be created! 
    goto :ERREND
)
if not exist %_OUTFOLDER% (MD %_OUTFOLDER%)
if %errorlevel% NEQ 0 (
    echo Output folder doesn't exist and cannot be created! >>%_LOGFILE%
    echo Output folder doesn't exist and cannot be created! 
    goto :ERREND
)

call %COLLECTTICKETS% %_TASKFILETYPE%

REM Set Common Parameters
if "%_CMPENGINE%" EQU "NMT" (call %P_NMTCompare%)
if "%_CMPENGINE%" EQU "EGC" (call %P_EGCompare%)
call %P_Statistics%
call %P_Transform%
set _CLEANUPERROR=0

REM !!! P_Mailer needs be run after processing logs

REM --- Start -------------------------------------------------------------------------------

title %_TOPIC%: %_AIVERSION%, %_DPVERSION%, b. %_BUILDNUMBER%/NDL b. %_NDLBUILDNUMBER%

call %G_UPDATEALLPLUGINS%

call %G_PROCESSOR% Tab_Generation
if %_CLEANUPERROR% NEQ 0 goto :ERREND

REM -------------------------------------------------------------------------------------------------

call %G_COMPARER%
call %G_REPORTING%

echo %_TOPIC% Automated Tester finished. >>%_LOGFILE%
echo %_TOPIC% Automated Tester finished.

if "%REGIME%" NEQ "AUTO" goto :ASKBEFOREFINALQUIT

call %G_KILLILL%
call %G_TIMESTAMP%
goto :FINALQUIT

:ASKBEFOREFINALQUIT
set /P _ANSWER=Kill Illustrator at the end? (Y/N)?
if /i {%_ANSWER%} NEQ {y} (goto :FINALQUIT)
call %G_KILLILL%
call %G_TIMESTAMP%
pause

:FINALQUIT
echo. >>%_LOGFILE%
echo. 
echo ================================================================================================ >>%_LOGFILE%
echo ================================================================================================ 
echo ================================================================================================ >>%_LOGFILE%
echo ================================================================================================ 
goto :eof

REM ### End #########################################################################################


REM vvv Dead end ************************************************************************************

:ERREND

echo. >>%_LOGFILE%
echo %_TOPIC% Automated Tester failed! >>%_LOGFILE%
call %G_TIMESTAMP%
goto :eof

REM ^^^ Dead end ************************************************************************************


