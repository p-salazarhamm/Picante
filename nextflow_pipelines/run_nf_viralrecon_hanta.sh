#!/bin/bash

#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=48:00:00
#SBATCH --job-name=viralrecon_hanta

module load singularity
#use nextflow_hopper.config

nextflow run nf-core/viralrecon \
	--input reads.csv \
	-c nextflow.config \
	--outdir Hanta_viralrecon \
	--platform illumina \
	--protocol metagenomic \
	--fasta reference_genome/SinNombre_NMR11_GCA_002830985.1_genomic.fasta \
	--gff reference_genome/SinNombre_NMR11_GCA_002830985.1.gff \
	--skip_pangolin \
	--skip_nextclade \
	-profile singularity \
	-resume
