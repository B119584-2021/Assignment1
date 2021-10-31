#!/bin/bash
#This script performs a quality check on the raw sequences using the fastqc tool

#Make a directory to hold the quality check reports
mkdir quality_check

#Change directories to where the input files are 
cd input_seq

#Run FASTQC
FILES="/localdisk/home/data/BPSM/AY21/fastq/*.fq.gz"

for FILE in $FILES
do fastqc $FILE -o ../quality_check -q
  echo "Fastqc analysis complete for $FILE"
done 

# Make a directory to contain the html reports 
mkdir html_reports

# Move the html reports into the html_reports directory  
mv *.html html_reports

#Return to home directory 
cd ../

ls -l input_seq/*.fq.gz | wc | awk -F ' ' ' {print ""$1" were analysed by fastqc analysis"}'

ls -l quality_check/*.zip | wc | awk -F ' ' ' {print ""$1" zip files were generated from fastqc analysis"}'

ls -l quality_check/*.html | wc | awk -F ' ' ' {print ""$1" html files were generated from fastqc analysis"}'

#$ -o quality_check.o
#$ -e quality_check.e

