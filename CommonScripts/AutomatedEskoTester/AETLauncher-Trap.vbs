' ------------ 6. Trapping Tester

' 2-inputFolder - Path
' 3-processSubfolder - true/false
' 4-mask - *.pdf /  *.ai
' 5-useImportPDF - true/false
' 6-useImportNDLPDF - true/false
' 7-ticketsFolder - Path to trapping tickets / 
' 8-outputFolder  - Output path
' 9-jobName  - log prefix
' 10-outputType - 0 - Esko Normalized PDF / 1 - Esko Tiff / 2 - Esko NDLPDF


'Ai app object
Dim appRef 

' ----------- PARAMETERS -----------
' Processing parameters
Dim AiName
Dim jsxScript 
' Passed parameters
Dim AISignature
Dim testerName
Dim inputFolder
Dim processSubfolder
Dim mask
Dim useImportPDF
Dim useImportNDLPDF
Dim ticketsFolder
Dim outputFolder
Dim jobName
Dim outputType
'------------------------------------

' Other variables
Dim noOfArgs
Dim noOfTestArgs
Dim jsxArguments

Dim jsxCheck

Function IsIllustratorRunning(strServer)
    Dim Process, strObject, strProcess
    IsIllustratorRunning = False
    strObject   = "winmgmts:\\" & strServer
    strProcess  = "Illustrator.exe"
    For Each Process in GetObject( strObject ).InstancesOf( "win32_process" )
	If UCase( Process.name ) = UCase( strProcess ) Then
            IsIllustratorRunning = True
            Exit Function
        End If
    Next
End Function

Function TerminateIllustrator(strServer)
    Dim Process, strObject, strProcess
    strObject   = "winmgmts:\\" & strServer
    strProcess  = "Illustrator.exe"
    For Each Process in GetObject( strObject ).InstancesOf( "win32_process" )
        If UCase( Process.name ) = UCase( strProcess ) Then
            Process.Terminate()
            Exit Function
        End If
    Next
End Function

'Expected full number of parameters coming in
noOfArgs = 13

If  WScript.Arguments.Count <> noOfArgs Then 
    WScript.Echo "VBS Error: Wrong number of parameters. " & noOfArgs & " expected, " & WScript.Arguments.Count & " received."
    WScript.Quit 99
End If

' Set processing parameters
AiName = WScript.Arguments(0)
jsxScript = WScript.Arguments(1)

AISignature = WScript.Arguments(2)
testerName = WScript.Arguments(3)
inputFolder = WScript.Arguments(4)
processSubfolder = WScript.Arguments(5)
mask = WScript.Arguments(6)
useImportPDF = WScript.Arguments(7)
useImportNDLPDF = WScript.Arguments(8)
ticketsFolder = WScript.Arguments(9)
outputFolder = WScript.Arguments(10)
jobName = WScript.Arguments(11)
outputType = WScript.Arguments(12)

jsxArguments = Array(AISignature, testerName, inputFolder, processSubfolder, mask, useImportPDF, useImportNDLPDF, ticketsFolder, outputFolder, jobName, outputType)

'Init scripting
Set oShell = CreateObject("WScript.Shell")
Set oFSO = CreateObject("Scripting.FileSystemObject")
oShell.CurrentDirectory = oFSO.GetParentFolderName(Wscript.ScriptFullName)
currentDir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)

jsxCheck = currentDir & "\AutomatedEskoTester-Check.jsx"

'Launch Illustrator
Wscript.Echo "VBS: Activating Illustrator..."
Set appRef = CreateObject(AiName)
Wscript.Echo "VBS: Activated."
Wscript.Echo "VBS: Starting the JSX script " & jsxScript
'Wscript.Echo "VBS: Arguments: " 
'for count = 0 To uBound(jsxArguments)
'    Wscript.Echo count & ": " & jsxArguments(count)
'next

call appRef.DoJavaScriptFile(jsxScript, jsxArguments, 1)
if Error <> 0 Then
    WScript.Echo "VBS Error:" & Error.Descriptor
End If

'Wait until the generator finishes work
Dim Check, IllustratorNotDead, count
IllustratorNotDead = true
Check = 1
count = 1
Do While count < 1000
    IllustratorNotDead = IsIllustratorRunning(".")
    if IllustratorNotDead = false then 
        Wscript.Stdout.WriteBlankLines(1)
        Wscript.Echo "VBS: Illustrator is dead." 
        exit do
    else
        Wscript.Stdout.Write "VBS: Illustrator is running... / "
    end if
	WScript.Sleep 5000
    Err.Clear 
    check = appRef.DoJavaScriptFile(jsxCheck, jsxArguments, 1)
    If Err.Number <> 0 Then 
        Wscript.Stdout.WriteBlankLines(1)
        Wscript.Echo "VBS: Illustrator object is unavailable, Ai could be already dead." 
        IllustratorNotDead = false
        exit do
    end If
    if check = 1 then 
        Wscript.Stdout.Write "Tester is running... (" & count & ")" & chr(13)
    else
        Wscript.Stdout.WriteBlankLines(1)
        Wscript.Echo "VBS: Tester has stopped. (" & check & ")"
        exit do
    end if
	WScript.Sleep 5000
    count = count + 1
Loop


if count >= 1000 then
    Wscript.Echo "VBS: TIMEOUT!"
    TerminateIllustrator(".")
end if

if IllustratorNotDead = false and check = 1 then 
    Wscript.Echo "VBS: !!!!!!!!!!!!!!!!! ILLUSTRATOR CRASHED !!!!!!!!!!!!!!!!!"
end if
