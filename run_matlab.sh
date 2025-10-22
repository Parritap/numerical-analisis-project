#!/bin/bash

# Script to run MATLAB files with relative paths
# Usage: ./run_matlab.sh <relative_path_to_matlab_file>

if [ $# -eq 0 ]; then
    echo "Error: No MATLAB file specified"
    echo "Usage: ./run_matlab.sh <path_to_matlab_file>"
    echo "Example: ./run_matlab.sh src/methods/newton_rapson_tabular.m"
    exit 1
fi

# Get the absolute path of the MATLAB file
MATLAB_FILE="$1"
ABSOLUTE_PATH="$(cd "$(dirname "$MATLAB_FILE")" && pwd)/$(basename "$MATLAB_FILE")"

# Check if file exists
if [ ! -f "$ABSOLUTE_PATH" ]; then
    echo "Error: File '$MATLAB_FILE' not found"
    exit 1
fi

echo "Running MATLAB file: $ABSOLUTE_PATH"
echo "----------------------------------------"

# Get the directory and filename
DIR_PATH="$(dirname "$ABSOLUTE_PATH")"
FILE_NAME="$(basename "$ABSOLUTE_PATH" .m)"

# Check if file contains 'input(' for interactive mode
if grep -q "input(" "$ABSOLUTE_PATH"; then
    echo "Interactive mode detected (file uses input())"
    # Run MATLAB in interactive mode without desktop GUI
    # Add the directory to path and run the script
    matlab -nodesktop -nosplash -r "cd('$DIR_PATH'); $FILE_NAME; exit;"
else
    echo "Batch mode"
    # Run MATLAB in batch mode (non-interactive)
    matlab -batch "cd('$DIR_PATH'); $FILE_NAME;"
fi

# Alternative for Octave (uncomment and comment above if using Octave):
# octave --eval "run('$ABSOLUTE_PATH')"
