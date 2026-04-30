@echo off
setlocal enabledelayedexpansion

REM Log beginning of the session
call %G_TIMESTAMP%
echo Deleting old archives from %_ARCHIVEFOLDER% >>%_LOGFILE%
echo Keeping %_KEEPALIVE% newest files... >>%_LOGFILE%
echo ============================================================================ >>%_LOGFILE%
echo Deleting old archives from %_ARCHIVEFOLDER%
echo Keeping %_KEEPALIVE% newest files...
echo ============================================================================ >>%_LOGFILE%

REM List folders available on given path
REM Skip n most recent ones
REM dir %_THEPATH% /A:D /O:-D /T:C /B

for /f "tokens=* skip=%_KEEPALIVE%" %%G in ('dir %_ARCHIVEFOLDER% /O:-D /T:C /B') do (
    set _PATHTODELETE="%_ARCHIVEFOLDER%\%%G"
    rem echo !_PATHTODELETE!
    call :DELETEITEM !_PATHTODELETE!
    )
    
goto :THEEND

:DELETEITEM
REM Log folder to delete
echo Deleting %1. >>%_LOGFILE%
echo Deleting %1. 

REM Delete the file
del /F /Q %1 >>%_LOGFILE% 2>&1
IF %ERRORLEVEL% NEQ 0 (
echo Unable to delete %1. 
echo Unable to delete %1. >>%_LOGFILE%
goto :eof
)

goto :eof


:THEEND
REM Log finish of the batch
echo Deleting old archives finished. 
echo Deleting old archives finished. >>%_LOGFILE%
goto :eof

:SETTIMESTAMP
:: This will return date into environment vars
:: Works on any NT/2K/XP machine independent of regional date settings
:: 20 March 2002

FOR /f "tokens=1-4 delims=/-. " %%G IN ('date /t') DO (call :s_fixdate %%G %%H %%I %%J)
goto :s_print_the_date

:s_fixdate
if "%1:~0,1%" GTR "9" shift
FOR /f "skip=1 tokens=2-4 delims=(-)" %%G IN ('echo.^|date') DO (
   set %%G=%1&set %%H=%2&set %%I=%3)
goto :eof

:s_print_the_date
set TIMESTAMP=%yy%-%mm%-%dd% %time:~0,-3%
goto :eof