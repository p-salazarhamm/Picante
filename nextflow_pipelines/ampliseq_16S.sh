#!/bin/sh

#SBATCH --time=12:00:00
#SBATCH --job-name=ampliseq
#SBATCH --nodes=2
#SBATCH --mincpus=16
#SBATCH --mem=120G
#SBATCH --partition=condo

#   --FW_primer "AGAGTTTGATCCTGGCTCAG" \
#   --RV_primer "GWATTACCGCGGCKGCTG" \
#   --trunc_qmin #default 25

module load singularity

nextflow run nf-core/ampliseq \
   -profile singularity \
   --input "input.tsv" \
   --metadata "metadata.tsv" \
   --skip_cutadapt \
   --skip_dada_quality \
   --trunclenf 0 \
   --trunclenr 0 \
   --outdir results \
   -resume
