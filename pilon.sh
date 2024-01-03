#!/bin/bash

#SBATCH --partion=condo
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=4:00:00
#SBATCH --job-name=pilon

module load pilon
#pilon v.1.22

bam_path=/carc/scratch/projects/ddomman2016306/Target_capture/Choclo_viralrecon/variants/bowtie2
ref=/carc/scratch/projects/ddomman2016191/PICANTE/Panama_Hanta/reference/Choclo_GCA_002819265.1_588L.fasta
sample=(264422 \
  264424 \
	264438 \
	264441 \
	264443 \
	264444)

for s in ${sample[@]}; do
pilon --genome ${ref} --frags ${bam_path}/${s}.sorted.bam --outdir pilon.${s} --vcf --changes
done
