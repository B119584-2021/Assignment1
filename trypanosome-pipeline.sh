#!/bin/bash

#This script aims to take pair-ended raw sequences and output fastqc summary 
#statistics and read count statistics for aligned sequences.


#source script which takes the raw sequences and performs a fastqc analysis
#	source bash_scripts/quality_check.sh


#source script which aligns raw sequences and sorts them into bedfiles

	source bash_scripts/sequence_alignment.sh


#source script which takes the read counts from the bedfiles and generates 
#read count files containing means

	source bash_scripts/generate_read_counts.sh


#source script to generate fold change data

	source bash_scripts/fold_change.sh
