REM -----------------------------------------------------------------------
REM --- XSL Transformation PARAMETERS -------------------------------------
REM -----------------------------------------------------------------------

REM Following variables must be already defined:

REM _STAT_STATISTICSCOMMONFILE - Transformation input = Common Statistics XML file
REM _STAT_TESTREPORTCOMMONFILE
REM _GLOBALHELPERSFOLDER - Path to common helpers

call %G_TIMESTAMP%

echo ^>Entering Parameters-Transform.bat>>%_LOGFILE%
echo ^>Entering Parameters-Transform.bat

call %G_GETSAFEDATE% _SAFEDATE

set _TRANSFORM_IN=%_STAT_STATISTICSCOMMONFILE%
set _TRANSFORM_OUT=%_STAT_ROOT%\%_TOPIC%_%_SAFEDATE%.html
set _MAIL_BODY=%_TRANSFORM_OUT%
set _TRANSFORM_XSLTFILE=%_G_XSLTFOLDER%\NMT_transform_commented.xsl
