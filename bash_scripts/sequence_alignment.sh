#!/bin/bash

#this script aims to align read pairs to bowtie2

#make a directory to hold the aligned reads
mkdir aligned_reads

#confirm that directory has been made
FILE=./aligned_reads
if [ -d "$FILE" ]; then
        echo "$FILE directory created"
fi


#move into new directory 
cd aligned_reads

# Build indices needed for bowtie2 alignment
bowtie2-build /localdisk/data/BPSM/AY21/Tcongo_genome/TriTrypDB-46_TcongolenseIL3000_2019_Genome.fasta.gz Tcongo --quiet


#set variable to select the first input file for bowtie2 alignment
FIRST="/localdisk/data/BPSM/AY21/fastq/*_1.fq.gz"

#Perform bowtie2 alignment 
for first in $FIRST ; do
  #set the second variable for pair end alignment
  SECOND="${first: 0:-8}_2.fq.gz"
  
  #perform alignment
  bowtie2 -x Tcongo -q -1 $first -2 $SECOND --local  > ${SECOND: 32:-8}pair.bam
  
  #echo the sample pair that was aligned
  echo ${first: 32:-8} "paired-end sequences are aligned"
done


#set bam files produced from bowtie2 as variable
BAM="*pair.bam"

#sort the files so that alignments occur in genome order
for bam in $BAM ; do 
  samtools sort $bam > ${bam: 0:-8}.bam
done  

                 ### gives ambigious redirect warning - if > used###
                 ### output printed to screen if -o used ###

#remove temporary files
rm -f *pair.bam


#set sorted bam files as variable for indexing
SORTED="*.bam"

#create indexed files to extract overlapping alignments
for sorted in $SORTED ; do 
  samtools index $sorted 
done


#set variable for bedtools multicov
BAM="*.bam"

#Perform bedtools
for bam in $BAM ; do
  bedtools multicov -bams $bam -bed /localdisk/data/BPSM/AY21/TriTrypDB-46_TcongolenseIL3000_2019.bed > ${bam: 0:-4}.bedfile
done

#move back up to the working directory 
cd ..


