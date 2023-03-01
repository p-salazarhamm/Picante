#! /usr/bin/bash

#SBATCH --job-name=nf_metagenome
#SBATCH --output=meta-%j.out
#SBATCH --error=meta-%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=bigmem-1TB

#https://github.com/nf-core/mag

module load singularity 

nextflow run nf-core/mag -profile singularity \
  -c nextflow.config \
  --input 'fastqs/*_R{1,2}_001.fastq.gz'
  --kraken2_db "/carc/scratch/projects/ddomman2016191/kraken2_databases/k2_pluspf_20220908.tar.gz" \
  --busco_auto_lineage_prok \
  --max_memory '400.GB' \
  --keep_phix \
  -resume \
  --outdir results \
  --skip_spades
