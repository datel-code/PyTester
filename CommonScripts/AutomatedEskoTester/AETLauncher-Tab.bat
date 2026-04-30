REM -----------------------------------------------------------------------
REM --- Launcher of Automatic Esko Tester VBS script ----------------------
REM --- Version for Trap --------------------------------------------------
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
REM _OUTFOLDER - Output path

REM _TESTERPARAMETERSFILE - Path to the CSV cfg file

REM _jsxTESTERNAME - "PDF Export Tester", "Dynamic Barcodes Tester", "DB Recognition Tester", "Dynamic Marks Tester", "Dynamic Tables Tester" or "Trapping Tester"
REM _jsxJOBNAME - log prefix (used for logging mainly)
REM _jsxOUTPUTTYPE - 0 - Esko Normalized PDF / 1 - Esko Tiff / 2 - Esko NDLPDF / 3 - Esko PDF+

call %G_TIMESTAMP%

echo ^>Entering AETLauncher-Tab.bat>>%_LOGFILE%
echo ^>Entering AETLauncher-Tab.bat

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
    set _THIS_TESTERPARAMETERSFILE=%_TICKETS%\!_THIS_TASKNAME!.%_TASKFILETYPE%
    call %G_TIMESTAMP%
    echo ### Task Name: !_THIS_TASKNAME!
    echo ### Task Name: !_THIS_TASKNAME! >>%_LOGFILE%
    echo Parameter file: !_THIS_TESTERPARAMETERSFILE!
    echo Parameter file: !_THIS_TESTERPARAMETERSFILE! >>%_LOGFILE%
    if not exist %_OUTFOLDER%\!_THIS_TASKNAME! (md %_OUTFOLDER%\!_THIS_TASKNAME!)

    if "%_REGIME%" EQU "AUTO" (
        cscript %vbsAET% //Nologo %_vbsAINAME% %_jsxSCRIPT% %_jsxAISIGNATURE% %_jsxTESTERNAME% "!_THIS_TESTERPARAMETERSFILE!" "%_OUTFOLDER%\!_THIS_TASKNAME!" %_jsxJOBNAME% %_jsxOUTPUTTYPE% >>%_LOGFILE%
    ) else (
        echo cscript %vbsAET% //Nologo 
        echo %_vbsAINAME% %_jsxSCRIPT% %_jsxAISIGNATURE% %_jsxTESTERNAME% 
        echo "!_THIS_TESTERPARAMETERSFILE!"
        echo "%_OUTFOLDER%\!_THIS_TASKNAME!" 
        echo %_jsxJOBNAME% %_jsxOUTPUTTYPE% 
        cscript %vbsAET% //Nologo %_vbsAINAME% %_jsxSCRIPT% %_jsxAISIGNATURE% %_jsxTESTERNAME% "!_THIS_TESTERPARAMETERSFILE!" "%_OUTFOLDER%\!_THIS_TASKNAME!" %_jsxJOBNAME% %_jsxOUTPUTTYPE%     
    )
)

echo AET Launcher finished. >>%_LOGFILE%
echo AET Launcher finished. 
call %G_TIMESTAMP%