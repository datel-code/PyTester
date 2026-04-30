REM -----------------------------------------------------------------------
REM --- Transforms XML reports to HTML ------------------------------------
REM -----------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM _JAVA - Java executable
REM _SAXON - Saxon transformer
REM _LOGFILE - Common Log file

REM --- Tester specific variables ---
REM _TRANSFORM_IN - Transformation input = Common report XML file
REM _TRANSFORM_XSLTFILE - XSL transformation file
REM _TRANSFORM_OUT - Output HTML file

call %G_TIMESTAMP%

echo ^>Entering TRANSFORM.bat>>%_LOGFILE%
echo ^>Entering TRANSFORM.bat

if exist %_TRANSFORM_OUT% del %_TRANSFORM_OUT%

REM Processes the NDL Model Test report XML through the XSL transformation file to generate the report HTML. Expects JAVA set-up
echo Transforming command:
echo Transforming command:>>%_LOGFILE%
echo %_JAVA% -cp %_SAXON% net.sf.saxon.Transform -t -s:%_TRANSFORM_IN% -xsl:%_TRANSFORM_XSLTFILE% -o:%_TRANSFORM_OUT%
echo %_JAVA% -cp %_SAXON% net.sf.saxon.Transform -t -s:%_TRANSFORM_IN% -xsl:%_TRANSFORM_XSLTFILE% -o:%_TRANSFORM_OUT% >>%_LOGFILE%
%_JAVA% -cp %_SAXON% net.sf.saxon.Transform -t -s:%_TRANSFORM_IN% -xsl:%_TRANSFORM_XSLTFILE% -o:%_TRANSFORM_OUT% >>%_LOGFILE%

if not exist %_TRANSFORM_OUT% (
    echo Report processing failed! >>%_LOGFILE%
    echo Report processing failed! 
) else (
    copy %_TRANSFORM_OUT% %_LOGFOLDER%
)

