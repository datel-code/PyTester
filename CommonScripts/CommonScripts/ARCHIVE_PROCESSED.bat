REM -------------------------------------------------------------------
REM --- Archives last processing result  ------------------------------
REM --- Single/Multifolder version ------------------------------------
REM -------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM _LOGFILE - Common log file name

REM --- Tester specific variables
REM _ARCHIVEFOLDER - Where to save archives
REM _ARCHIVE_OUT - The name of the archive (with date)
REM _OUTFOLDER - Processing output

REM --- Output variables
REM _ARCHIVINGERROR

call %G_TIMESTAMP%

echo ^>Entering ARCHIVE_PROCESSED.bat /%_TOPIC%/>>%_LOGFILE%
echo ^>Entering ARCHIVE_PROCESSED.bat /%_TOPIC%/

set _ARCHIVINGERROR=0

REM Create new archive folder structure

If not exist %_ARCHIVEFOLDER% md %_ARCHIVEFOLDER%

REM Archive using 7Zip
if exist %_OUTFOLDER% (
    echo Archiving processed files to %_ARCHIVE_OUT%...
    echo Archiving processed files to %_ARCHIVE_OUT%... >>%_LOGFILE%
    %_7Zip% a -t7z %_ARCHIVEFOLDER%\%_ARCHIVE_OUT%.7z %_OUTFOLDER% -r
    )
if %ERRORLEVEL% NEQ 0 set _ARCHIVINGERROR=%ERRORLEVEL%

echo Archiving status: %_ARCHIVINGERROR%
echo Archiving status: %_ARCHIVINGERROR% >>%_LOGFILE%

goto :eof