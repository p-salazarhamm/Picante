# QIIME2-amplicon-2024.10
#### For more information (https://docs.qiime2.org/2024.10/tutorials/overview/)

## Install
conda env create -n qiime2-amplicon-2024.10 \
  --file https://data.qiime2.org/distro/amplicon/qiime2-amplicon-2024.10-py310-linux-conda.yml

## Activate qiime2 conda environment
conda activate qiime2-amplicon-2024.10

## Import demultiplexed paired-end data
##### Demultiplexing and adaptor trimming was performed on the MiSeq by MRDNA
##### manifest is a tab separated three-column file (.tsv) with headers: sample-id, forward-absolute-filepath, and reverse-absolute-filepath
##### demux_seqs is a directory of demultiplexed sequences
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path  demux_seqs \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path demux-pe.qza
  
### Visualize demultiplexed paired-end data (https://view.qiime2.org/)
  qiime demux summarize \
  --i-data demux-pe.qza \
  --o-visualization demux.qzv

## Trim primers
##### ITS2 rRNA region was amplified with the ITS3F and ITS4R primers
  qiime cutadapt trim-paired \
  --i-demultiplexed-sequences demux-paired-end.qza \
  --p-front-f GCATCGATGAAGAACGCAGC \
  --p-front-r TCCTCCGCTTATTGATATGC \
  --o-trimmed-sequences demux-pe-trimmed.qza

### Visualize demultiplexed trimmed paired-end data (https://view.qiime2.org/)
  qiime demux summarize \
  --i-data demux-pe-trimmed.qza \
  --o-visualization demux-trimmed.qzv

## Denoise with DADA2
module load miniconda3

source activate /users/psh102/repo/miniconda3/envs/qiime2-amplicon-2024.10
  
  qiime dada2 denoise-paired \
	--i-demultiplexed-seqs demux-pe-trimmed.qza \
	--p-trim-left-f 0 \
	--p-trim-left-r 0 \
	--p-trunc-len-f 210 \
	--p-trunc-len-r 210 \
 	--p-n-threads 8 \
	--o-table table.qza \
	--o-representative-sequences rep-seqs.qza \
	--o-denoising-stats denoising-stats.qza

 ### Tabulate denoise stats and confirm valid data remained through visualizations (https://view.qiime2.org/)
 qiime metadata tabulate \
  --m-input-file denoising-stats.qza \
  --o-visualization denoising-stats.qzv

 qiime feature-table tabulate-seqs \
  --i-data rep-seqs.qza \
  --o-visualization rep-seqs.qzv

 qiime feature-table summarize \
  --i-table table.qza \
  --o-visualization table.qzv \
  --m-sample-metadata-file sample-metadata.tsv

  ### Output as ASV table
 qiime tools export 
  --input-path table.qza 
  --output-path exported-feature-table
  
 biom convert -i exported-feature-table/feature-table.biom 
  -o exported-feature-table/feature-table.txt --to-tsv
