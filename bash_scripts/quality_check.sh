#!/bin/bash

#This script performs a quality check on the raw sequences using the fastqc tool

#Make a directory to hold the quality check reports
mkdir fastqc_report

#set variable containing .fq.gz files to be analysed
FILES="/localdisk/home/data/BPSM/AY21/fastq/*.fq.gz"

for FILE in $FILES ; do
fastqc $FILE -o fastqc_report -q
echo "Fastqc analysis complete for ${FILE: 37:}"
done 

# Make a directory to contain the html reports inside quality_check
mkdir fastqc_report/html_reports

# Move the html reports into the html_reports directory  
mv fastqc_report/*.html fastqc_report/html_reports


ls -l /localdisk/home/data/BPSM/AY21/fastq/*.fq.gz | wc | awk -F ' ' ' {print ""$1" were analysed by fastqc analysis"}'

ls -l fastqc_report/*.zip | wc | awk -F ' ' ' {print ""$1" zip files were generated from fastqc analysis"}'

ls -l fastqc_report/*.html | wc | awk -F ' ' ' {print ""$1" html files were generated from fastqc analysis"}'



#assign values to FILES
SAMPLE="*.zip"

#unzip the files in quality_check
for sample in $SAMPLE ; do 
  unzip -q $sample
  echo "$sample has been unzipped"
  #remove zipped files 
  rm -f $sample
done

SUM="*fastqc/summary.txt"

for sum in $SUM ; do
cat $sum | grep "FAIL" >> fail_warnings.txt
done

