REM -----------------------------------------------------------------------
REM --- COMMON PARAMETERS - MAC -------------------------------------------
REM --- Parameters common for all testers ---------------------------------
REM -----------------------------------------------------------------------

REM Automated Esko Tester name and location
set _AETFOLDER=%_GLOBALHELPERSFOLDER%\AutomatedEskoTester
set _AETCOMMONNAME=%_AETFOLDER%\AETLauncher
set _jsxSCRIPT=%_AETFOLDER%\AutomatedEskoTester.jsx

REM Define local script folders 
set _HELPERSFOLDER=%_ROOT%\_Helpers
set _SCRIPTSFOLDER=%_HELPERSFOLDER%\Scripts\Specific

REM MAC specific override
rem set _PARAMETERSFOLDER=%_HELPERSFOLDER%\Scripts\Parameters

REM Common Parameter Configurators
set P_NMTCompare=%_PARAMETERSFOLDER%\Parameters-NMTCompare.bat
set P_EGCompare=%_PARAMETERSFOLDER%\Parameters-EGCompare.bat
set P_NMTTrap=%_PARAMETERSFOLDER%\Parameters-NMTTrap.bat
set P_Statistics=%_PARAMETERSFOLDER%\Parameters-Statistics.bat
set P_Transform=%_PARAMETERSFOLDER%\Parameters-Transform.bat
set P_Mailer=%_PARAMETERSFOLDER%\Parameters-Mailer.bat

REM Common Helpers
set _G_VBSCRIPTSFOLDER=%_GLOBALSCRIPTSFOLDER%\VBScripts
set G_vbsSUM=%_G_VBSCRIPTSFOLDER%\sum.vbs


set G_STARTLOGGING=%_GLOBALSCRIPTSFOLDER%\STARTLOGGING.bat
set G_GETBUILDNUMBERS=%_GLOBALSCRIPTSFOLDER%\GETBUILDNUMBERS.bat
set G_SETTIMESTAMP=%_GLOBALSCRIPTSFOLDER%\SETTIMESTAMP.bat
set G_TIMESTAMP=%_GLOBALSCRIPTSFOLDER%\TIMESTAMP.bat
set G_UPDATEALLPLUGINS=%_GLOBALSCRIPTSFOLDER%\UPDATEALLPLUGINS.bat
set G_CLEANUP_PROCESSED=%_GLOBALSCRIPTSFOLDER%\CLEANUP_PROCESSED.bat
set G_CLEANUP_COMPARED=%_GLOBALSCRIPTSFOLDER%\CLEANUP_COMPARED.bat
set G_CLEANUP_REFERENCE=%_GLOBALSCRIPTSFOLDER%\CLEANUP_REFERENCE.bat
set G_NMTCOMPARE=%_GLOBALSCRIPTSFOLDER%\CMPNMT.bat
set G_EGCOMPARE=%_GLOBALSCRIPTSFOLDER%\CMPEGC.bat
set G_KILLILL=%_GLOBALSCRIPTSFOLDER%\KILLILL.bat
set G_EXPORTLOGSPROCESSING=%_GLOBALSCRIPTSFOLDER%\EXPORTLOGSPROCESSING.bat
set G_STATCOMMON=%_GLOBALSCRIPTSFOLDER%\STATCOMMON.bat
set G_TRANSFORM=%_GLOBALSCRIPTSFOLDER%\TRANSFORM.bat
set G_SENDREPORT=%_GLOBALSCRIPTSFOLDER%\MAILER.bat
set G_GETSAFEDATE=%_GLOBALSCRIPTSFOLDER%\GETSAFEDATE.bat

REM XSLT common folder
set _G_XSLTFOLDER=%_GLOBALHELPERSFOLDER%\XSL

REM HTML common folder
set _G_HTMLFOLDER=%_GLOBALHELPERSFOLDER%\HTML

REM Automatic Esko Tester common
set _vbsAiStart=%_AETCOMMONNAME%-AiStart.vbs

REM Indication of autoupdate skipping
set "_WARNING_UPDATESKIPPED= "

REM Common folder names for outputs
set _PROCESSEDFOLDER=%_ROOT%\Processed
set _OUTFOLDER=%_PROCESSEDFOLDER%\%_TOPIC%
set _CMP_FOLDERNAME=Compared

REM MAC specific override
set _MAC_PROCESSEDFOLDER=%_MAC_ROOT%\Processed

REM Log folder
set _LOGFOLDER=%_HELPERSFOLDER%\Logging

REM Global TMP folders
set _GTMP=%_HELPERSFOLDER%\TMP
if not exist %_GTMP% MD %_GTMP%
set _FINDTMPFILE=%_GTMP%\find.tmp
set _DATATMPFILE=%_GTMP%\data.tmp



