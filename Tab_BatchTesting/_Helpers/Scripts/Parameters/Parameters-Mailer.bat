REM -----------------------------------------------------------------------
REM --- Mailer PARAMETERS ----------------------------------------
REM -----------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---

REM --- Tester specific variables
REM _LOGFILE
REM _LOGTOPIC - Mail topic header (auto/man + topic)
REM _STAT_SUSPECTEDFILESCOUNTARRAY - Assembled in STAT, shows suspected files array
REM _INPUT_FILES_COUNT - No. of input files
REM _TRANSFORM_OUT - output of the transformation
REM _PRECMPLOGFILE - Pre-compare file generator error log file 
REM _PROCESSLOGFILE - Processing error log file

call %G_TIMESTAMP%

echo ^>Entering Parameters-Mailer.bat>>%_LOGFILE%
echo ^>Entering Parameters-Mailer.bat

REM Defines possible missing-files warning
set _CHECKFILESWARNING=
if %_ALL_INPUT_FILES% NEQ %_PRECMP_OUT_FILES_COUNT_SUM% (
    set "_CHECKFILESWARNING=[Check Precmp files!] "
)
if %_ALL_INPUT_FILES% NEQ %_PROCESS_OUT_FILES_COUNT_SUM% (
    set "_CHECKFILESWARNING=[Check Processed files!] "
)
REM Indicate an array of numbers of suspected files
set _MAIL_SUBJECT=-s "%_LOGTOPIC% b.%_BUILDNUMBER%/%_NDLBUILDNUMBER% Ai:%_AIBUILD% %_CHECKFILESWARNING%%_STAT_SUSPECTEDFILESCOUNTARRAY%/%_INPUT_FILES_COUNT_SUM% susp. files%_UPDATESKIPPED%"
set _MAIL_BODY=%_TRANSFORM_OUT%
set _MAIL_ATTACHMENTS=%_LOGFILE%,%_PROCESSLOGFILE%,%_PRECMPLOGFILE%,%_CMPLOGFILE%

