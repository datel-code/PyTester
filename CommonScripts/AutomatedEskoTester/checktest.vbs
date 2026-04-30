Function IsIllustratorRunning(strServer)
    Dim Process, strObject, strProcess
    IsProcessRunning = False
    strObject   = "winmgmts:\\" & strServer
    strProcess  = "illustrator.exe"
    For Each Process in GetObject( strObject ).InstancesOf( "win32_process" )
	If UCase( Process.name ) = UCase( strProcess ) Then
            IsProcessRunning = True
            Exit Function
        End If
    Next
End Function

Dim Check, IllustratorNotDead
IllustratorNotDead = true

WScript.Echo "Checking if the script is still running..."
IllustratorNotDead = IsIllustratorRunning(".")

if IllustratorNotDead = false then 
    Wscript.Echo "VBS: !!!!!!!!!!!!!!!!! ILLUSTRATOR CRASHED !!!!!!!!!!!!!!!!!"
end if
