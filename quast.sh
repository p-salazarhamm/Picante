#!/bin/bash

contigs=131232_hk_spades/contigs.fasta
reference=reference/Choclo_GCA_002819265.1_588L.fasta
R1=fastqs/131232_hk_S6_L001_R1_001.fastq.gz
R2=fastqs/131232_hk_S6_L001_R2_001.fastq.gz

~/repo/quast/bin/quast.py ${contigs} -r ${ref} -1 ${R1} -2 ${R2} -o quast
