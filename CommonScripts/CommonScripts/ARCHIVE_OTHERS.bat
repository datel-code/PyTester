REM -------------------------------------------------------------------
REM --- Archives auxiliary files  -------------------------------------
REM --- Single/Multifolder version ------------------------------------
REM -------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM _LOGFILE - Common log file name

REM --- Tester specific variables
REM _ARCHIVEFOLDER - Where to save archives
REM _ARCHIVE_OUT - The name of the archive (with date)

REM Following variables are optional:
REM _SUBTASKSLISTFILE

REM --- Output variables
REM _ARCHIVINGERROR

call %G_TIMESTAMP%

echo ^>Entering ARCHIVE_OTHERS.bat /%_TOPIC%/>>%_LOGFILE%
echo ^>Entering ARCHIVE_OTHERS.bat /%_TOPIC%/

set _ARCHIVINGERROR=0

REM Create new archive folder structure

If not exist %_ARCHIVEFOLDER% md %_ARCHIVEFOLDER%

REM Archive using 7Zip

if not defined _SUBTASKSLISTFILE goto :NOSUBTASKLISTFILE
if exist %_SUBTASKSLISTFILE% (
    echo Archiving the list of subtask to %_ARCHIVE_OUT%...
    echo Archiving the list of subtask to %_ARCHIVE_OUT%... >>%_LOGFILE%
    %_7Zip% a -t7z %_ARCHIVEFOLDER%\%_ARCHIVE_OUT%.7z %_SUBTASKSLISTFILE%
    )
if %ERRORLEVEL% NEQ 0 set _ARCHIVINGERROR=%ERRORLEVEL%
:NOSUBTASKLISTFILE

echo Archiving the statistic XML file to %_ARCHIVE_OUT%...
echo Archiving the statistic XML file to %_ARCHIVE_OUT%... >>%_LOGFILE%
    %_7Zip% a -t7z %_ARCHIVEFOLDER%\%_ARCHIVE_OUT%.7z %_STAT_STATISTICSCOMMONFILE%
if %ERRORLEVEL% NEQ 0 set _ARCHIVINGERROR=%ERRORLEVEL%

echo Archiving the report file to %_ARCHIVE_OUT%...
echo Archiving the report file to %_ARCHIVE_OUT%... >>%_LOGFILE%
    %_7Zip% a -t7z %_ARCHIVEFOLDER%\%_ARCHIVE_OUT%.7z %_TRANSFORM_OUT%
if %ERRORLEVEL% NEQ 0 set _ARCHIVINGERROR=%ERRORLEVEL%

echo Archiving the KnownIssues file to %_ARCHIVE_OUT%...
echo Archiving the KnownIssues file to %_ARCHIVE_OUT%... >>%_LOGFILE%
    %_7Zip% a -t7z %_ARCHIVEFOLDER%\%_ARCHIVE_OUT%.7z %_KNOWNISSUES%
if %ERRORLEVEL% NEQ 0 set _ARCHIVINGERROR=%ERRORLEVEL%

echo Archiving the log file to %_ARCHIVE_OUT%...
echo Archiving the log file to %_ARCHIVE_OUT%... >>%_LOGFILE%
    %_7Zip% a -t7z %_ARCHIVEFOLDER%\%_ARCHIVE_OUT%.7z %_LOGFILE%
if %ERRORLEVEL% NEQ 0 set _ARCHIVINGERROR=%ERRORLEVEL%

echo Archiving status: %_ARCHIVINGERROR%
echo Archiving status: %_ARCHIVINGERROR% >>%_LOGFILE%

goto :eof