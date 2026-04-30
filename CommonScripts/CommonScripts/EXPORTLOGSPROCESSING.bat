REM -----------------------------------------------------------------------
REM --- Processing Log Files, getting time spent by exporting -------------
REM --- Version for single and multi-folder outputs -----------------------
REM -----------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM _LOGFILE
REM _TOPIC

REM --- Tester specific variables ---
REM _OUTFOLDER
REM _TIMESPENTTMPFILE
REM _PREVIOUSTIMEFILE
REM _MULTIFOLDER_PROCESS
REM _SUBTASKSLISTFILE

REM Following variables are set by this subroutine:

REM _PROCESSLOGFILE
REM _TIMELOGFILE
REM _LOGPROC_PREVIOUSTIMESPENT
REM _LOGPROC_CURRENTTIMESPENT

echo ^>Entering EXPORTLOGPROCESSING.bat /%_TOPIC%/>>%_LOGFILE%
echo ^>Entering EXPORTLOGPROCESSING.bat /%_TOPIC%/

if "%_MULTIFOLDER_PROCESS%" EQU "YES" call :PROCESSMULTIFOLDER
if "%_MULTIFOLDER_PROCESS%" EQU "NO"  call :PROCESSSINGLEFOLDER

if %_TOPIC% EQU DVDP call :PROCESSDVDPREPORTS

echo %_TOPIC% Automatic Tester Export Log File: 
echo %_PROCESSLOGFILE%
echo %_TOPIC% Automatic Tester Export Log File: >>%_LOGFILE%
echo %_PROCESSLOGFILE% >>%_LOGFILE%
echo %_TOPIC% Automatic Tester Time Log File: 
echo %_TIMELOGFILE%
echo %_TOPIC% Automatic Tester Time Log File: >>%_LOGFILE%
echo %_TIMELOGFILE% >>%_LOGFILE%

REM First run defines the Previous values as 0
if not exist %_PREVIOUSTIMEFILE% (echo 0, 0, 0 > %_PREVIOUSTIMEFILE%)
set /p _LOGPROC_PREVIOUSTIMESPENT= < %_PREVIOUSTIMEFILE%

REM Report
if "%_LOGPROC_PREVIOUSTIMESPENT%"=="0, 0, 0 " (
    echo Previous time values are not available. Current processing time [Execute Time, Export Time, Overall Time]:
    echo Previous time values are not available. Current processing time [Execute Time, Export Time, Overall Time]: >>%_LOGFILE%
    echo %_LOGPROC_CURRENTTIMESPENT%
    echo %_LOGPROC_CURRENTTIMESPENT% >>%_LOGFILE%
) else (
    echo Processing time [Execute Time, Export Time, Overall Time]
    echo Processing time [Execute Time, Export Time, Overall Time] >>%_LOGFILE%
    echo - Previous: %_LOGPROC_PREVIOUSTIMESPENT%
    echo - Previous: %_LOGPROC_PREVIOUSTIMESPENT% >>%_LOGFILE%
    echo - Current : %_LOGPROC_CURRENTTIMESPENT%
    echo - Current : %_LOGPROC_CURRENTTIMESPENT% >>%_LOGFILE%
)
echo %_LOGPROC_CURRENTTIMESPENT% > %_PREVIOUSTIMEFILE%

REM Exit --------------------------------------------

goto :eof



REM -------------------------------------------------

:PROCESSSINGLEFOLDER

REM get the export log files, the latest ones
set _DIRCMD="dir %_OUTFOLDER%\%_TOPIC%*.txt /O:-D /B"
for /F "delims=" %%x in ('%_DIRCMD%') do (
    set "_THIS_PROCESSLOGFILE=%_OUTFOLDER%\%%x"
    goto :ENDLOGFILE
)
:ENDLOGFILE

copy /Y %_THIS_PROCESSLOGFILE% %_PROCESSLOGFILE%

set _DIRCMD2="dir %_OUTFOLDER%\%_TOPIC%*.csv /O:-D /B"
for /F "delims=" %%x in ('%_DIRCMD2%') do (
    set "_THIS_TIMELOGFILE=%_OUTFOLDER%\%%x"
    goto :ENDTIMEFILE
)
:ENDTIMEFILE
copy /Y %_THIS_TIMELOGFILE% %_TIMELOGFILE%

REM Look for the summary in the time log and get times
type %_TIMELOGFILE% | find "TOTAL" > %_TIMESPENTTMPFILE%
set /p _TIMESPENTCHECK=<%_TIMESPENTTMPFILE%
if "%_TIMESPENTCHECK%" EQU  "" (
    echo.
    echo. >>%_LOGFILE%
    echo !!!Processing probably not finished!!!
    echo !!!Processing probably not finished!!! >>%_LOGFILE%
    echo.
    echo. >>%_LOGFILE%
    set "_LOGPROC_CURRENTTIMESPENT=!, !, ! "
) else (
    for /f "tokens=2,3,4 delims=," %%x in ('type %_TIMESPENTTMPFILE%') do set "_LOGPROC_CURRENTTIMESPENT=%%x, %%y, %%z "
)

set _LOGPROC_CURRENTTIMESPENT=%_LOGPROC_CURRENTTIMESPENT:"=%

goto :eof

REM -------------------------------------------------

:PROCESSMULTIFOLDER

set /a _LOGPROC_CURRENTTIMESPENT_Execute=0
set /a _LOGPROC_CURRENTTIMESPENT_Export=0
set /a _LOGPROC_CURRENTTIMESPENT_Overall=0

setlocal EnableDelayedExpansion
echo Collected logs file for Automated %_TOPIC% tester > %_PROCESSLOGFILE%
for /F "skip=1" %%j in (%_SUBTASKSLISTFILE%) do (
    REM get the export log files, the latest ones, from each processed folder
    set _THIS_SUBTASK=%%j
    echo Task: !_THIS_SUBTASK!>> %_PROCESSLOGFILE%
    echo Task: !_THIS_SUBTASK!
    set _DIRCMD="dir %_OUTFOLDER%\!_THIS_SUBTASK!\%_TOPIC%*.txt /O:-D /B"
    for /F "delims=" %%x in ('!_DIRCMD!') do (
        set _THIS_FILE=%%x
        echo Log file: !_THIS_FILE!
        echo Log file: !_THIS_FILE!>> %_PROCESSLOGFILE%
        set "_THIS_PROCESSLOGFILE=%_OUTFOLDER%\!_THIS_SUBTASK!\!_THIS_FILE!"
        type !_THIS_PROCESSLOGFILE!>> %_PROCESSLOGFILE%
        echo.>> %_PROCESSLOGFILE%
        echo.
    )
)

echo Collected time logs file for %_TOPIC% tester > %_TIMELOGFILE%
for /F "skip=1" %%m in (%_SUBTASKSLISTFILE%) do (
    REM get the export log files, the latest ones, from each processed folder
    set _THIS_TIMESUBTASK=%%m
    echo Task: !_THIS_TIMESUBTASK!>> %_TIMELOGFILE%
    echo Task: !_THIS_TIMESUBTASK!
    set _DIRCMD2="dir %_OUTFOLDER%\!_THIS_TIMESUBTASK!\%_TOPIC%*.csv /O:-D /B"
    for /F "delims=" %%y in ('!_DIRCMD2!') do (
        set _THIS_TIMEFILE=%%y
        echo Time log file: !_THIS_TIMEFILE!
        set "_THIS_TIMELOGFILE=%_OUTFOLDER%\!_THIS_TIMESUBTASK!\!_THIS_TIMEFILE!"
        type !_THIS_TIMELOGFILE!>> %_TIMELOGFILE%
        echo.>> %_TIMELOGFILE%
        echo.
        REM Look for the summary in the time log and get times
        type !_THIS_TIMELOGFILE! | find "TOTAL" > %_TIMESPENTTMPFILE%
        for /f "tokens=2,3,4 delims=," %%a in ('type %_TIMESPENTTMPFILE%') do (
            set _THIS_LOGPROC_CURRENTTIMESPENT_Execute=%%a
            set _THIS_LOGPROC_CURRENTTIMESPENT_Export=%%b
            set _THIS_LOGPROC_CURRENTTIMESPENT_Overall=%%c
        )
        echo Execute time: !_THIS_LOGPROC_CURRENTTIMESPENT_Execute!
        echo Export time: !_THIS_LOGPROC_CURRENTTIMESPENT_Export!
        echo Overall time: !_THIS_LOGPROC_CURRENTTIMESPENT_Overall!

        for /F "usebackq tokens=*" %%t in (`cscript //nologo %G_vbsSUM% !_LOGPROC_CURRENTTIMESPENT_Execute! !_THIS_LOGPROC_CURRENTTIMESPENT_Execute!`) do (
			set _LOGPROC_CURRENTTIMESPENT_Execute=%%t
        )
        for /F "usebackq tokens=*" %%u in (`cscript //nologo %G_vbsSUM% !_LOGPROC_CURRENTTIMESPENT_Export! !_THIS_LOGPROC_CURRENTTIMESPENT_Export!`) do (
			set _LOGPROC_CURRENTTIMESPENT_Export=%%u
        )
        for /F "usebackq tokens=*" %%v in (`cscript //nologo %G_vbsSUM% !_LOGPROC_CURRENTTIMESPENT_Overall! !_THIS_LOGPROC_CURRENTTIMESPENT_Overall!`) do (
			set _LOGPROC_CURRENTTIMESPENT_Overall=%%v
        )
    )
)
set "_LOGPROC_CURRENTTIMESPENT_LOCAL=!_LOGPROC_CURRENTTIMESPENT_Execute!, !_LOGPROC_CURRENTTIMESPENT_Export!, !_LOGPROC_CURRENTTIMESPENT_Overall! "

endlocal & set _LOGPROC_CURRENTTIMESPENT=%_LOGPROC_CURRENTTIMESPENT_LOCAL%

goto :eof



REM -------------------------------------------------

:PROCESSDVDPREPORTS

del /F /Q %_OUTFOLDER%\%_TOPIC%*.7z >>%_LOGFILE% 2>&1

if exist %_OUTFOLDER% (
    echo Archiving DVDP tester HTML logs to %DVDPREPORT%...
    echo Archiving DVDP tester HTML logs to %DVDPREPORT%... >>%_LOGFILE%
    %_7Zip% a -t7z -r %DVDPREPORT% %_OUTFOLDER%\*.html
    )
goto :eof
