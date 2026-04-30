REM -----------------------------------------------------------------------
REM --- Initiate logging --------------------------------------------------
REM -----------------------------------------------------------------------

REM --- Global helpers ---
REM G_KILLILL

REM Following variables must be already defined:

REM --- Global variables ---
REM _ROOT - Tester's root folder

REM --- Tester specific variables
REM _TOPIC - Tester's name or abbreviation
REM _LOGFOLDER

REM Following variables are set by this subroutine:
REM _LOGFILE

call %G_GETSAFEDATE% _SAFEDATE

IF NOT EXIST "%_LOGFOLDER%" (md "%_LOGFOLDER%")

REM Define the log file
set "_LOGFILE=%_LOGFOLDER%\%_TOPIC%_%_SAFEDATE%.log"

REM Start logging
echo --- %_TIMESTAMP% >%_LOGFILE%
echo --- Starting script... >>%_LOGFILE%
echo %_TOPIC% Automated Tester Started. >>%_LOGFILE%
echo %_TOPIC% Automated Tester Started. 
echo.  >>%_LOGFILE%
echo.
goto :eof
