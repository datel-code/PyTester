REM -----------------------------------------------------------------------
REM --- Common compare caller ---------------------------------------------
REM -----------------------------------------------------------------------

echo. >>%_LOGFILE%
echo ================================================================================================ >>%_LOGFILE%
echo === COMPARING === /%_TOPIC%/ =================================================================== >>%_LOGFILE%
echo ================================================================================================ >>%_LOGFILE%
echo. >>%_LOGFILE%
echo.
echo ================================================================================================ 
echo === COMPARING === /%_TOPIC%/ =================================================================== 
echo ================================================================================================ 
echo.

REM Optional jump to compare and skip processing for EGCompare tasks
set _SKIPPROCES=NO

if "%REGIME%" EQU "AUTO" goto :COMPARE

REM Skipping processing is not possible with NMT compare
if "%_CMPENGINE%" NEQ "EGC" goto :COMPARE
set /P _ANSWER=Do you want to skip the compare process and report only (Y/N)?
if /i {%_ANSWER%}=={y} (set _SKIPPROCES=YES)


REM --- Comparing --------------------------------------------------------------------------

:COMPARE

if "%REGIME%" NEQ "AUTO" goto :COMPARING_MANUAL

call %G_CLEANUP_COMPARED%
if %_CLEANUPERROR% EQU 0 goto :DOCOMPARE
if %_CLEANUPERROR% EQU 3 goto :DOCOMPARE
if %_CLEANUPERROR% EQU 4 goto :DOCOMPARE
goto :eof

:DOCOMPARE
call %G_COMPARE%
call %G_ARCHIVE_COMPARED%

goto :COMPARING_DONE

:COMPARING_MANUAL
set /P _ANSWER=Cleanup content of %_CMP_OUT% folder? (Y/N)?
if /i {%_ANSWER%}=={y} (
    call %G_CLEANUP_COMPARED%
)

set /P _ANSWER=Compare %_CMP_IN% with %_REFFOLDER%? (Y/N)?
if /i {%_ANSWER%} NEQ {y} goto :COMPARING_DONE
call %G_COMPARE%

set /P _ANSWER=Archive Compared files from %_CMP_OUT% to %_ARCHIVEFOLDER%? (Y/N)?
if /i {%_ANSWER%}=={y} (
    call %G_ARCHIVE_COMPARED%
    )

:COMPARING_DONE

goto :eof

REM ### End #########################################################################################

