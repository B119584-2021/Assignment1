#!/bin/bash

#the script filters for the desired requirements (group, time, treatment) 
#fetches read counts from the bedfiles and pastes them into a single file 


#set variable GROUP used to iterate over the three groups 
GROUP=( WT C1 C2 )

mkdir read_count_files

cd aligned_reads

#create temporary file containing gene information and names 
cat /localdisk/data/BPSM/AY21/TriTrypDB-46_TcongolenseIL3000_2019.bed | cut -f4- > gene_names


#for loop which returns the read counts grouped by replicates for each group, time and treatment 
for group in "${GROUP[@]}" ; do
#print group which the loop is iterating over 
echo $group 

  #fetches read counts for replicates grouped by group for 0h
  for element in $(cat /localdisk/data/BPSM/AY21/fastq/100k.fqfiles | grep $group | awk '($4=="0")' | cut -f6) ; do 
  time=(0h) 
  SAMPLE=${element: 0:-8}".bedfile"
  echo $SAMPLE
		
      #extract read count from the bedfile of interest	
      for sample in $SAMPLE ; do 
      cat $SAMPLE | cut -f6 > $SAMPLE"_countfile" 
      done

  done			
  
  #combines the read counts for the replicates
  paste *countfile gene_names > $group"_"$time"_counts"
  cp $group"_"$time"_counts" ../read_count_files/$group"_"$time"_counts"
	
  #remove temporary files 
  rm -f *countfile			


  #fetches read counts for replicates grouped for 24h and induced treatment
  for element in $( cat /localdisk/data/BPSM/AY21/fastq/100k.fqfiles | grep $group | awk '( $4=="24" )' | awk '( $5=="Induced" )' | cut -f6 ) ; do
  time=(24h)
  t=(Induced)
  SAMPLE=${element: 0:-8}".bedfile"
  echo $SAMPLE

       #extract read counts from the bedfile of interest
       for sample in $SAMPLE ; do
       cat $SAMPLE | cut -f6 > $SAMPLE"_count24I" 
       done
  
  done
	
  #combine read counts for replicates
  paste *count24I gene_names > $group"_"$time"_"$t"_counts"
  cp $group"_"$time"_"$t"_counts" ../read_count_files/$group"_"$time"_"$t"_counts"

  #remove temporary files 
  rm -f *count24I


  #fetches read counts for replicates grouped for 24h and uninduced treatment  
  for element in $( cat /localdisk/data/BPSM/AY21/fastq/100k.fqfiles | grep $group | awk '( $4=="24" )' | awk '( $5=="Uninduced" )' | cut -f6 ) ; do
  time=(24h)
  t=(Uninduced)
  SAMPLE=${element: 0:-8}".bedfile"
  echo $SAMPLE

      #extract read counts from the bedfile of interest
      for sample in $SAMPLE ; do
      cat $SAMPLE | cut -f6 > $SAMPLE"_count24U" 
      done
      
  done

  #combine read counts for replicates
  paste *count24U gene_names > $group"_"$time"_"$t"_counts"
  cp $group"_"$time"_"$t"_counts" ../read_count_files/$group"_"$time"_"$t"_counts"

  #remove temporary files 
  rm -f *count24U


  #fetches read counts for replicates for 48 hours and induced treatment
  for element in $( cat /localdisk/data/BPSM/AY21/fastq/100k.fqfiles | grep $group | awk '( $4=="48" )' | awk '( $5=="Induced" )' | cut -f6 ) ; do
  time=(48h)
  t=(Induced)
  SAMPLE=${element: 0:-8}".bedfile"
  echo $SAMPLE;

      #extract read counts from the bedfile of interest
      for sample in $SAMPLE ; do
      cat $SAMPLE | cut -f6 > $SAMPLE"_count48I" 
      done
       
  done

  #combine read counts for replicates
  paste *count48I gene_names > $group"_"$time"_"$t"_counts"
  cp $group"_"$time"_"$t"_counts" ../read_count_files/$group"_"$time"_"$t"_counts"

  #remove temporary files 
  rm -f *count48I


  #fetches read counts for replicates for 48 hours and uninduced treatment
  for element in $( cat /localdisk/data/BPSM/AY21/fastq/100k.fqfiles | grep $group | awk '( $4=="48" )' | awk '( $5=="Uninduced" )' | cut -f6 ) ; do
  time=(48h)
  t=(Uninduced)
  SAMPLE=${element: 0:-8}".bedfile"
  echo $SAMPLE

      #extract read counts from the bedfile of interest
      for sample in $SAMPLE ; do
      cat $SAMPLE | cut -f6 > $SAMPLE"_count48U" ;
      done
      
  done
	
  #combine read counts for replicates
  paste *count48U gene_names > $group"_"$time"_"$t"_counts"
  cp $group"_"$time"_"$t"_counts" ../read_count_files/$group"_"$time"_"$t"_counts"

  #remove temporary files 
  rm -f *count48U

done


COUNTS="*counts"

for count in $COUNTS ; do
cat $count | awk '{print ($1+$2+$3)/3}' > $count"_mean"
echo $count "mean calculated"
rm -f $count
done


#combine reads for group C1
paste C1_0h_counts_mean C1_24h_Induced_counts_mean C1_24h_Uninduced_counts_mean C1_48h_Induced_counts_mean C1_48h_Uninduced_counts_mean > C1_means

#remove temporary files
rm -f C1_0h_counts_mean C1_24h_Induced_counts_mean C1_24h_Uninduced_counts_mean C1_48h_Induced_counts_mean C1_48h_Uninduced_counts_mean


#combine reads for group C2
paste C2_0h_counts_mean C2_24h_Induced_counts_mean C2_24h_Uninduced_counts_mean C2_48h_Induced_counts_mean C2_48h_Uninduced_counts_mean > C2_means

#remove temporary files
rm -f C2_0h_counts_mean C2_24h_Induced_counts_mean C2_24h_Uninduced_counts_mean C2_48h_Induced_counts_mean C2_48h_Uninduced_counts_mean


#combine reads for group WT
paste WT_0h_counts_mean WT_24h_Induced_counts_mean WT_24h_Uninduced_counts_mean WT_48h_Induced_counts_mean WT_48h_Uninduced_counts_mean > WT_means

#remove temporary files
rm -f WT_0h_counts_mean WT_24h_Induced_counts_mean WT_24h_Uninduced_counts_mean WT_48h_Induced_counts_mean WT_48h_Uninduced_counts_mean



awk -F "\t" '
BEGIN { printf "%-6s %-10s %-10s %-10s %-1s\n","C1_0h", "C1_24h_In", "C1_24h_Un", "C1_48h_In", "C1_48h_Un" }
{ printf "%5.2f %10.2f %10.2f %10.2f %10.2f\n", $1, $2, $3, $4, $5 } ' C1_means > C1_read_counts

awk -F "\t" '
BEGIN { printf "%-6s %-10s %-10s %-10s %-1s\n","C2_0h", "C2_24h_In", "C2_24h_Un", "C2_48h_In", "C2_48h_Un" }
{ printf "%5.2f %10.2f %10.2f %10.2f %10.2f\n", $1, $2, $3, $4, $5 } ' C2_means > C2_read_counts

awk -F "\t" '
BEGIN { printf "%-6s %-10s %-10s %-10s %-1s\n","WT_0h", "WT_24h_In", "WT_24h_Un", "WT_48h_In", "WT_48h_Un" }
{ printf "%5.2f %10.2f %10.2f %10.2f %10.2f\n", $1, $2, $3, $4, $5 } ' WT_means > WT_read_counts

awk -F "\t" '
BEGIN { printf "%-25s %-10s\n", "Gene_Name", "Gene_Info" }
{ printf "%-25s %-10s\n", $4, $5 } ' /localdisk/data/BPSM/AY21/TriTrypDB-46_TcongolenseIL3000_2019.bed > gene_info


#generate mean read counts across replicates for the groups
paste C1_read_counts gene_info > ../read_count_files/C1_mean_read_counts.txt

paste C2_read_counts gene_info > ../read_count_files/C2_mean_read_counts.txt

paste WT_read_counts gene_info > ../read_count_files/WT_mean_read.counts.txt

#generate mean read counts for all groups 
paste C1_read_counts C2_read_counts WT_read_counts gene_info > ../read_count_files/collated_read_counts.txt



#remove temporary files
rm -f gene_names gene_info WT_read_counts C1_read_counts C2_read_counts WT_means C2_means C1_means


cd ..
