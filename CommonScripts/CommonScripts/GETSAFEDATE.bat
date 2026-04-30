REM -----------------------------------------------------------------------
REM --- Generate actual and safe timestamp --------------------------------
REM -----------------------------------------------------------------------

REM Returns the safe date


FOR /f "tokens=1-4 delims=/-. " %%G IN ('date /t') DO (call :s_fixdate %%G %%H %%I %%J)
set _TIMESTAMP=%yy%-%mm%-%dd%T%time:~0,-3%

set _THIS_SAFEDATE=%_TIMESTAMP: =_%
set _THIS_SAFEDATE=%_THIS_SAFEDATE:-=%
set _THIS_SAFEDATE=%_THIS_SAFEDATE::=%
rem set _THIS_SAFEDATE=%_THIS_SAFEDATE:__=_0%

set %1=%_THIS_SAFEDATE%

goto :eof

:s_fixdate
if "%1:~0,1%" GTR "9" shift
FOR /f "skip=1 tokens=2-4 delims=(-)" %%G IN ('echo.^|date') DO (
   set %%G=%1&set %%H=%2&set %%I=%3)
goto :eof