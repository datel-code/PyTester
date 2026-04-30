@echo off

REM ------------------------------------------------------------------------------------------
REM --- Dynamic Tables Automatic Tester - MAC source -----------------------------------------
REM ------------------------------------------------------------------------------------------


REM --- Initialization -----------------------------------------------------------------------

set REGIME=%1
set MAILING=%2

REM Tester's root path
set _ROOT=\\ESKW210614\Tab_BatchTesting
set _MAC_ROOT=\\ESKW210614\Tab_BatchTesting
rem \\PRAMD003-HS\Data\BatchTesting\Tab_BatchTesting

REM Global script and parameter folders
set _GLOBALHELPERSFOLDER=\\ESKW210614\CommonHelpers
set _GLOBALSCRIPTSFOLDER=%_GLOBALHELPERSFOLDER%\CommonScripts
set _GLOBALPARAMETERSFOLDER=%_GLOBALSCRIPTSFOLDER%\Parameters

REM Global script topic
set _TOPIC=Tab-MAC

REM Set Global and Common Parameters
call %_GLOBALPARAMETERSFOLDER%\Parameters-GLOBAL.bat
call %_GLOBALPARAMETERSFOLDER%\Parameters-COMMON.bat

REM Mac Override !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
set _PARAMETERSFOLDER=%_HELPERSFOLDER%\Scripts\Parameters-MAC
call %_PARAMETERSFOLDER%\Parameters-COMMON-MAC.bat

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

REM --- Start --------------------------------------------------------------------------

title %_TOPIC%: %_AIVERSION%, %_DPVERSION%, b. %_BUILDNUMBER%/NDL b. %_NDLBUILDNUMBER%

REM -------------------------------------------------------------------------------------------------

call %G_COMPARER%
call %G_REPORTING%

echo %_TOPIC% Automated Tester finished. >>%_LOGFILE%
echo %_TOPIC% Automated Tester finished.
call %G_TIMESTAMP%

if "%REGIME%" NEQ "AUTO" (pause)
goto :eof

REM ### End #########################################################################################


REM vvv Dead end ************************************************************************************

:ERREND

echo. >>%_LOGFILE%
echo %_TOPIC% Automated Tester failed! >>%_LOGFILE%
call %G_TIMESTAMP%
goto :eof

REM ^^^ Dead end ************************************************************************************


