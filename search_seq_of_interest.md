# Steps to search metagenomic assemblies for a sequence of interest

1. Make reference database of sequence of interest

```
makeblastdb -in ${ref} -dbtype nucl -out ${ref}.db
```

2. Blast metagenomic assemblies versus reference

```
blastn -query Assembly/MEGAHIT/${strain}.contigs.fa -max_target_seqs 1 -evalue 1e-10 -outfmt 6 -db ${ref}.db > blastn_${strain}
```

3. Parse blastn output

```
cat blastn_${strain} | cut -f 1,7,8 > coord.${strain}
```

4. Parse the fasta for the blastn contig ranges using [SCGid](https://github.com/amsesk/SCGid)

```
module load miniconda3

source SCGid/scgidenv/bin/activate 

python3 get_these_contig_ranges.py --fasta Assembly/MEGAHIT/${strain}.contigs.fa --coordinates coord.${strain} > ${strain}_${ref}.contigs
```
