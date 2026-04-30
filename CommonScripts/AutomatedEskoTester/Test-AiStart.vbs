Dim appRef 
Dim AiName
Dim JSXScriptName
Dim JSXParams
AiName = "Illustrator.Application.27"
JSXScriptName = "T:\\CommonHelpers\\AutomatedEskoTester\\Test-AiStart.jsx"
JSXParams = [""]

'Launch Illustrator
Wscript.Echo "VBS: Launching Illustrator..."
Set appRef = CreateObject(AiName)
call appRef.DoJavaScriptFile(JSXScriptName, JSXParams, 1)
Wscript.Echo "VBS: Script Launched."
