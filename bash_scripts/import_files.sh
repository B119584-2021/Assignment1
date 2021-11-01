x#!/bin/bash
# This script is used to import the files needed for the pipeline. 

# Make a directory to hold the input sequences 
mkdir input_seq

# Confirm that directory has been made 
FILE=./input_seq
if [ -d "$FILE" ]; then
	echo "$FILE directory created"
fi

# Copy the input sequences for T congolense 
cp /localdisk/data/BPSM/AY21/fastq/* ./input_seq

# Move sample details out of sequence data folder
mv input_seq/100k.fqfiles .

# Confirm that all files are present and match
diff /localdisk/data/BPSM/AY21/fastq/ input_seq/ -q

echo "Sample details present in homespace"

echo "All sequence files succesfully imported to input_seq"

#$ -o import_files.o
#$ -e import_files.e


