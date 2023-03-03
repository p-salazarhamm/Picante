#!/bin/bash

#SBATCH --partition=condo
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBARCH --cpus-per-task=16
#SBATCH --time=48:00:00
#SBATCH --job-name=all_mapped

module load samtools

array=(TR115-Lung.sam \
	TR79-Heart.sam \
	TR79-Liver.sam \
	TR71-Lung.sam \
	TR71-Heart.sam \
	XP13-Lung.sam )

#All reads mapped

for f in ${array[@]}; do
	base=$(echo $f | sed 's/.sam//')
samtools view -F 4 -h ${f} > ${base}_mapped.bam
done
