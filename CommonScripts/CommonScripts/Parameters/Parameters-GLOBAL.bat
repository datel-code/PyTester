REM -----------------------------------------------------------------------
REM --- GLOBAL PARAMETERS -------------------------------------------------
REM --- Global environmental parameters -----------------------------------
REM -----------------------------------------------------------------------

REM Application paths and versions
REM use one of the following definitions
REM This for normal Illustrator release versions:
set _AIFOLDER="Adobe Illustrator 2026"
REM This for Pre Ais:
rem set _AIFOLDER="ADA394~1"
REM This for Betas
rem set _AIFOLDER="ADB087~1"

set _vbsAINAME=Illustrator.Application.30
set _AIVERSION=AI30
set _jsxAISIGNATURE=W%_AIVERSION%r
set _DPVERSION=26_07
set _NDLDPVERSION=26_07
set _MAJORVERSION=26.07
call %_GLOBALSCRIPTSFOLDER%\GET_AI_BUILD.bat
set /p _AIBUILD=< %_AIBUILDFILE%

REM Define UNC server name replacement (NMT Bug)
set "_UNC_ROOT_SERVER=\\ESKW210614"
set "_DOS_ROOT_SERVER=T:"

REM Plugin sources
set _PLUGINSOURCEFOLDER=\\homer\DeskPackPlugins\DeskPack%_DPVERSION%
set _BUNDLESOURCEFOLDER=\\homer\DeskPackPlugins\DeskPack%_DPVERSION%\Archive
REM ---> Only for getting the build number
set _NDLPLUGINSOURCEFOLDER=\\homer\DeskPackPlugins\DeskPack%_NDLDPVERSION%\NDL
REM <---
set "_PLUGINDESTINATIONFOLDER=c:\Program Files\Adobe\%_AIFOLDER%\Plug-ins\Esko"
set _PLUGINDESTINATIONFOLDER=%_PLUGINDESTINATIONFOLDER:"=%
set "_BUNDLEDESTINATIONFOLDER=c:\Program Files\Adobe\%_AIFOLDER%\Esko"
set _BUNDLEDESTINATIONFOLDER=%_BUNDLEDESTINATIONFOLDER:"=%

REM Global Parameter Configurators
set P_GLOBAL=%_GLOBALPARAMETERSFOLDER%\Parameters-GLOBAL.bat
REM What plugins to update
set _PLUGINSLISTFILE=%_GLOBALPARAMETERSFOLDER%\Parameters-Update.txt

REM Define global helpers
REM NeoModelTest
set _NMTROOT=C:\Esko\bg_prog_ndlmodeltest_v260
set _NMTDRIVER=%_NMTROOT%\NDLModelTest.app\Contents\Windows\NDLModelTestDriver.exe
set _NMTREPORT=%_NMTROOT%\NDLModelTest.app\Contents\Windows\NDLModelTestReporter.exe
set _NMTEXE=%_NMTROOT%\NDLModelTest.app\Contents\Windows\NDLModelTest.exe
set "_NMTRSEXE=%_NMTROOT%\NDLModelTest.app\Contents\Windows\NDLModelTestReportServer.exe  -config C:\Esko\bg_prog_ndlmodeltest_v260\NDLModelTest.app\Contents\Resources\ReportServer\config.yaml -web-dir C:\Esko\bg_prog_ndlmodeltest_v260\NDLModelTest.app\Contents\Resources\ReportServer\web -build-dates "C:\Users\qaadmin\Documents\NDLModelTest Report\builddates.xml" -reports-dir "C:\Users\qaadmin\Documents\NDLModelTest Report" -output-dir \\eskw210614\TrapTQ_BatchTesting\Processed\ -api-domain eskw210614.esko-graphics.com"
set "_NMTREPORTROOT=C:\Users\qaadmin\Documents\NDLModelTest Report"
set "_NMTREPORTLINK_UNC=http://ESKW210614:3000/tests"

REM JAVA
rem set _JAVA="T:\CommonHelpers\openjdk-12.0.1_windows-x64_bin\jdk-12.0.1\bin\java"
set _SAXON="%_GLOBALHELPERSFOLDER%\XSL\XSLProcessor\saxon9he.jar"
set _JAVA="%_GLOBALHELPERSFOLDER%\openjdk-12.0.1_windows-x64_bin\jdk-12.0.1\bin\java"
REM 7Zip
set _7Zip="%_GLOBALHELPERSFOLDER%\7z\7za.exe"
REM Blat mailer
set _THEBLAT="%_GLOBALHELPERSFOLDER%\blat3222\full\blat.exe"
REM EGCompare 
set _BRIXDRIVER=%BG_PROG_PACKEDGE_V240%\bin_ix86\brixsdb.exe
set _EGCDRIVER=C:\Esko\bg_prog_packedge_v201\bin_ix86\egcompare.exe
 
 