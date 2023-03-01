#!/bin/bash

#SBATCH --job-name=bwa
#SBATCH --output=bwa%j.out
#SBATCH --error=bwa%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --partition=condo

IFS=$'\t'

fastqdir=/carc/scratch/projects/ddomman2016191/Picante/fastqs
ref=/carc/scratch/projects/ddomman2016191/Picante/reference_genome/Sin_Nombre_NMR11_merged.fasta

# Merge Sin Nombre Reference NMR11 (L37902-L37904)
cat *.fasta > Sin_Nombre_NMR11_merged.fasta

# Index reference 
/users/psh102/repo/bwa/bwa index ${ref}

# Map fastqs to reference
while read R1 R2; do
	base=$(echo ${R1} | cut -f 1 -d _ )
	/users/psh102/repo/bwa/bwa mem ${ref} ${fastqdir}/${R1} ${fastqdir}/${R2} -t 4 > ${base}.sam
done < /carc/scratch/projects/ddomman2016191/Picante/reads.txt
