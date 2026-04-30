import os
import shutil
import subprocess
from datetime import datetime

def get_timestamp():
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def connect_to_server():
    print("Checking servers...")
    log("Checking servers...")

    buildnumber_path = os.path.join(PLUGIN_SOURCE_FOLDER, "buildnumber.txt")
    if os.path.exists(buildnumber_path):
        print("Servers seem to be connected.")
        log("Servers seem to be connected.")
        return True

    print("Trying to re-connect...")
    log("Trying to re-connect...")
    with open(os.path.join(PPATH, "PWD"), 'r') as pwd_file:
        password = pwd_file.read().strip()

    result = subprocess.run(["net", "use", "H:", r"\\homer\deskpackplugins", "/user:esko-graphics\\tota", password], capture_output=True)
    log(result.stdout.decode())
    if result.returncode != 0:
        print("Trying to re-connect again...")
        log("Trying to re-connect again...")
        subprocess.run(["net", "use", "H:", "/delete", "/y"], capture_output=True)
        result = subprocess.run(["net", "use", "H:", r"\\homer\deskpackplugins", "/user:esko-graphics\\tota", password], capture_output=True)
        log(result.stdout.decode())

    if result.returncode != 0:
        print("Something wrong with server connection!")
        log("Something wrong with server connection!")
        return False

    return True

def log(message):
    with open(LOGFILE, 'a') as log_file:
        log_file.write(f"{get_timestamp()} - {message}\n")

def update_plugins():
    global COPYOK
    COPYOK = 1
    with open(PLUGIN_LIST_FILE, 'r') as file:
        lines = file.readlines()[2:]  # Skip the first two lines
        for line in lines:
            tokens = line.strip().split(',')
            if tokens[0] == "SKIP":
                print(f"Skipping {tokens[1]}...")
                log(f"Skipping {tokens[1]}...")
            else:
                subtype = ""
                if tokens[0] == "AI":
                    subtype = r"\Esko"
                source_folder = os.path.join(PLUGIN_SOURCE_FOLDER, tokens[0], f"Win_{AIVERSION}{subtype}", tokens[1])
                destination_folder = os.path.join(PLUGIN_DESTINATION_FOLDER, tokens[1])

                print(f"Copying from {source_folder}")
                log(f"Copying from {source_folder}")
                print(f"to {destination_folder}")
                log(f"to {destination_folder}")

                if not os.path.exists(destination_folder):
                    os.makedirs(destination_folder)

                result = subprocess.run(["robocopy", "/S", "/XO", "/Z", "/R:3", "/W:0", "/NJH", "/NJS", "/NP", "/NDL", source_folder, destination_folder, "*.*"], capture_output=True)
                log(result.stdout.decode())
                if result.returncode == 1:
                    print("--- Copied.")
                    log("--- Copied.")
                elif result.returncode == 0:
                    print("*** Nothing to copy.")
                    log("*** Nothing to copy.")
                else:
                    print(f"### {result.returncode} Difference or error!")
                    log(f"### {result.returncode} Difference or error!")
                    COPYOK = result.returncode

def copy_bundles():
    print(f"Copying bundles archive from {BUNDLE_SOURCE_FOLDER}")
    log(f"Copying bundles archive from {BUNDLE_SOURCE_FOLDER}")
    print(f"to {BUNDLE_DESTINATION_FOLDER}")
    log(f"to {BUNDLE_DESTINATION_FOLDER}")

    result = subprocess.run(["robocopy", "/Z", "/R:3", "/W:0", "/NJH", "/NJS", "/NP", "/NDL", BUNDLE_SOURCE_FOLDER, BUNDLE_DESTINATION_FOLDER, "*Win_Localisation.7z"], capture_output=True)
    log(result.stdout.decode())

    if result.returncode == 0:
        print("No new bundles found...")
        log("No new bundles found...")
    elif result.returncode > 7:
        print(f"Copying bundles using Robocopy finished with error {result.returncode}")
        log(f"Copying bundles using Robocopy finished with error {result.returncode}")
        return False

    return True

def extract_bundles():
    bundle_files = sorted([f for f in os.listdir(BUNDLE_DESTINATION_FOLDER) if f.endswith(".7z")], key=lambda x: os.path.getmtime(os.path.join(BUNDLE_DESTINATION_FOLDER, x)), reverse=True)
    if bundle_files:
        bundle_archive_file = os.path.join(BUNDLE_DESTINATION_FOLDER, bundle_files[0])
        print(f"Extracting bundles archive from {bundle_archive_file}")
        log(f"Extracting bundles archive from {bundle_archive_file}")
        print(f"to {BUNDLE_DESTINATION_FOLDER}")
        log(f"to {BUNDLE_DESTINATION_FOLDER}")

        result = subprocess.run([SEVEN_ZIP, "x", bundle_archive_file, "-aoa", f"-o{os.path.join(BUNDLE_DESTINATION_FOLDER, '..')}"], capture_output=True)
        log(result.stdout.decode())

def main():
    global LOGFILE, PPATH, PLUGIN_SOURCE_FOLDER, PLUGIN_DESTINATION_FOLDER, PLUGIN_LIST_FILE, AIVERSION, BUNDLE_SOURCE_FOLDER, BUNDLE_DESTINATION_FOLDER, SEVEN_ZIP, COPYOK

    REGIME = os.getenv("REGIME")
    if REGIME == "AUTO":
        updating = True
    else:
        answer = input("Update all plugins (Y/N)? ").strip().lower()
        updating = answer == 'y'

    if not updating:
        return

    UPDATE_REGIME = "STANDALONE"  # Set this as needed

    if UPDATE_REGIME == "STANDALONE":
        GLOBAL_HELPERS_FOLDER = r"\\ESKW210614\CommonHelpers"
        GLOBAL_SCRIPTS_FOLDER = os.path.join(GLOBAL_HELPERS_FOLDER, "CommonScripts")
        GLOBAL_PARAMETERS_FOLDER = os.path.join(GLOBAL_SCRIPTS_FOLDER, "Parameters")
        LOGFILE = os.path.join(GLOBAL_SCRIPTS_FOLDER, "Logging", "GlobalPluginsUpdater.log")

    # Load parameters
    # Assuming Parameters-GLOBAL.bat and Parameters-COMMON.bat set environment variables
    # You need to manually set these variables in Python or load them from a config file

    PPATH = r"c:\Esko"
    PLUGIN_SOURCE_FOLDER = r"source_folder_path"
    PLUGIN_DESTINATION_FOLDER = r"destination_folder_path"
    PLUGIN_LIST_FILE = r"plugin_list_file_path"
    AIVERSION = "version_number"
    BUNDLE_SOURCE_FOLDER = r"bundle_source_folder_path"
    BUNDLE_DESTINATION_FOLDER = r"bundle_destination_folder_path"
    SEVEN_ZIP = r"path_to_7zip_executable"

    log(">Entering UPDATEALLPLUGINS.bat")

    if not connect_to_server():
        return

    # Assuming G_KILLILL is a command to kill Illustrator process
    # You need to implement this in Python if required

    if COPYOK == 0:
        return

    update_plugins()

    if COPYOK == 0:
        return

    if not copy_bundles():
        return

    extract_bundles()

    log("Plugin extraction finished without error.")
    print("Plugin extraction finished without error.")

if __name__ == "__main__":
    main()