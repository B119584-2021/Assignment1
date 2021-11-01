#!/bin/bash

cd read_count_files

tail -n +2 collated_read_counts.txt > collated_reads

cat collated_reads | awk '{print ($1)}' > C1-0h
cat collated_reads | awk '{print (($2+1)/($3+1))}' > C1-24h
cat collated_reads | awk '{print (($4+1)/($5+1))}' > C1-48h
cat collated_reads | awk '{print ($6)}' > C2-0h
cat collated_reads | awk '{print (($7+1)/($8+1))}' > C2-24h
cat collated_reads | awk '{print (($9+1)/($10+1))}' > C2-48h
cat collated_reads | awk '{print ($11)}' > WT-0h
cat collated_reads | awk '{print (($12+1)/($13+1))}' > WT-24h
cat collated_reads | awk '{print (($14+1)/($15+1))}' > WT-48h


paste C1-0h C1-24h C1-48h > C1-fold
paste C2-0h C2-24h C2-48h > C2-fold
paste WT-0h WT-24h WT-48h > WT-fold

rm -f C1-0h C1-24h C1-48h C2-0h C2-24h C2-48h WT-0h WT-24h WT-48h collated_reads

awk -F "\t" '
BEGIN { printf "%-6s %-10s %-10s\n","C1_0h", "C1_24h_In/C1_24h_Un", "C1_48h_In/C1_48h_Un" }
{ printf "%5.2f %20.2f %19.2f\n", $1, $2, $3 } ' C1-fold > C1-fold-ch

awk -F "\t" '
BEGIN { printf "%-6s %-10s %-10s\n","C2_0h", "C2_24h_In/C2_24h_Un", "C2_48h_In/C2_48h_Un" }
{ printf "%5.2f %20.2f %19.2f\n", $1, $2, $3 } ' C2-fold > C2-fold-ch

awk -F "\t" '
BEGIN { printf "%-6s %-10s %-10s\n","WT_0h", "WT_24h_In/WT_24h_Un", "WT_48h_In/WT_48h_Un" }
{ printf "%5.2f %20.2f %19.2f\n", $1, $2, $3 } ' WT-fold > WT-fold-ch

awk -F "\t" '
BEGIN { printf "%-25s %-10s\n", "Gene_Name", "Gene_Info" }
{ printf "%-25s %-10s\n", $4, $5 } ' /localdisk/data/BPSM/AY21/TriTrypDB-46_TcongolenseIL3000_2019.bed > gene_info


paste C1-fold-ch C2-fold-ch WT-fold-ch gene_info > fold-changes.txt


rm -f C1-fold C2-fold WT-fold gene_info C1-fold-ch C2-fold-ch WT-fold-ch

cd ..
