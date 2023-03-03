
#all reads mapped
samtools view -F 4 -h ${f} > ${base}_mapped.bam
