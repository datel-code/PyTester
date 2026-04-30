REM -----------------------------------------------------------------------
REM --- Launcher of Automatic Esko Tester VBS script ----------------------
REM --- Version for DynamicVDP --------------------------------------------
REM -----------------------------------------------------------------------

REM Following variables must be already defined:

REM --- Global variables ---
REM vbsAET - Launched Visual Basic script
REM _vbsAINAME - Illustrator applicationa name recognized by Visual Basic 
REM _jsxAISIGNATURE - WAI22r / WAI23r ...
REM _jsxSCRIPT - Launched ExtendScript 
REM _LOGFILE - Common log file name

REM --- Tester specific variables
REM _TOPIC
REM _SOURCEFOLDER - input folder
REM _OUTFOLDER - Output path

REM _jsxTESTERNAME - "PDF Export Tester", "Dynamic Barcodes Tester", "DB Recognition Tester", "Dynamic Marks Tester", "Dynamic Tables Tester", "Trapping Tester" or "DynamicVDP Tester"
REM _jsxPROCESSSUBFOLDER - true/false
REM _jsxMASK - *.pdf /  *.ai
REM _jsxUSEIMPORTPDF - true/false
REM _jsxUSEIMPORTNDLPDF - true/false
REM _jsxJOBNAME - log prefix (used for logging mainly)

call %G_TIMESTAMP%

echo ^>Entering AETLauncher-DynamicVDP.bat>>%_LOGFILE%
echo ^>Entering AETLauncher-DynamicVDP.bat

echo. >>%_LOGFILE%
echo.
echo Starting %_TOPIC% Automated Esko Tester Launcher... >>%_LOGFILE%
echo Starting %_TOPIC% Automated Esko Tester Launcher...

if not exist %_OUTFOLDER% (md %_OUTFOLDER%)

setlocal enabledelayedexpansion
for /F "skip=1" %%i in (%_SUBTASKSLISTFILE%) do (

    tasklist /FI "IMAGENAME eq illustrator.exe" 2>NUL | find /I /N "illustrator.exe">NUL
    if "!ERRORLEVEL!" NEQ "0" (
        echo Launching Illustrator...
        echo Launching Illustrator... >>%_LOGFILE%
        call %G_TIMESTAMP%
        if "%_REGIME%" EQU "AUTO" (
            cscript %_vbsAiStart% //Nologo %_vbsAINAME% >>%_LOGFILE%
        ) else (
            cscript %_vbsAiStart% //Nologo %_vbsAINAME%
        )
    )

    set _THIS_TASKNAME=%%i
    call %G_TIMESTAMP%
    echo ### Task Name: !_THIS_TASKNAME!
    echo ### Task Name: !_THIS_TASKNAME! >>%_LOGFILE%
    if not exist %_OUTFOLDER%\!_THIS_TASKNAME! (md %_OUTFOLDER%\!_THIS_TASKNAME!)

    if "%_REGIME%" EQU "AUTO" (
        cscript %vbsAET% //Nologo %_vbsAINAME% %_jsxSCRIPT% %_jsxAISIGNATURE% %_jsxTESTERNAME% "%_SOURCEFOLDER%\!_THIS_TASKNAME!" %_jsxPROCESSSUBFOLDER% %_jsxMASK% %_jsxUSEIMPORTPDF% %_jsxUSEIMPORTNDLPDF% "%_OUTFOLDER%" %_jsxJOBNAME% >>%_LOGFILE%
    ) else (
        echo cscript %vbsAET% //Nologo 
        echo %_vbsAINAME% %_jsxSCRIPT% %_jsxAISIGNATURE% %_jsxTESTERNAME% 
        echo "%_SOURCEFOLDER%\!_THIS_TASKNAME!"
        echo %_jsxPROCESSSUBFOLDER% %_jsxMASK% %_jsxUSEIMPORTPDF% %_jsxUSEIMPORTNDLPDF% 
        echo "%_OUTFOLDER%\!_THIS_TASKNAME!" 
        echo %_jsxJOBNAME% 
        cscript %vbsAET% //Nologo %_vbsAINAME% %_jsxSCRIPT% %_jsxAISIGNATURE% %_jsxTESTERNAME% "%_SOURCEFOLDER%\!_THIS_TASKNAME!" %_jsxPROCESSSUBFOLDER% %_jsxMASK% %_jsxUSEIMPORTPDF% %_jsxUSEIMPORTNDLPDF% "%_OUTFOLDER%" %_jsxJOBNAME%
    )
    rem call %G_KILLILL%
    rename %_OUTFOLDER%\Reports\summary.html !_THIS_TASKNAME!_summary.html
    move %_OUTFOLDER%\%TOPIC%*.txt %_OUTFOLDER%\!_THIS_TASKNAME!
    move %_OUTFOLDER%\%TOPIC%*.csv %_OUTFOLDER%\!_THIS_TASKNAME!
)

echo AET Launcher finished. >>%_LOGFILE%
echo AET Launcher finished. 
call %G_TIMESTAMP%