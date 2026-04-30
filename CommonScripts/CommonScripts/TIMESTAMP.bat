REM -----------------------------------------------------------------------
REM --- Add a Time Stamp to the Log File ----------------------------------
REM -----------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM _LOGFILE

FOR /f "skip=1" %%x IN ('wmic os get localdatetime') DO (call :EXTRACTDATEANDTIME %%x)
echo --- %_G_TIMESTAMP% >>%_LOGFILE%
echo --- %_G_TIMESTAMP% 
goto :eof

:EXTRACTDATEANDTIME
set _MyDate=%1
if "%_MyDate%" NEQ "" (
set _G_TIMESTAMP=%_MyDate:~0,4%-%_MyDate:~4,2%-%_MyDate:~6,2%T%_MyDate:~8,2%:%_MyDate:~10,2%:%_MyDate:~12,2%Z
rem %_MyDate:~14,3%
)
