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

echo ^>Entering MAC Parameters_Mailer.bat>>%_LOGFILE%
echo ^>Entering MAC Parameters_Mailer.bat

REM Indicate an array of numbers of suspected files
set _MAIL_SUBJECT=-s "%_LOGTOPIC% b.%_BUILDNUMBER%/%_NDLBUILDNUMBER% %_STAT_SUSPECTEDFILESCOUNTARRAY%/%_INPUT_FILES_COUNT% susp. files%_UPDATESKIPPED%"
set _MAIL_BODY=%_TRANSFORM_OUT%
set _MAIL_ATTACHMENTS=%_LOGFILE%,%_PRECMPLOGFILE%,%_PROCESSLOGFILE%

