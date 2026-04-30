
'Ai app object
Dim appRef 

Dim AiName
Dim jsxScript 
Dim jsxCheck
Dim jsxArguments(0)
jsxArguments(0) = ""
'------------------------------------

'Init scripting
Set oShell = CreateObject("WScript.Shell")
Set oFSO = CreateObject("Scripting.FileSystemObject")
oShell.CurrentDirectory = oFSO.GetParentFolderName(Wscript.ScriptFullName)
currentDir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)

AiName = "Illustrator.Application.27"
jsxScript = currentDir & "\Tester.jsx"
jsxCheck = currentDir & "\Tester-Check.jsx"

'Launch Illustrator
Wscript.Echo "VBS: Activating Illustrator..."
Set appRef = CreateObject(AiName)
Wscript.Echo "VBS: Activated."
Wscript.Echo "VBS: Starting the JSX script " & jsxScript


call appRef.DoJavaScriptFile(jsxScript, jsxArguments, 1)

if Error <> 0 Then
    WScript.Echo "VBS Error:" & Error.Descriptor
End If

'Wait until the generator finishes work
Dim Check, count
Check = 1
count = 1
Do While count < 1000
 	WScript.Sleep 5000
    Err.Clear 
    check = appRef.DoJavaScriptFile(jsxCheck, jsxArguments, 1)
    If Err.Number <> 0 Then 
        Wscript.Stdout.WriteBlankLines(1)
        Wscript.Echo "VBS: Illustrator object is unavailable, Ai could be already dead." 
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

