#!/bin/bash

echo "Starting file movement process..."

# Create destination directory if it doesn't exist
mkdir -p ../json_and_CSV

# Count files before moving (including subdirectories)
csv_count=$(find .. -name "*.csv" -type f | wc -l)
json_count=$(find .. -name "*.json" -type f | wc -l)

echo "Found $csv_count CSV files and $json_count JSON files in all directories"

# Move CSV files from all subdirectories
if [ $csv_count -gt 0 ]; then
    echo "Moving CSV files..."
    find .. -name "*.csv" -type f -exec mv {} ../json_and_CSV/ \;
    echo "Moved $csv_count CSV files to json_and_CSV folder"
else
    echo "No CSV files found"
fi

# Move JSON files from all subdirectories
if [ $json_count -gt 0 ]; then
    echo "Moving JSON files..."
    find .. -name "*.json" -type f -exec mv {} ../json_and_CSV/ \;
    echo "Moved $json_count JSON files to json_and_CSV folder"
else
    echo "No JSON files found"
fi

# Verify files were moved
moved_files=$(ls ../json_and_CSV/ 2>/dev/null | wc -l)
echo ""
echo "File movement completed!"
echo "Total files in json_and_CSV folder: $moved_files"

# List moved files
if [ $moved_files -gt 0 ]; then
    echo "Files moved:"
    ls -la ../json_and_CSV/
fi
