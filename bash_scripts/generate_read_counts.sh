#!/bin/bash

#the script filters for the desired requirements (group, time, treatment) 
#fetches read counts from the bedfiles and pastes them into a single file 


#set variable GROUP used to iterate over the three groups 
GROUP=( WT C1 C2 )


#for loop which returns the read counts grouped by replicates for each group, time and treatment 
for group in "${GROUP[@]}" ; do
#print group which the loop is iterating over 
echo $group ; 

	#fetches read counts for replicates grouped by group for 0h
	for element in $(cat /localdisk/data/BPSM/AY21/fastq/100k.fqfiles | grep $group | awk '($4=="0")' | cut -f6) ; do 
	echo $element ; 
	time=(0h) 
	SAMPLE=${element: 0:-7}".bedfile";
	echo $SAMPLE; 
		
		#extract read count from the bedfile of interest	
		for sample in $SAMPLE ; do 
		cat $SAMPLE | cut -f6 > $SAMPLE"_countfile" ;
		done
	done			

	#combines the read counts for the replicates
	paste *countfile > $group"_"$time"_counts"
	
	#remove temporary files 
	rm -f *countfile			

	
	#fetches read counts for replicates grouped for 24h and induced treatment
	for element in $(cat /localdisk/data/BPSM/AY21/fastq/100k.fqfiles | grep $group | awk '($4=="24")' | awk '($5=="Induced")' | cut -f6) ; do
        echo $element ;
        time=(24h)
	t=(Induced)
        SAMPLE=${element: 0:-7}".bedfile";
        echo $SAMPLE;

		#extract read counts from the bedfile of interest
                for sample in $SAMPLE ; do
                cat $SAMPLE | cut -f6 > $SAMPLE"_count24I" ;
                done
        done
	
	#combine read counts for replicates
	paste *count24I > $group"_"$time"_"$t"_counts"

	#remove temporary files 
	rm -f *count24I


	#fetches read counts for replicates grouped for 24h and uninduced treatment  
	for element in $(cat /localdisk/data/BPSM/AY21/fastq/100k.fqfiles | grep $group | awk '($4=="24")' | awk '($5=="Uninduced")' | cut -f6) ; do
        echo $element ;
        time=(24h)
        t=(Uninduced)
        SAMPLE=${element: 0:-7}".bedfile";
        echo $SAMPLE;

		#extract read counts from the bedfile of interest
                for sample in $SAMPLE ; do
                cat $SAMPLE | cut -f6 > $SAMPLE"_count24U" ;
                done
        done

	#combine read counts for replicates
        paste *count24U > $group"_"$time"_"$t"_counts"

	#remove temporary files 
        rm -f *count24U


	#fetches read counts for replicates for 48 hours and induced treatment
	for element in $(cat /localdisk/data/BPSM/AY21/fastq/100k.fqfiles | grep $group | awk '($4=="48")' | awk '($5=="Induced")' | cut -f6) ; do
        echo $element ;
        time=(48h)
        t=(Induced)
        SAMPLE=${element: 0:-7}".bedfile";
        echo $SAMPLE;

		#extract read counts from the bedfile of interest
                for sample in $SAMPLE ; do
                cat $SAMPLE | cut -f6 > $SAMPLE"_count48I" ;
                done
        done

	#combine read counts for replicates
        paste *count48I > $group"_"$time"_"$t"_counts"
        
	#remove temporary files 
	rm -f *count48I


	#fetches read counts for replicates for 48 hours and uninduced treatment
	for element in $(cat /localdisk/data/BPSM/AY21/fastq/100k.fqfiles | grep $group | awk '($4=="48")' | awk '($5=="Uninduced")' | cut -f6) ; do
        echo $element ;
        time=(48h)
        t=(Uninduced)
        SAMPLE=${element: 0:-7}".bedfile";
        echo $SAMPLE;

		#extract read counts from the bedfile of interest
                for sample in $SAMPLE ; do
                cat $SAMPLE | cut -f6 > $SAMPLE"_count48U" ;
                done
        done
	
	#combine read counts for replicates
        paste *count48U > $group"_"$time"_"$t"_counts"

	#remove temporary files 
        rm -f *count48U

done
