#!/bin/bash
# A simple script to process the DNA sequence files and convert them to .sort files

#Load Trimmomatic from Teton
module load swset/2018.05
module load  gcc/7.3.0
module load trimmomatic/0.36


WORKDIRECTORY=/home/topher/RangeExpansionGenetics
REFGENOME=/mnt/md0raid1_2tb/SpatialStructSeqData/short-header-Tribolium_castaneum.fa
Forward=($( find *_R1_* ))
Backward=($( find *_R2_* ))
#Count number of files in a list
NumFiles=${#Forward[@]}
# For loop do it the number of times in the NumFiles list i++ means to add 1 each loop
for (( i=0; i<${NumFiles}; i++));
do

# Trim the reads
java -jar trimmomatic-0.36.jar PE -phred33 ${Forward[$i]} ${Backward[$i]} ProcFiles/${Forward[$i]}_forward_paired.fq.gz ProcFiles/${Forward[$i]}_forward_unpaired.fq.gz ProcFiles/${Backward[$i]}_reverse_paired.fq.gz ProcFiles/${Backward[$i]}_reverse_unpaired.fq.gz ILLUMINACLIP:$WORKDIRECTORY/NexteraPE-PE.fa:2:30:10 LEADING:20 TRAILING:20 SLIDINGWINDOW:4:15 MINLEN:100

# Align both the forward and backward reads to the reference genome
bwa mem -t 10 $REFGENOME ProcFiles/${Forward[$i]}_forward_paired.fq.gz ProcFiles/${Backward[$i]}_reverse_paired.fq.gz > ProcFiles/${Forward[$i]}.sam

# Sort it to make it a .sort file
samtools view -q 20 -b -S ProcFiles/${Forward[$i]}.sam|samtools sort - ProcFiles/${Forward[$i]}.sort

done
