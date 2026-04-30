REM -----------------------------------------------------------------------
REM ------------------------- Define _TIMESTAMP ---------------------------
REM -----------------------------------------------------------------------

REM Following variables are set by this subroutine:
REM _TIMESTAMP

FOR /f "tokens=1-4 delims=/-. " %%G IN ('date /t') DO (call :s_fixdate %%G %%H %%I %%J)
goto :s_print_the_date

:s_fixdate
if "%1:~0,1%" GTR "9" shift
FOR /f "skip=1 tokens=2-4 delims=(-)" %%G IN ('echo.^|date') DO (
   set %%G=%1&set %%H=%2&set %%I=%3)
goto :eof

:s_print_the_date
set _TIMESTAMP=%yy%-%mm%-%dd% %time:~0,-3%
goto :eof
