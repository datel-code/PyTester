import win32com.client
import pywintypes
import time
import os
import sys
import psutil
import json
import tkinter as tk
from tkinter import messagebox

def isIllustratorRunning():
    # Iterate over all running processes
    for process in psutil.process_iter(['name']):
        try:
            # Check if the process name matches
            if process.info['name'] == "Illustrator.exe":
                return True
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass
    return False


def main():

    TAiName = "Illustrator.Application.29"
    TJSXScriptName = "T:\\CommonHelpers\\AutomatedEskoTester\\NDLPlusExportTester.jsx"

    TAISignature = "WAI29r"
    TrequestedTesterName = "PDF Export Tester"
    TinputFolder = "T:\\CommonSource\\PyTest"
    TprocessSubfolder = "false"
    Tmask = "*.ai"
    TuseImportPDF = "false"
    TuseImportNDLPDF = "false"
    ToutputFolder = "T:\\NDLPlus_BatchTesting\\Processed\\PyTest"
    TjobName = "Test"
    ToutputType = 3
    TinkMappingFile = ""
    TtrapTicket = ""

    TJSXParams = [TAISignature, TrequestedTesterName, TinputFolder, TprocessSubfolder, Tmask, TuseImportPDF, TuseImportNDLPDF, ToutputFolder, TinkMappingFile, TtrapTicket, TjobName, ToutputType]

    # AiName = TAiName
    # JSXScriptName = TJSXScriptName
    # JSXParams = TJSXParams

    # Check if the correct number of arguments are provided
    if len(sys.argv) != 15:
        print(f"Python Error: Wrong number of parameters. 14 expected, {len(sys.argv) - 1} received.")
        sys.exit(99)

    # Get the parameters
    AiName = sys.argv[1]
    JSXScriptName = sys.argv[2]
    TAISignature = sys.argv[3]
    TrequestedTesterName = sys.argv[4]
    TinputFolder = sys.argv[5]
    TprocessSubfolder = sys.argv[6]
    Tmask = sys.argv[7]
    TuseImportPDF = sys.argv[8]
    TuseImportNDLPDF = sys.argv[9]
    ToutputFolder = sys.argv[10]
    TinkMappingFile = sys.argv[11]
    TtrapTicket = sys.argv[12]
    TjobName = sys.argv[13]
    ToutputType = sys.argv[14]

    # Use the parameters
    print(f"AiName: {AiName}")
    print(f"JSXScriptName: {JSXScriptName}")
    print(f"TAISignature: {TAISignature}")
    print(f"TrequestedTesterName: {TrequestedTesterName}")
    print(f"TinputFolder: {TinputFolder}")
    print(f"TprocessSubfolder: {TprocessSubfolder}")
    print(f"Tmask: {Tmask}")
    print(f"TuseImportPDF: {TuseImportPDF}")
    print(f"TuseImportNDLPDF: {TuseImportNDLPDF}")
    print(f"ToutputFolder: {ToutputFolder}")
    print(f"TinkMappingFile: {TinkMappingFile}")
    print(f"TtrapTicket: {TtrapTicket}")
    print(f"TjobName: {TjobName}")
    print(f"ToutputType: {ToutputType}")
    # Create a root window (it can be hidden)
    root = tk.Tk()
    root.withdraw()  # Hide the root window

    messagebox.showinfo("OK?")

    return

    # Parameters
    timer = 3  # seconds
    counter = 10
    no_of_args = 1
    jsxCheck = os.path.dirname(os.path.abspath(__file__)) + "\\AutomatedEskoTester-Check.jsx"
    checkIfRunning = 1

    # Check the number of arguments
    #if len(sys.argv) != no_of_args + 1:
    #    print(f"Python Error: Wrong number of parameters. {no_of_args} expected, {len(sys.argv) - 1} received.")
    #    sys.exit(99)

    # Set processing parameters
    # ai_name = sys.argv[1]
    # ai_name = "Illustrator.Application.29"


    doesAiRun = isIllustratorRunning()

    try:
        # Launch Illustrator
        appRef = win32com.client.Dispatch(AiName)
    except Exception as e:
        print(f"An error occurred while initializing Ai: {e}")
        sys.exit(99)

    if not doesAiRun:
        print("Python: AI Launched, waiting to start the script safely.")
        for waiter in range(counter, -1, -1):
            time.sleep(timer) 
            print(f"{waiter} ... ", end='', flush=True)

        print("\n")

    else: 
        print("Python: AI already launched.")

    try:
        appRef.DoJavaScriptFile(JSXScriptName, JSXParams)
        
    except Exception as e:
        print(f"An error occurred while launching the script: {e}")
        sys.exit(99)

    time.sleep(timer) 
    counter = 1
    while checkIfRunning == 1:
        checkIfRunning = int(appRef.DoJavaScriptFile(jsxCheck, JSXParams))
        print(f"\rAi is still in charge... {counter}", end='', flush=True)
        counter += 1
        time.sleep(timer) 

    print("\nDone.", flush=True)


if __name__ == "__main__":
    main()


