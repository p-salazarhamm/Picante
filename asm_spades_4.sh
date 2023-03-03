#!/bin/bash

#SBATCH --partition=normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBARCH --cpus-per-task=12
#SBATCH --mem-per-cpu=20G
#SBATCH --time=48:00:00
#SBATCH --job-name=spades

module load gcc/11.2.0-otgt
module load spades/3.15.3-h6sh

array=(TR115-Lung \
	TR79-Heart \
	TR79-Liver \
	TR71-Lung \
	TR71-Heart \
	XP13-Lung)

for f in ${array[@]}; do
spades.py -1 ${f}_mapped_R1.fq -2 ${f}_mapped_R2.fq --trusted-contigs reference_genome/Sin_Nombre_NMR11_merged.fasta --isolate -o {f}_spades -t 12 -m 240
done
