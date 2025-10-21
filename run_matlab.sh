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

# Run MATLAB in batch mode
# Change 'matlab' to 'octave --eval' if you're using Octave instead
matlab -batch "run('$ABSOLUTE_PATH')"

# Alternative for older MATLAB versions (uncomment if needed):
# matlab -nodisplay -nosplash -nodesktop -r "run('$ABSOLUTE_PATH'); exit;"
