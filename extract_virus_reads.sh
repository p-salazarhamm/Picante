#!/bin/bash

#SBATCH --partition=condo
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBARCH --cpus-per-task=4
#SBATCH --output=kraken_virus%j.out
#SBATCH --error=kraken_virus%j.err
#SBATCH --job-name=krakentools

kraken=/carc/scratch/projects/ddomman2016191/PICANTE/Panama_Hanta/results/Taxonomy/kraken2
fastq=/carc/scratch/projects/ddomman2016191/PICANTE/fastqs/Panama_387048668
virome=/carc/scratch/projects/ddomman2016191/PICANTE/
sample=(130125spln_S8 \
  130130_spln_S2 \
  131106hk_S7 \
  131232_hk_S6 \
  131232_hk_S6 \
  131240_hk_S10 \
  131240_hk_S10 \
  131269hk_S3 \
  131394_lung_S9 \
  131453lung_S5 \
  327538_liv_S1 \
  327556liv_S4 \)

#git clone https://github.com/jenniferlu717/KrakenTools/tree/master#extract_kraken_readspy
for s in ${sample[@]}; do;
python3 ~/repo/KrakenTools/extract_kraken_reads.py -k ${virome}/${s}/kraken2.kraken -s1 ${fastq}/${s}_L001_R1_001.fastq.gz -s2 ${fastq}/${s}_L001_R2_001.fastq.gz -o ${s}_virus_R1.fa -o2 ${s}_virus_R2.fa -t 10239 --include-children -r ${kraken}/${s}/kraken2_report.txt
done
