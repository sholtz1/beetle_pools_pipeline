#!/bin/bash
# A simple script to process the DNA sequence files and convert them to .sort files
#SBATCH --account=beetlegenes
#SBATCH --time=120:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=1
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sholtz1@uwyo.edu
#SBATCH --job-name=pika_radtags



module load swset/2018.05
module load gcc/7.3.0
module load trimmomatic/0.36
module load bwa/0.7.17
module load samtools/1.9

Forward=($( find *_R1_* ))
Backward=($( find *_R2_* ))
NumFiles=${#Forward[@]}

for (( i=0; i<${NumFiles}; i++));
do

# Trim the reads
# Trim the reads
trimmomatic PE -phred33 Pooled_samples/${Forward[$i]} Pooled_samples/${Backward[$i]} TestFiles/${Forward[$i]}_forward_paired.fq.gz TestFiles/${Forward[$i]}_forward_unpaired.fq.gz TestFiles/${Backward[$i]}_reverse_paired.fq.gz TestFiles/${Backward[$i]}_reverse_unpaired.fq.gz ILLUMINACLIP:NexteraPE-PE.fa:2:30:10 LEADING:20 TRAILING:20 SLIDINGWINDOW:4:15 MINLEN:100

# Align both the forward and backward reads to the reference genome
# Align both the forward and backward reads to the reference genome
bwa mem -t 30 Tribolium_ref_2020.fna  TestFiles/${Forward[$i]}_forward_paired.fq.gz TestFiles/${Backward[$i]}_reverse_paired.fq.gz > TestFiles/${Forward[$i]}.sam

# Sort it to make it a .sort file
# Sort it to make it a .sort file
samtools view -q 20 -b -S TestFiles/${Forward[$i]}.sam > TestFiles/${Forward[$i]}.temp.sam
samtools sort -o TestFiles/${Forward[$i]}.sort TestFiles/${Forward[$i]}.temp.sam

done
