#!/bin/bash

#SBATCH --partition=condo
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBARCH --cpus-per-task=16
#SBATCH --time=48:00:00
#SBATCH --job-name=bam2fastq

module load samtools

array=(TR115-Lung.bam \
	TR79-Heart.bam \
	TR79-Liver.bam \
	TR71-Lung.bam \
	TR71-Heart.bam \
	XP13-Lung.bam )

for f in ${array[@]}; do
	base=$(echo $f | sed 's/.bam//')
  samtools fastq -1 ${base}_mapped_R1.fq -2 ${base}_mapped_R2.fq -n ${f}
done
