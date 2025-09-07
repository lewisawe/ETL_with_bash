#!/bin/bash

# Environment variable for CSV URL
export CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"

# EXTRACT: Download CSV file to raw folder
echo "Step 1: EXTRACT - Downloading CSV file..."

# Create raw directory if it doesn't exist
mkdir -p raw

# Download the CSV file (skip if already exists to save time)
if [ ! -f "raw/annual-enterprise-survey-2023-financial-year-provisional.csv" ]; then
    wget -O raw/annual-enterprise-survey-2023-financial-year-provisional.csv "$CSV_URL"
fi

# Confirm file was saved in raw folder
if [ -f "raw/annual-enterprise-survey-2023-financial-year-provisional.csv" ]; then
    echo "File successfully downloaded to raw folder"
    echo "File size: $(ls -lh raw/annual-enterprise-survey-2023-financial-year-provisional.csv | awk '{print $5}')"
else
    echo "Error: File not found in raw folder"
    exit 1
fi

# TRANSFORM: Rename column and select specific columns
echo "Step 2: TRANSFORM - Processing data"

# Create Transformed directory if it doesn't exist
mkdir -p Transformed

# Use bash for CSV transformation
{
    # Write header with renamed column
    echo "year,Value,Units,variable_code"
    
    # Select columns 1,9,5,6 (Year,Value,Units,Variable_code) and skip header
    tail -n +2 raw/annual-enterprise-survey-2023-financial-year-provisional.csv | cut -d',' -f1,9,5,6
} > Transformed/2023_year_finance.csv

echo "Transformation completed successfully"

# Confirm transformed file was created
if [ -f "Transformed/2023_year_finance.csv" ]; then
    echo "Data transformed and saved to Transformed folder"
    echo "Transformed file size: $(ls -lh Transformed/2023_year_finance.csv | awk '{print $5}')"
    echo "Number of records: $(wc -l < Transformed/2023_year_finance.csv)"
else
    echo "Error: Transformed file not created"
    exit 1
fi

# LOAD: Copy transformed data to Gold directory
echo ""
echo "Step 3: LOAD - Loading data to Gold directory..."

# Create Gold directory if it doesn't exist
mkdir -p Gold

# Copy the transformed file to Gold directory
cp Transformed/2023_year_finance.csv Gold/

# Confirm file was loaded into Gold folder
if [ -f "Gold/2023_year_finance.csv" ]; then
    echo "Data successfully loaded to Gold folder"
    echo "Final file size: $(ls -lh Gold/2023_year_finance.csv | awk '{print $5}')"
else
    echo "Error: File not found in Gold folder"
    exit 1
fi

echo ""
echo "ETL Process completed successfully!"
echo "Files created:"
echo "- raw/annual-enterprise-survey-2023-financial-year-provisional.csv"
echo "- Transformed/2023_year_finance.csv" 
echo "- Gold/2023_year_finance.csv"
