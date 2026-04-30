' --- Adobe Illustrator Launcher

'Ai app object
Dim appRef 

' ----------- PARAMETERS -----------
' Processing parameters
Dim AiName

Dim timer, counter, waiter
timer = 5000
counter = 10

'Expected full number of parameters coming in
noOfArgs = 1

If  WScript.Arguments.Count <> noOfArgs Then 
    WScript.Echo "VBS Error: Wrong number of parameters. " & noOfArgs & " expected, " & WScript.Arguments.Count & " received."
    WScript.Quit 99
End If

' Set processing parameters
AiName = WScript.Arguments(0)

'Launch Illustrator
Wscript.Echo "VBS: Launching Illustrator..."
Set appRef = CreateObject(AiName)
Wscript.Echo "VBS: AI Launched, waiting to start the script safely."

for waiter = counter to 0 step -1
    WScript.Sleep timer 
    Wscript.Stdout.Write waiter & " ... "
Next

Wscript.Stdout.WriteBlankLines(1)