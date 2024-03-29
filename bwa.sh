#!/bin/bash

#SBATCH --job-name=bwa
#SBATCH --output=bwa%j.out
#SBATCH --error=bwa%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --partition=condo

IFS=$'\t'

fastqdir=Picante/fastqs
ref1=Picante/reference_genome/SinNombre_NMR11_GCA_002830985.1_genomic.fasta
ref2=/Picante/reference_genome/GCF_003704035.1_HU_Pman_2.1.3_rna.fna.gz

#1. Merge Sin Nombre Reference NMR11 (L37902-L37904)
# cat *.fasta > Sin_Nombre_NMR11_merged.fasta

#2. Index reference 
# /users/psh102/repo/bwa/bwa index ${ref2}

#3. Map fastqs to reference
while read R1 R2; do
	base=$(echo ${R1} | cut -f 1 -d _ )
	/users/psh102/repo/bwa/bwa mem ${ref2} ${fastqdir}/${R1} ${fastqdir}/${R2} -t 4 > ${base}.sam
done < Picante/reads.txt
