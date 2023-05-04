#!/bin/bash

#SBATCH --partition=condo
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBARCH --cpus-per-task=16
#SBATCH --time=48:00:00
#SBATCH --job-name=stats

module load samtools

#Panama samples
array=(130125spln.bam \
	130130.bam \
	131106hk.bam \
	131232.bam \
	131240.bam \
	131269hk.bam \
	131394.bam \
	131453lung.bam \
	327538.bam \
	327556liv.bam)

for f in ${array[@]}; do
	base=$(echo $f | sed 's/.bam//')	
samtools stats ${f} > ${base}.stats
done
