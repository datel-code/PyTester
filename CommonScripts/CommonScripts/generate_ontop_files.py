import os
import sys

# Main function to generate .ontop files
def generate_ontop_files(input_dir, reference_dir):
    # Walk through all directories and files under the input directory
    for root, _, files in os.walk(input_dir):
        for file in files:
            # Process only .tif files
            if file.lower().endswith('.tif'):
                # Full path to the input .tif file
                input_path = os.path.join(root, file)
                # Relative path from the input directory (used for logging)
                rel_path = os.path.relpath(input_path, input_dir)
                # Construct the corresponding reference file path
                reference_path = os.path.join(reference_dir, rel_path)

                # Path to the 'diff' subdirectory next to the input file
                diff_dir = os.path.join(root, 'diff')
                # Construct the expected .jpg filename
                jpg_filename = os.path.splitext(file)[0] + '.jpg'
                jpg_path = os.path.join(diff_dir, jpg_filename)

                # Print the relative path of the processed .tif file
                print(rel_path)

                # Only proceed if the corresponding .jpg file exists
                if os.path.exists(jpg_path):
                    # Construct the .ontop filename and path
                    ontop_filename = os.path.splitext(file)[0] + '.ontop'
                    ontop_path = os.path.join(diff_dir, ontop_filename)

                    # Write the three lines to the .ontop file
                    with open(ontop_path, 'w') as f:
                        f.write(f"{input_path}\n")       # Line 1: path to input .tif
                        f.write(f"{reference_path}\n")   # Line 2: path to reference .tif
                        f.write(f"{jpg_path}\n")         # Line 3: path to diff .jpg

# Entry point when script is run from the command line
if __name__ == "__main__":
    # Expect exactly two arguments: input directory and reference directory
    if len(sys.argv) != 3:
        print("Usage: python generate_ontop_files.py <input_dir> <reference_dir>")
    else:
        # Call the main function with provided arguments
        generate_ontop_files(sys.argv[1], sys.argv[2])
