#!/bin/bash

#SBATCH --partition=condo
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=48:00:00
#SBATCH --job-name=nf_viralrecon

module load singularity
#use nextflow_hopper.config

nextflow run nf-core/viralrecon \
	--input reads.csv \
	-c nextflow.config \
	--outdir SARS-Cov2 \
	--platform illumina \
	--protocol metagenomic \
	--genome 'MN908947.3' \
	-profile singularity \
	-resume
# --kraken2_db '/carc/scratch/projects/ddomman2016191/kraken2_databases/k2_pluspf_20220908'
# --skip_pangolin 
# --skip_nextclade
