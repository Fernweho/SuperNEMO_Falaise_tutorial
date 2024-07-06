#!/bin/bash

# Define the main data folder and summary log file
DATA_FOLDER="/sps/nemo/scratch/ktrofimi/Attempt/data_folder"


# Prompt user for the name of the simulation folder
echo "Enter the name of the simulation folder:"
read USER_FOLDNAME

SUMMARY_LOG="$DATA_FOLDER/$USER_FOLDNAME/FINAL_LOG.txt"

# Clear the summary log file if it exists, or create it if it doesn't
> $SUMMARY_LOG

# Check if the simulation folder exists
if [ ! -d "$DATA_FOLDER/$USER_FOLDNAME" ]; then
    echo "Simulation folder $DATA_FOLDER/$USER_FOLDNAME does not exist."
    exit 1
fi

# Prompt user for the number of files
echo "Enter the number of files:"
read FILES

for (( f=0; f < $FILES; f++  )) # iterate over number of files 
do
    ./Analyze_total $DATA_FOLDER/$USER_FOLDNAME/$f/sensitivity.root
done