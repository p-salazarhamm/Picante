#!/bin/bash

#SBATCH --partition=condo
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBARCH --cpus-per-task=16
#SBATCH --time=16:00:00
#SBATCH --job-name=merge_bam

module load samtools

#Merge multiple sorted alignment files
samtools merge -o 210056_andes_merged.bam 210056-1_andes_sort_pairedmapped.bam 210056-2_andes_sort_mapped.bam 
