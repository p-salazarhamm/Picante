# QIIME2-amplicon-2024.10

## Install
conda env create -n qiime2-amplicon-2024.10 \
  --file https://data.qiime2.org/distro/amplicon/qiime2-amplicon-2024.10-py310-linux-conda.yml

## Activate qiime2 conda environment
conda activate qiime2-amplicon-2024.10

## Import demultiplexed paired-end data
##### manifest is a tab separated three-column file (.tsv) with headers: sample-id, forward-absolute-filepath, and reverse-absolute-filepath
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path manifest \
  --input-format PairedEndFastqManifestPhred33V2 \
  --output-path demux-paired-end.qza
### Visualize demultiplexed paired-end data
  qiime demux summarize --i-data demux-paired-end.qza --o-visualization demux.qzv
