#!/bin/bash
# This script aims to align read pairs to bowtie2

# Make a directory to hold the aligned reads
mkdir aligned_reads

# Confirm that directory has been made
FILE=./aligned_reads
if [ -d "$FILE" ]; then
        echo "$FILE directory created"
fi


cd aligned_reads

# Build indices needed for bowtie alignment
bowtie2-build /localdisk/data/BPSM/AY21/Tcongo_genome/TriTrypDB-46_TcongolenseIL3000_2019_Genome.fasta.gz Tcongo --quiet


#set variable to select input files for bowtie2 alignment
FIRST="/localdisk/data/BPSM/AY21/fastq/*_1.fq.gz"

#Perform bowtie2 alignment 
for first in $FIRST ;
do
  SECOND="${first: 0:-8}_2.fq.gz"
  bowtie2 -x Tcongo -1 $first -2 $SECOND  > ${SECOND: 32:-7}pair.bam
       echo ${first: 32:-8} "paired-end sequences are aligned"
done



BAM="*pair.bam"

# Sort the files so that alignments occur in genome order
for bam in $BAM;
  do samtools sort $bam -o ${bam: 0:-8}.bam
done  

                 ### gives ambigious redirect warning - if > used###
                 ### output printed to screen if -o used ###

rm -f *pair.bam


SORTED="*.bam"

# Create indexed files to extract overlapping alignments
for sorted in $SORTED;
  do samtools index $sorted 
done


#set variable for bedtools multicov
BAM="*.bam"

#Perform bedtools
for bam in $BAM ;
do
  bedtools multicov -bams $bam -bed /localdisk/data/BPSM/AY21/TriTrypDB-46_TcongolenseIL3000_2019.bed > ${bam: 0:-4}.bedfile
done


cd ..

#$ -o quality_check.o
#$ -e quality_check.e

