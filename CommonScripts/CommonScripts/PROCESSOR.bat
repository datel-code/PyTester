REM -----------------------------------------------------------------------
REM --- Common processor ----------------------------------
REM -----------------------------------------------------------------------

echo. >>%_LOGFILE%
echo ================================================================================================ >>%_LOGFILE%
echo === PROCESSING === /%_TOPIC%/ ================================================================== >>%_LOGFILE%
echo ================================================================================================ >>%_LOGFILE%
echo. >>%_LOGFILE%
echo.
echo ================================================================================================ 
echo === PROCESSING === /%_TOPIC%/ ================================================================== 
echo ================================================================================================ 
echo.

REM --- Processing --------------------------------------------------------------------------

echo Processing task: %1 >>%_LOGFILE%
echo Processing task: %1

if "%REGIME%" NEQ "AUTO" goto :PROCESSING_MANUAL

call %G_CLEANUP_PROCESSED%
if %_CLEANUPERROR% NEQ 0 (
    echo Cleanup error: %_CLEANUPERROR%
    pause
    goto :eof
    )

call %AET%
call %G_EXPORTLOGSPROCESSING%
call %G_ARCHIVE_PROCESSED%

goto :eof

:PROCESSING_MANUAL

set /P _ANSWER=Cleanup Process folders in %_OUTFOLDER%? (Y/N)?
if /i {%_ANSWER%}=={y} (
    call %G_CLEANUP_PROCESSED%
    if %_CLEANUPERROR% NEQ 0 goto :eof
    )
    
set /P _ANSWER=Process %_SOURCEFOLDER% to %_OUTFOLDER%? (Y/N)?
if /i {%_ANSWER%} NEQ {y} goto :PROCESSING_DONE

call %G_TIMESTAMP%
call %AET%
call %G_EXPORTLOGSPROCESSING%
set /P _ANSWER=Archive Processed files from %_OUTFOLDER% to %_ARCHIVEFOLDER%? (Y/N)?
if /i {%_ANSWER%}=={y} (
    call %G_ARCHIVE_PROCESSED%
    )

:PROCESSING_DONE


goto :eof
