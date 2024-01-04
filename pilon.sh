#!/bin/bash

#SBATCH --partion=condo
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=4:00:00
#SBATCH --job-name=pilon

module load pilon
#pilon v.1.22

#must index BAM file
#module samtools load
#samtools index *mapped2denovo.bam

sample=(264422 \
  	264424 \
	264438 \
	264441 \
	264443 \
	264444)

for s in ${sample[@]}; do
pilon --genome ${s}_CHOV.fasta --frags ${s}_mapped2denovo.bam --outdir pilon.${s} --vcf --changes
done
