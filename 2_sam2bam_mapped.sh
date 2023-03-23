#!/bin/bash

#SBATCH --partition=condo
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBARCH --cpus-per-task=16
#SBATCH --time=48:00:00
#SBATCH --job-name=sam2bam_mapped

module load samtools

array=(TR115-Lung.sam \
	TR79-Heart.sam \
	TR79-Liver.sam \
	TR71-Lung.sam \
	TR71-Heart.sam \
	XP13-Lung.sam )

#Read mapped in proper pairs

for f in ${array[@]}; do
	base=$(echo $f | sed 's/.sam//')	
	bam=$(echo $f | sed 's/.sam/_paired_mapped.bam/')	
samtools view -f 2 -h ${f} |
	samtools view -S -b > ${bam} 
done
