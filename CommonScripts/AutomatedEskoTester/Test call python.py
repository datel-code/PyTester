# calling_script.py
import subprocess
import json

AiName = "Illustrator.Application.29"
JSXScriptName = "T:\CommonHelpers\AutomatedEskoTester\Test-AiStart.jsx"
JSXParams = ["Param1", "Param2"]


def call_script_with_array(array_param):
    # Convert the array to a JSON string
    json_array = json.dumps(array_param)

    # Call the other script
    result = subprocess.run(
        ["python", "Test-AiStart.py", json_array],
        capture_output=True,
        text=True
    )

    # Capture the reply
    reply = result.stdout.strip()
    return reply

if __name__ == "__main__":
    array_param = [AiName, JSXScriptName, JSXParams]
    reply = call_script_with_array(array_param)
    print(f"Reply from called script: {reply}")