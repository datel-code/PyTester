REM -----------------------------------------------------------------------
REM --- Comparing engine using EGCompare--- -------------------------------
REM --- Single/Multifolder version ----------------------------------------
REM -----------------------------------------------------------------------

REM Following variables must be already defined:
REM --- Global variables ---
REM _LOGFILE - Common log file name

REM --- Tester specific variables
REM _CMP_IN - Folder where to get the input data from (originally _OUTFOLDER)
REM _CMP_OUT - Folder where NMT saves the comparing results
REM _SUBTASKSLISTFILE - File with actual list of processed tickets (generated during AET run)
REM _MULTIFOLDER_CMP - General switch indicating the output mode multifolder/flat
REM _PRECMPLOGFILE
REM _CMPLOGFILE

REM --- Tester specific helpers
REM _BRIXDRIVER
REM _EGCDRIVER

echo ^>Entering CMPECG.bat /%_TOPIC%/>>%_LOGFILE%
echo ^>Entering CMPECG.bat /%_TOPIC%/

echo Starting EG Compare...
echo Starting EG Compare...>>%_LOGFILE%
if "%_MULTIFOLDER_CMP%" EQU "YES" (
	echo Running in folder mode
	echo Running in folder mode>>%_LOGFILE%
	) else (
	echo Running in flat mode
	echo Running in flat mode>>%_LOGFILE%
	)
SETLOCAL EnableDelayedExpansion 
if "%_MULTIFOLDER_CMP%" EQU "YES" (
    REM Initialize Pre-compare log file
    echo Pre-Compare rendering collected logs: > %_PRECMPLOGFILE%
    REM Initialize Compare log file
    echo Compare collected logs: > %_CMPLOGFILE%
    REM Get the real output folder names

    for /F "skip=1" %%i in (%_SUBTASKSLISTFILE%) do (
        set _THIS_TASKNAME=%%i
        set _THIS_CMPOUTFOLDER=%_CMP_OUT%\!_THIS_TASKNAME!
        set _THIS_CMPOUTFOLDER_CT=%_CMP_OUT_CT%\!_THIS_TASKNAME!
        if "%_KNOWNISSUESPERTASK%" EQU "YES" (
            set _THIS_KNOWNISSUES=%_KNOWNISSUES%-!_THIS_TASKNAME!.txt
        ) else (
            set _THIS_KNOWNISSUES=%_KNOWNISSUES%
        )
        echo Task: !_THIS_TASKNAME!
        echo Task: !_THIS_TASKNAME! >>%_LOGFILE%
        if "%_SKIPPROCES%" EQU "NO" (
            if not exist !_THIS_CMPOUTFOLDER_CT! md !_THIS_CMPOUTFOLDER_CT!
            if not exist !_THIS_CMPOUTFOLDER_CT!\log md !_THIS_CMPOUTFOLDER_CT!\log
            if not exist !_THIS_CMPOUTFOLDER_CT!\diff md !_THIS_CMPOUTFOLDER_CT!\diff

            Echo Generating CT from PDF files...
            Echo Generating CT from PDF files... >>%_LOGFILE%
			echo CT Generation command:>>%_LOGFILE%
			echo %_BRIXDRIVER% pdf_tfw %_CMP_IN%\*.pdf /TASK=RENDER >>%_LOGFILE%
			echo /OUT=%_CMP_OUT_CT% /OUTFORMAT=CT /PPI=300 /recurse /REPORT >>%_LOGFILE%
			
			echo CT Generation command:>>%_LOGFILE%
			echo %_BRIXDRIVER% pdf_tfw %_CMP_IN%\!_THIS_TASKNAME!\*.pdf /TASK=RENDER >>%_LOGFILE%
			echo /OUT=!_THIS_CMPOUTFOLDER_CT! /OUTFORMAT=CT /PPI=300 /REPORT >>%_LOGFILE%

			echo CT Generation command:
			echo %_BRIXDRIVER% pdf_tfw %_CMP_IN%\!_THIS_TASKNAME!\*.pdf /TASK=RENDER 
			echo /OUT=!_THIS_CMPOUTFOLDER_CT! /OUTFORMAT=CT /PPI=300 /REPORT 

            %_BRIXDRIVER% pdf_tfw %_CMP_IN%\!_THIS_TASKNAME!\*.pdf /TASK=RENDER /OUT=!_THIS_CMPOUTFOLDER_CT! /OUTFORMAT=CT /PPI=300 /REPORT >> %_PRECMPLOGFILE%
            
            if not exist !_THIS_CMPOUTFOLDER! md !_THIS_CMPOUTFOLDER!
            if not exist !_THIS_CMPOUTFOLDER!\log md !_THIS_CMPOUTFOLDER!\log
            if not exist !_THIS_CMPOUTFOLDER!\diff md !_THIS_CMPOUTFOLDER!\diff

            Echo Comparing testing and reference CT files... 
            Echo Comparing testing and reference CT files... >>%_LOGFILE%

			echo Compare command:>>%_LOGFILE%
			echo %_EGCDRIVER% /MINPIX=500 /image /ONTOP /XMP /WRITEJPEG >>%_LOGFILE%
			echo /OUT=!_THIS_CMPOUTFOLDER!\log\cmp_!_THIS_TASKNAME!.log >>%_LOGFILE%
			echo /diffct=!_THIS_CMPOUTFOLDER!\diff\[FILE].ontop >>%_LOGFILE%
			echo !_THIS_CMPOUTFOLDER_CT! %_REFFOLDER%\!_THIS_TASKNAME! >>%_LOGFILE%
			
			echo Compare command:
			echo %_EGCDRIVER% /MINPIX=500 /image /ONTOP /XMP /WRITEJPEG 
			echo /OUT=!_THIS_CMPOUTFOLDER!\log\cmp_!_THIS_TASKNAME!.log 
			echo /diffct=!_THIS_CMPOUTFOLDER!\diff\[FILE].ontop 
			echo !_THIS_CMPOUTFOLDER_CT! %_REFFOLDER%\!_THIS_TASKNAME! 
			
			%_EGCDRIVER% /MINPIX=500 /image /ONTOP /XMP /WRITEJPEG /OUT=!_THIS_CMPOUTFOLDER!\log\cmp_!_THIS_TASKNAME!.log /diffct=!_THIS_CMPOUTFOLDER!\diff\[FILE].ontop !_THIS_CMPOUTFOLDER_CT! %_REFFOLDER%\!_THIS_TASKNAME! 
        )
        Echo Generating report using Known Issues file !_THIS_KNOWNISSUES!... 
        Echo Generating report using Known Issues file !_THIS_KNOWNISSUES!... >>%_LOGFILE%
        %_EGCDRIVER% /format !_THIS_CMPOUTFOLDER!\log\cmp_!_THIS_TASKNAME!.log /COMMENTS=!_THIS_KNOWNISSUES!

        REM Collect compare log file
        echo. >> %_CMPLOGFILE%
        echo *** The log of the task: !_THIS_TASKNAME! >> %_CMPLOGFILE%
        type !_THIS_CMPOUTFOLDER!\log\cmp_!_THIS_TASKNAME!.log >> %_CMPLOGFILE%
    )
) else (
    REM Flat structure

    if "%_SKIPPROCES%" EQU "NO" (
        if not exist %_CMP_OUT_CT% md %_CMP_OUT_CT%
        if not exist %_CMP_OUT%\log md %_CMP_OUT%\log
        if not exist %_CMP_OUT%\diff md %_CMP_OUT%\diff

        Echo Generating CT from PDF files...
        Echo Generating CT from PDF files... >>%_LOGFILE%
		
		echo CT Generation command:>>%_LOGFILE%
		echo %_BRIXDRIVER% pdf_tfw %_CMP_IN%\*.pdf /TASK=RENDER >>%_LOGFILE%
		echo /OUT=%_CMP_OUT_CT% /OUTFORMAT=CT /PPI=300 /recurse /REPORT >>%_LOGFILE%
		
		echo CT Generation command:
		echo %_BRIXDRIVER% pdf_tfw %_CMP_IN%\*.pdf /TASK=RENDER 
		echo /OUT=%_CMP_OUT_CT% /OUTFORMAT=CT /PPI=300 /recurse /REPORT 
		
        %_BRIXDRIVER% pdf_tfw %_CMP_IN%\*.pdf /TASK=RENDER /OUT=%_CMP_OUT_CT% /OUTFORMAT=CT /PPI=300 /recurse /REPORT >> %_PRECMPLOGFILE%

        Echo Comparing testing and reference CT files... 
        Echo Comparing testing and reference CT files... >>%_LOGFILE%
		
		echo Compare command:>>%_LOGFILE%
		echo %_EGCDRIVER% /MINPIX=500 /image /ONTOP /XMP /WRITEJPEG >>%_LOGFILE%
		echo /OUT=%_CMP_OUT%\log\cmp_%_TOPIC%.log >>%_LOGFILE%
		echo /diffct=%_CMP_OUT%\diff\[FILE].ontop >>%_LOGFILE%
		echo %_CMP_OUT_CT% %_REFFOLDER%>>%_LOGFILE%
		
		echo Compare command:
		echo %_EGCDRIVER% /MINPIX=500 /image /ONTOP /XMP /WRITEJPEG 
		echo /OUT=%_CMP_OUT%\log\cmp_%_TOPIC%.log 
		echo /diffct=%_CMP_OUT%\diff\[FILE].ontop 
		echo %_CMP_OUT_CT% %_REFFOLDER%
		
        %_EGCDRIVER% /MINPIX=500 /image /ONTOP /XMP /WRITEJPEG /OUT=%_CMP_OUT%\log\cmp_%_TOPIC%.log /diffct=%_CMP_OUT%\diff\[FILE].ontop %_CMP_OUT_CT% %_REFFOLDER%
    )

    Echo Generating report using Known Issues file %_KNOWNISSUES%...   
    Echo Generating report using Known Issues file %_KNOWNISSUES%... >>%_LOGFILE%
    %_EGCDRIVER% /format %_CMP_OUT%\log\cmp_%_TOPIC%.log /COMMENTS=%_KNOWNISSUES% 
)
    
echo Comparing done.
echo Comparing done. >>%_LOGFILE%

REM Cleanup of Compare logs
type %_PRECMPLOGFILE% | findstr /v license | findstr /v FlexNet | findstr /v scrf > %_FINDTMPFILE%
copy %_FINDTMPFILE% %_PRECMPLOGFILE% /Y

if exist %_FINDTMPFILE% (del %_FINDTMPFILE% /Q)


echo %_TOPIC% Pre-compare Render Log File: %_PRECMPLOGFILE%
echo %_TOPIC% Compare Errors Log File: %_CMPLOGFILE%

echo %_TOPIC% Pre-compare Render Log File: %_PRECMPLOGFILE% >>%_LOGFILE%
echo %_TOPIC% Compare Errors Log File: %_CMPLOGFILE% >>%_LOGFILE%

EXIT /B 0
