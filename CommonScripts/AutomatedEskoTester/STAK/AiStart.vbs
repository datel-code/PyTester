' --- Adobe Illustrator Launcher

'Ai app object
Dim appRef 

' ----------- PARAMETERS -----------
' Processing parameters
Dim AiName

Dim timer, counter, waiter
timer = 5000
counter = 3

' Set processing parameters
AiName = "Illustrator.Application.27"

'Launch Illustrator
Wscript.Echo "VBS: Launching Illustrator..."
Set appRef = CreateObject(AiName)
Wscript.Echo "VBS: AI Launched, waiting to start the script safely."

for waiter = counter to 0 step -1
    WScript.Sleep timer 
    Wscript.Stdout.Write waiter & " ... "
Next

Wscript.Stdout.WriteBlankLines(1)