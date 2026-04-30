
SET TAiName="Illustrator.Application.29"
SET TJSXScriptName="T:\\CommonHelpers\\AutomatedEskoTester\\NDLPlusExportTester.jsx"

SET TAISignature="WAI29r"
SET TrequestedTesterName="PDF Export Tester"
SET TinputFolder="T:\\CommonSource\\PyTest"
SET TprocessSubfolder="false"
SET Tmask="*.ai"
SET TuseImportPDF="false"
SET TuseImportNDLPDF="false"
SET ToutputFolder="T:\\NDLPlus_BatchTesting\\Processed\\PyTest"
SET TjobName="Test"
SET ToutputType="3"
SET TinkMappingFile=""
SET TtrapTicket=""

python .\Test-AiStart.py %TAiName% %TJSXScriptName% %TAISignature% %TrequestedTesterName% %TinputFolder% %TprocessSubfolder% %Tmask% %TuseImportPDF% %TuseImportNDLPDF% %ToutputFolder% %TinkMappingFile% %TtrapTicket% %TjobName% %ToutputType%
pause