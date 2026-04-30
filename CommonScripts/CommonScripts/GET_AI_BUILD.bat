
rem Get active Illustrator build number
set _AIFOLDERCLEAN=%_AIFOLDER:"=%
set _AIBUILDFILE=%_GLOBALSCRIPTSFOLDER%\AiBuild.txt
echo N/A>%_AIBUILDFILE%

if exist "c:\Program Files\Adobe\%_AIFOLDERCLEAN%\Support Files\Contents\Windows\illustrator.exe" (
    powershell -command "[System.Diagnostics.FileVersionInfo]::GetVersionInfo('c:\Program Files\Adobe\%_AIFOLDERCLEAN%\Support Files\Contents\Windows\illustrator.exe').FileVersion" > %_AIBUILDFILE%
    echo .>> %_AIBUILDFILE%
    powershell -command "[System.Diagnostics.FileVersionInfo]::GetVersionInfo('c:\Program Files\Adobe\%_AIFOLDERCLEAN%\Support Files\Contents\Windows\illustrator.exe').FileVersionRaw.Revision" >> %_AIBUILDFILE%
    set Rel=Y
    )
rem Remove extra EOLs from the temp file
setlocal EnableDelayedExpansion
set row=
for /f %%x in (%_AIBUILDFILE%) do set "row=!row!%%x"
>%_AIBUILDFILE% echo %row%

goto :eof