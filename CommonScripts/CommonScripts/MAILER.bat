REM -----------------------------------------------------------------------
REM --- Mailer ------------------------------------------------------------
REM -----------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global helpers ---
REM G_TIMESTAMP
REM _MAIL_THEBLAT - Mailer EXE file

REM --- Global variables ---
REM _LOGFILE

REM --- Tester specific variables ---
REM _RECIPIENTS - Currently used list of recipients

REM _MAIL_ATTACHMENTS - What to attach
REM _MAIL_BODY

REM Dump stat values about no. of files

call %G_TIMESTAMP%

echo ^>Entering MAILER.bat>>%_LOGFILE%
echo ^>Entering MAILER.bat

REM ---------------------------------------------------------------------------------------------------------------------------- Send report using Blat

set /A _ATTEMPT=1

echo Sending the report %_MAIL_SUBJECT% >>%_LOGFILE%
echo to recipients %_RECIPIENTS% >>%_LOGFILE%
echo with attachments: %_MAIL_ATTACHMENTS% >>%_LOGFILE%
echo Sending the report %_MAIL_SUBJECT% 
echo to recipients: %_RECIPIENTS%
echo With attachments: %_MAIL_ATTACHMENTS%

:SENDAGAIN
echo Attempt %_ATTEMPT%... >>%_LOGFILE%
echo Attempt %_ATTEMPT%... 

%_THEBLAT% %_MAIL_BODY% %_MAIL_SUBJECT% -to %_RECIPIENTS% -f ESKW180139-BatchTest@esko.com -server smtpmail.esko-graphics.com -attach %_MAIL_ATTACHMENTS% >>%_LOGFILE% 2>&1

if %ERRORLEVEL% NEQ 0 (
    echo Mailing failed with result %ERRORLEVEL% >>%_LOGFILE%
    echo Mailing failed with result %ERRORLEVEL%
) else (
    echo Mailing done. >>%_LOGFILE%
    echo Mailing done.
    goto :THEEND
)
if %_ATTEMPT% GTR 5 (
    echo Giving up... >>%_LOGFILE%
    echo Giving up... 
    goto :THEEND
)
if %ERRORLEVEL% EQU 12 (
    echo Some attachment cannot be found, trying to send without generation logs. >>%_LOGFILE%
    echo Some attachment cannot be found, trying to send without generation logs. 
    set _MAIL_ATTACHMENTS="%_LOGFILE%"
)
TIMEOUT /T 30
set /A _ATTEMPT+=1
goto :SENDAGAIN

:THEEND

