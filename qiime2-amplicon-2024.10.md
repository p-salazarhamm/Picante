# QIIME2-amplicon-2024.10

## Install
conda env create -n qiime2-amplicon-2024.10 \
  --file https://data.qiime2.org/distro/amplicon/qiime2-amplicon-2024.10-py310-linux-conda.yml

## Activate qiime2 conda environment
conda activate qiime2-amplicon-2024.10

## Import demultiplexed paired-end data
##### Demultiplexing and adaptor trimming was performed on the MiSeq by MRDNA
##### manifest is a tab separated three-column file (.tsv) with headers: sample-id, forward-absolute-filepath, and reverse-absolute-filepath
##### demux_seqs is a directory of demultiplexed sequences
##### both commands produce the same output
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path  demux_seqs \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path demux-pe.qza

qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path manifest \
  --input-format PairedEndFastqManifestPhred33V2 \
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

