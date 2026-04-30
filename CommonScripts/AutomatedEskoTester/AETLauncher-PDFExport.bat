REM -----------------------------------------------------------------------
REM --- Launcher of Automatic Esko Tester VBS script ----------------------
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

REM _jsxTESTERNAME - "PDF Export Tester"
REM _jsxPROCESSSUBFOLDER - true/false
REM _jsxMASK - *.pdf /  *.ai
REM _jsxUSEIMPORTPDF - true/false
REM _jsxUSEIMPORTNDLPDF - true/false
REM _jsxJOBNAME - log prefix (used for logging mainly)
REM _jsxOUTPUTTYPE - 0 - Esko Normalized PDF / 1 - Esko Tiff / 2 - Esko NDLPDF / 3 - Esko PDF+

call %G_TIMESTAMP%

echo ^>Entering AETLauncher-PDFExport.bat>>%_LOGFILE%
echo ^>Entering AETLauncher-PDFExport.bat

echo. >>%_LOGFILE%
echo.
echo Starting %_TOPIC% Automated Esko Tester Launcher... >>%_LOGFILE%
echo Starting %_TOPIC% Automated Esko Tester Launcher...

if not exist %_OUTFOLDER% (md %_OUTFOLDER%)

REM Define not used parameters
if NOT DEFINED trapTicket (set trapTicket=NA)
set inkMappingFile=NA

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
    ) else (
        TIMEOUT /T 10 
        if "!ERRORLEVEL!" NEQ "0" (
            echo Launching Illustrator...
            echo Launching Illustrator... >>%_LOGFILE%
            
            if "%_REGIME%" EQU "AUTO" (
                cscript %_vbsAiStart% //Nologo %_vbsAINAME% >>%_LOGFILE%
            ) else (
                cscript %_vbsAiStart% //Nologo %_vbsAINAME%
            )
        )
    )

    set _THIS_TASKNAME=%%i
    call %G_TIMESTAMP%
    echo ### Task Name: !_THIS_TASKNAME!
    echo ### Task Name: !_THIS_TASKNAME! >>%_LOGFILE%
    if not exist %_OUTFOLDER%\!_THIS_TASKNAME! (md %_OUTFOLDER%\!_THIS_TASKNAME!) >>%_LOGFILE%
    echo Launching the following VB script %vbsAET% >>%_LOGFILE%
    echo In %_vbsAINAME% with signature %_jsxAISIGNATURE% process ExtendScript %_jsxSCRIPT% running tester %_jsxTESTERNAME%  >>%_LOGFILE%
    echo Take files from here "%_SOURCEFOLDER%\!_THIS_TASKNAME!"  >>%_LOGFILE%
    echo and process them there "%_OUTFOLDER%\!_THIS_TASKNAME!"  >>%_LOGFILE%
    echo with parameters: >>%_LOGFILE%
    echo Subfolders %_jsxPROCESSSUBFOLDER%, file mask %_jsxMASK%, use PDF Import %_jsxUSEIMPORTPDF% or use NDL PDF Import %_jsxUSEIMPORTNDLPDF%  >>%_LOGFILE%
    echo Trap ticket %trapTicket%, Ink Mapping File %inkMappingFile%, Job name %_jsxJOBNAME% and Output type %_jsxOUTPUTTYPE%  >>%_LOGFILE%
    
    if "%_REGIME%" EQU "AUTO" (
        cscript %vbsAET% //Nologo %_vbsAINAME% %_jsxSCRIPT% %_jsxAISIGNATURE% %_jsxTESTERNAME% "%_SOURCEFOLDER%\!_THIS_TASKNAME!" %_jsxPROCESSSUBFOLDER% %_jsxMASK% %_jsxUSEIMPORTPDF% %_jsxUSEIMPORTNDLPDF% "%_OUTFOLDER%\!_THIS_TASKNAME!" %trapTicket% %inkMappingFile% %_jsxJOBNAME% %_jsxOUTPUTTYPE% >>%_LOGFILE%
        ) else (
        echo Launching the following VB script %vbsAET%
        echo In %_vbsAINAME% with signature %_jsxAISIGNATURE% process ExtendScript %_jsxSCRIPT% running tester %_jsxTESTERNAME%
        echo Take files from here "%_SOURCEFOLDER%\!_THIS_TASKNAME!" 
        echo and process them there "%_OUTFOLDER%\!_THIS_TASKNAME!" 
        echo with parameters: 
        echo Subfolders %_jsxPROCESSSUBFOLDER%, file mask %_jsxMASK%, use PDF Import %_jsxUSEIMPORTPDF% or use NDL PDF Import %_jsxUSEIMPORTNDLPDF% 
        echo Trap ticket %trapTicket%, Ink Mapping File %inkMappingFile%, Job name %_jsxJOBNAME% and Output type %_jsxOUTPUTTYPE%
    
        cscript %vbsAET% //Nologo %_vbsAINAME% %_jsxSCRIPT% %_jsxAISIGNATURE% %_jsxTESTERNAME% "%_SOURCEFOLDER%\!_THIS_TASKNAME!" %_jsxPROCESSSUBFOLDER% %_jsxMASK% %_jsxUSEIMPORTPDF% %_jsxUSEIMPORTNDLPDF% "%_OUTFOLDER%\!_THIS_TASKNAME!" %trapTicket% %inkMappingFile% %_jsxJOBNAME% %_jsxOUTPUTTYPE%
    )
)

echo AET Launcher finished. >>%_LOGFILE%
echo AET Launcher finished. 
call %G_TIMESTAMP%