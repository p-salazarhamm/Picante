#!/bin/bash

#SBATCH --partition=normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBARCH --cpus-per-task=12
#SBATCH --mem-per-cpu=20G
#SBATCH --time=48:00:00
#SBATCH --job-name=spades

module load gcc/11.2.0-otgt
module load spades/3.15.3-h6sh

spades.py --pe1-1 TR115-Lung_mapped_paired_R1.fq --pe1-2 TR115-Lung_mapped_paired_R2.fq --pe2-1 TR71-Lung_mapped_paired_R1.fq --pe2-2 TR71-Lung_mapped_paired_R2.fq --pe3-1 TR79-Liver_mapped_paired_R1.fq --pe3-2 TR79-Liver_mapped_paired_R2.fq --trusted-contigs reference_genome/Sin_Nombre_NMR11_merged.fasta --isolate -o co_asm_spades -t 12 -m 240
