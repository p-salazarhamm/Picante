library(tidyverse)

#1 map reads to SEOV and CHOV resulting in two bam files
#2 filter paired mapped reads
#3 bam to fastq
#4 get names of reads
#cat 263231_SEOV_R1.fq | grep ^@ > 263231_SEOV_R1
#cat 263231_CHOV_R1.fq | grep ^@ > 263231_CHOV_R1

setwd("/users/psalazarhamm/Desktop")
SEOV_263231 = read.table("263231_SEOV_R1")
CHOV_263231 = read.table("263231_CHOV_R1")

#Which samples are in SEOV but not CHOV
#grep -v -f 263231_SEOV_R1 263231_CHOV_R1 | wc -l
these_rows = which(!SEOV_263231[,1] %in% CHOV_263231[,1]) 
write.table(x = SEOV_263231[these_rows,1], file = "263231_SEOV_notCHOV_names", row.names = FALSE, quote = FALSE, col.names = FALSE)
