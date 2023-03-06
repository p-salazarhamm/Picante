#!/bin/bash

#SBATCH --partition=condo
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBARCH --cpus-per-task=16
#SBATCH --time=8:00:00
#SBATCH --job-name=depth

module load samtools

array=(TR115-Lung_mapped.sam \
	TR79-Heart_mapped.sam \
	TR79-Liver_mapped.sam \
	TR71-Lung_mapped.sam \
	TR71-Heart_mapped.sam \
	XP13-Lung_mapped.sam)

#All reads mapped

for f in ${array[@]}; do
	base=$(echo $f | sed 's/.sam//')
samtools depth -a ${f} -o ${base}_mapped.depth
done
