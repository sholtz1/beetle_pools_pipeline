#!/bin/bash
# This script will convert the .sort.bam files to .mpileup files for each population
#	and move the mpileup files to a separate directory


#SBATCH --account=beetlegenes
#SBATCH --time=120:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=1
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sholtz1@uwyo.edu
#SBATCH --job-name=mpileup


module load swset/2018.05
module load gcc/7.3.0
module load trimmomatic/0.36
module load bwa/0.7.17
module load samtools/1.9

cd /project/beetlegenes/sholtz1/beetle_test/CleanBam



InFiles=($( find *sort.bam ))
NumFiles=${#InFiles[@]}

for (( i=0; i<${NumFiles}; i++));
do
temp1=${InFiles[$i]%%.*}
temp2=${temp1//_R1_001/.mpileup}
samtools mpileup ${InFiles[$i]} > /project/beetlegenes/sholtz1/beetle_test/Piled/$temp2
done
