#!/bin/bash

#SBATCH --partition=condo
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=48:00:00
#SBATCH --job-name=viralrecon_choclo

module load singularity

#Andes_GCF_000850405.1_Chile-9717869.fasta (Andes virus)
#Choclo_GCA_002819265.1_588L.fasta (Choclo virus)
#Seoul_GCF_000855645.1_80-39.fasta (Seoul virus)

nextflow run nf-core/viralrecon \
	--input /carc/scratch/projects/ddomman2016306/Target_capture/scripts/reads.csv\
	-c /carc/scratch/projects/ddomman2016306/Target_capture/scripts/nextflow.config \
	--outdir Choclo_viralrecon \
	--platform illumina \
	--protocol metagenomic \
	--fasta /carc/scratch/projects/ddomman2016191/PICANTE/Panama_Hanta/reference/Choclo_GCA_002819265.1_588L.fasta \
	--skip_pangolin \
	--skip_nextclade \
	--skip_abacas \
  --skip_plasmidid \
	-profile singularity \
	-resume
