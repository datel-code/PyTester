REM -----------------------------------------------------------------------
REM --- Common reporter ----------------------------------
REM -----------------------------------------------------------------------

echo. >>%_LOGFILE%
echo ================================================================================================ >>%_LOGFILE%
echo === REPORTING === /%_TOPIC%/ =================================================================== >>%_LOGFILE%
echo ================================================================================================ >>%_LOGFILE%
echo. >>%_LOGFILE%
echo.
echo ================================================================================================ 
echo === REPORTING === /%_TOPIC%/ =================================================================== 
echo ================================================================================================ 
echo.

call :STATISTICS

call :TRANSFORM

call :ARCHIVE

call :REPORT

goto :eof

REM ### End #########################################################################################

REM vvv Dead end ************************************************************************************

:REPORTERERREND

echo. >>%_LOGFILE%
echo %_TOPIC% Automated Tester failed! >>%_LOGFILE%
echo. 
echo %_TOPIC% Automated Tester failed! 
call %G_TIMESTAMP%
goto :eof

REM ^^^ Dead end ************************************************************************************


REM --- Statistics --------------------------------------------------------------------------

:STATISTICS

call %G_STAT%

goto :eof

REM --- Transform --------------------------------------------------------------------------

:TRANSFORM

call %G_TRANSFORM%

:TRANSFORM_DONE

goto :eof

REM --- Archive --------------------------------------------------------------------------

:ARCHIVE

call %G_ARCHIVE_OTHERS%
call %G_ARCHIVE_CLEANER% 

:ARCHIVE_DONE

goto :eof

REM --- Send report --------------------------------------------------------------------------

:REPORT
call %P_Mailer%

if "%MAILING%" EQU "PRIVATE" (set "_RECIPIENTS=tomas.tarant@esko.com")
if "%MAILING%" EQU "NOMAIL" (
    echo No mailing.
    echo No mailing.>>%_LOGFILE%
    goto :MAILING_DONE
)

if "%REGIME%" NEQ "AUTO" goto :MAILING_MANUAL
call %G_SENDREPORT%
goto :MAILING_DONE

:MAILING_MANUAL
set /P _ANSWER=Send report to %_RECIPIENTS%? (Y/N)?
if /i {%_ANSWER%}=={y} (
    call %G_SENDREPORT%
)

:MAILING_DONE

goto :eof
