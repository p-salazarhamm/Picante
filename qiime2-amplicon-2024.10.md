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

  ## Filtering feature table
  
  ### Remove redundant ASV with 100% percent identity
  ##### Some rep-seqs with 100% similarity have different length and will all exist in asv-table and rep-seq
  
qiime vsearch cluster-features-de-novo \
  --i-table table.qza \
  --i-sequences rep-seqs.qza \
  --p-perc-identity 1 \
  --o-clustered-table table-asv100.qza 
  --o-clustered-sequences rep-seqs-asv100.qza
  
  ### Total-frequency-based filtering (total abundance < 10)
  
qiime feature-table filter-features \
  --i-table table-asv100.qza \
  --p-min-frequency 10 \
  --o-filtered-table filtered-table-abu10-asv100.qza

  ### Contingency-based filtering (total samples < 2)
qiime feature-table filter-features \
  --i-table filtered-table-abu10-asv100.qza \
  --p-min-samples 2 \
  --o-filtered-table filtered-table-abu10-asv100-minsam2.qza

  ### Visualize
qiime feature-table summarize \
  --i-table filtered-table-abu10-asv100-minsam2.qza \
  --o-visualization filtered-table-abu10-asv100-minsam2.qzv \
  --m-sample-metadata-file sample-metadata.tsv

  ### Output as ASV table (filtered table)
qiime tools export \
  --input-path filtered-table-abu10-asv100-minsam2.qza \
  --output-path exported-feature-table
  
biom convert \
  -i exported-feature-table/feature-table.biom \
  -o expored-feature-table/feature-table.tsv \
  --to-tsv

  ## Filtering sequences
  #### Download sequences.fasta from rep-seqs.qzv
  #### Use seqmagick to filter sequences (https://seqmagick.readthedocs.io/en/latest/)
  #### Filter-seqs is an alternative to seqmagick (see below)
  
cat filtered-feature-table/feature-table.tsv | cut -f 1 > list_filt_rep_seq
  
conda activate seqmagick

seqmagick convert sequences.fasta filtered-abu10-asv100-minsam2-rep-sequences.fasta --include-from-file list_filt_rep_seq 

## Taxonomy Assignment 
  #### UNITE QIIME release for eukaryotes 2025-02-19 (DOI: 10.15156/BIO/3301242)
  #### SHs resulting from clustering at the 1% distance (99% similarity)
  #### Pre-trained database (unite_ver10_99_all_19.02.2025-Q2-2024.10.qza) found at https://github.com/colinbrislawn/unite-train/releases/tag/v10.0-2025-02-19-qiime2-2024.10

#--p-confidence: 0.7 (default)

qiime feature-classifier classify-sklearn \
  --i-classifier unite_ver10_99_all_19.02.2025-Q2-2024.10.qza \
  --i-reads rep-seqs-asv100.qza \
  --o-classification taxonomy-rep-reqs-asv100.qza \
  --p-confidence 0.9

### Visulization
qiime metadata tabulate \
 --m-input-file taxonomy-rep-reqs-asv100.qza \
 --o-visualization taxonomy-rep-reqs-asv100.qzv

qiime taxa barplot \
 --i-table filtered-table-abu10-asv100-minsam2.qza \
 --i-taxonomy taxonomy-rep-reqs-asv100.qza \
 --m-metadata-file sample-metadata.tsv \
 --o-visualization filtered-abu10-asv100-minsam2-rep-sequences-bar-plots.qzv

### Filtering 
qiime taxa filter-table \
 --i-table filtered-table-abu10-asv100-minsam2.qza \
 --i-taxonomy taxonomy-rep-seqs-asv100.qza \
 --p-inlcude k__Fungi \
 --o-filtered-table filtered-table-abu10-asv100-minsam2-Fungi.qza

#### View barplot as above to confirm only Fungi were retained (see above visualization)
#### Filter-seqs is an alternative to seqmagick if you want to use qiime artifacts

qiime feature-table filter-seqs \
 --i-data rep-seqs-asv100.qza \
 --i-table filtered-table-abu10-asv100-minsam2-Fungi.qza \
 --o-filtered-data rep-seqs-asv100-abu10-minsam2-Fungi.qza

## Export files for R

### Export OTU table
qiime tools export \
  --input-path filtered-table-abu10-asv100-minsam2-Fungi.qza \
  --output-path filtered-table-abu10-asv100-minsam2-Fungi

### Convert OTU table biom to tsv
biom convert \
  -i filtered-table-abu10-asv100-minsam2-Fungi/feature-table.biom \
  -o filtered-table-abu10-asv100-minsam2-Fungi.tsv \
  --to-tsv

### Export filtered taxonomy
qiime tools export \
  --input-path ctaxonomy-rep-reqs-asv100.qza \
  --output-path taxonomy-rep-reqs-asv100
 
## Visualizations in QIIME2
 
### Phylogenetic tree
 qiime phylogeny align-to-tree-mafft-fasttree \
 --i-sequences rep-seqs-asv100-abu10-minsam2-Fungi.qza \
 --o-alignment aligned-rep-seqs-asv100-abu10-minsam2-Fungi.qza \
 --o-masked-alignment masked-aligned-rep-seqs-asv100-abu10-minsam2-Fungi.qza \
 --o-tree unrooted-tree-rep-seqs-asv100-abu10-minsam2-Fungi.qza \
 --o-rooted-tree rooted-tree-rep-seqs-asv100-abu10-minsam2-Fungi.qza
 
### Diversity analyses
 #### Based on table.qzv, make sampling depth as high as possible (so you retain more sequences per sample) while excluding as few samples as possible
 qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree-rep-seqs-asv100-abu10-minsam2-Fungi.qza \
  --i-table filtered-table-abu10-asv100-minsam2-Fungi.qza \
  --p-sampling-depth 1381 \
  --m-metadata-file sample-metadata.tsv \
  --output-dir core-metrics-results

  ### Alpha diversity ## HERE

  qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization core-metrics-results/faith-pd-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/evenness_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization core-metrics-results/evenness-group-significance.qzv
 
______________________
### Make a classifier 
qiime tools import \
  --type 'FeatureData[Sequence]' \
  --input-path sh_refs_qiime_ver10_99_19.02.2025.fasta \
  --output-path sh_refs_qiime_ver10_99_19.02.2025.qza	
  
qiime tools import 
  --type 'FeatureData[Taxonomy]' \
  --input-format HeaderlessTSVTaxonomyFormat \
  --input-path sh_taxonomy_qiime_ver10_99_19.02.2025.txt \
  --output-path sh_taxonomy_qiime_ver10_99_19.02.2025.qza

qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads sh_refs_qiime_ver10_99_19.02.2025.qza \
  --i-reference-taxonomy sh_taxonomy_qiime_ver10_99_19.02.2025.qza \
  --o-classifier sh_classifier_qiime_ver10_99_19.02.2025.qza
  
