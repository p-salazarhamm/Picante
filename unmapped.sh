#!/bin/bash

#SBATCH --partition=condo
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBARCH --cpus-per-task=16
#SBATCH --time=48:00:00
#SBATCH --job-name=unmapped_pe

module load samtools

array=(TR115-Lung.sam \
	TR79-Heart.sam \
	TR79-Liver.sam \
	TR71-Lung.sam \
	TR71-Heart.sam \
	XP13-Lung.sam )

#Read unmapped and paired

for f in ${array[@]}; do
	base=$(echo $f | sed 's/.sam//')	
	bam=$(echo $f | sed 's/.sam/_unmapped_pe.bam/')	
samtools view -f 4 -f 8 -h ${f} |
	samtools view -S -b > ${bam} 
done
