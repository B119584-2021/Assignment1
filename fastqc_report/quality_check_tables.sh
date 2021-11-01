#!/bin/bash
#This script aims to unzip the files and extract information from the fastqc_data.txt file

#Change directory to fastqc reports

#assign values to FILES
FILES="*.zip"

#unzip the files in quality_check
for FILE in $FILES ;
  do unzip -q $FILE 
    echo "$FILE has been unzipped" 
done

#remove the zipped files 
for FILE in $FILES ;
  do rm -f $FILE
done

SUM="*fastqc/summary.txt"

for sum in $SUM ; do
cat $sum | grep "FAIL" >> fail_warnings.txt
done

GC="*fastqc/fastqc_data.txt"

for gc in $GC ; do 
cat $gc | grep "%GC" > GC
cat $gc | grep "Filename" > filename
paste filename GC >> GC_content.txt
done
