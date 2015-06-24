#!/bin/bash

export MAXEE=0.25
export TRUNCVAL=200
export BIN_DIR="/rsgrps/bhurwitz/hurwitzlab/bin"
export DATA_DIR="/gsfs1/rsgrps/bhurwitz/hurwitzlab/data/jana"
# default value for OTU_RADIUS is 3.0
export OTU_RADIUS="5.0"
export MIN_SIZE="3"

export PROJECT_DIR="/rsgrps/bhurwitz/hurwitzlab/amplicon-illumina/scripts"
#export PROJECT_DIR="${DATA_DIR}"
export SCRIPT_DIR="${PROJECT_DIR}/workers"

export STEP0="00-usearch"
export STEP1="01-bc-filter"
export STEP2="02-demultiplex"
export STEP3="03-dereplicate"
export STEP4="04-sort-discard"
export STEP5="05-otu-cluster"

FOR_IN_READS="${DATA_DIR}/run1_for.fastq"
REV_IN_READS=$(echo ${FOR_IN_READS} | sed 's/_for.fastq/_rev.fastq/')
BASE=$(basename ${FOR_IN_READS} _for.fastq)


# barcode file
export BARCODES="${DATA_DIR}/run1_bc.fastq"

# mapfile necessary for demultiplexing
export MAPFILE="${DATA_DIR}/map1.txt"

# reference databases
export QIIME_REF_DATABASE="${DATA_DIR}/Unite_ITS_database/qiime/sh_refs_qiime_ver7_97_02.03.2015.fasta"
#export QIIME_REF_DATABASE="/uaopt/qiime/1.9.0/lib/python2.7/site-packages/qiime_default_reference/gg_13_8_otus/rep_set/97_otus.fasta"
export MOTHUR_REF_DATABASE="${DATA_DIR}/Unite_ITS_database/mothur/UNITEv6_sh_97.fasta"
export ITS_REF_DATABASE="${DATA_DIR}/fungalITSdatabaseID.fasta"

# taxonomy mappings
export QIIME_TAX_MAP="${DATA_DIR}/Unite_ITS_database/qiime/sh_taxonomy_qiime_ver7_97_02.03.2015.txt"
#export QIIME_TAX_MAP="/uaopt/qiime/1.9.0/lib/python2.7/site-packages/qiime_default_reference/gg_13_8_otus/taxonomy/97_otu_taxonomy.txt"
export MOTHUR_TAX_MAP="${DATA_DIR}/Unite_ITS_database/mothur/UNITEv6_sh_97.tax"

### OUTPUT FILENAMES ###

# output directories for forward and reverse
FOR_OUT="${DATA_DIR}/${BASE}_for_${MAXEE}"
#FOR_OUT="${DATA_DIR}/bacteria"
REV_OUT="${DATA_DIR}/${BASE}_rev_${MAXEE}"
if [[ ! -d $FOR_OUT ]]; then
   mkdir "$FOR_OUT"
fi  
if [[ ! -d $REV_OUT ]]; then
   mkdir "$REV_OUT"
fi  


# filtered reads
export FOR_READS="${FOR_OUT}/00_trunc${TRUNCVAL}_filtered.fastq"
export REV_READS="${REV_OUT}/00_trunc${TRUNCVAL}_filtered.fastq"

# barcodes matching the filtered reads
export FOR_BARCODES="${FOR_OUT}/01_bc_subset.fastq"
export REV_BARCODES="${REV_OUT}/01_bc_subset.fastq"

# demultiplexed files
export FOR_DEMUX="${FOR_OUT}/02_demultiplexed_reads_trunc${TRUNCVAL}"
export REV_DEMUX="${REV_OUT}/02_demultiplexed_reads_trunc${TRUNCVAL}"

# dereplicated files
export FOR_DEREP="${FOR_OUT}/03_trunc${TRUNCVAL}_derep.fna"
export REV_DEREP="${REV_OUT}/03_trunc${TRUNCVAL}_derep.fna"

export FOR_SORTED="${FOR_OUT}/04_trunc${TRUNCVAL}_derep_sorted.fna"
export REV_SORTED="${REV_OUT}/04_trunc${TRUNCVAL}_derep_sorted.fna"

# OTUs
export FOR_OTU="${FOR_OUT}/05_trunc${TRUNCVAL}_otus.fasta"
export REV_OTU="${REV_OUT}/05_trunc${TRUNCVAL}_otus.fasta"
#OTU results
export FOR_OTU_RESULTS="${FOR_OUT}/05_trunc${TRUNCVAL}_results.fasta"
export REV_OTU_RESULTS="${REV_OUT}/05_trunc${TRUNCVAL}_results.fasta"

# files containing non-chimeric OTUs
export FOR_NONCHIM="${FOR_OUT}/06_trunc${TRUNCVAL}_nonchim.fasta.uchime"
#export FOR_NONCHIM="${DATA_DIR}/bacteriaFASTA.txt"
export REV_NONCHIM="${REV_OUT}/06_trunc${TRUNCVAL}_nonchim.fasta.uchime"

export FOR_CHIM_MAP="${FOR_OUT}/07_map_trunc${TRUNCVAL}_uchime.uc"
export REV_CHIM_MAP="${REV_OUT}/07_map_trunc${TRUNCVAL}_uchime.uc"

# OTU tables
export FOR_OTU_TABLE="${FOR_OUT}/08_trunc${TRUNCVAL}_otu_table.txt"
export REV_OTU_TABLE="${REV_OUT}/08_trunc${TRUNCVAL}_otu_table.txt"

export FOR_TAXONOMY="${FOR_OUT}/09_trunc${TRUNCVAL}_taxonomy"
export REV_TAXONOMY="${REV_OUT}/09_trunc${TRUNCVAL}_taxonomy"
