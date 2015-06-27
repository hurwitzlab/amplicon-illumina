#!/bin/bash

# specify whether input is paired-end reads
export PAIRED_END="true"

export MAXEE=0.25
export TRUNCVAL=200
export BIN_DIR="/rsgrps/bhurwitz/hurwitzlab/bin"
export DATA_DIR="/gsfs1/rsgrps/bhurwitz/hurwitzlab/data/jana"
export FOR_IN_READS="${DATA_DIR}/run1_for.fastq"
# barcode file
export BARCODES="${DATA_DIR}/run1_bc.fastq"
# mapfile necessary for demultiplexing
export MAPFILE="${DATA_DIR}/map1.txt"
# reference databases
export QIIME_REF_DATABASE="${DATA_DIR}/Unite_ITS_database/qiime/sh_refs_qiime_ver7_97_02.03.2015.fasta"
export ITS_REF_DATABASE="${DATA_DIR}/fungalITSdatabaseID.fasta"
#export QIIME_REF_DATABASE="/uaopt/qiime/1.9.0/lib/python2.7/site-packages/qiime_default_reference/gg_13_8_otus/rep_set/97_otus.fasta"
# taxonomy mappings
#export QIIME_TAX_MAP="${DATA_DIR}/Unite_ITS_database/qiime/sh_taxonomy_qiime_ver7_97_02.03.2015.txt"
export QIIME_TAX_MAP="/uaopt/qiime/1.9.0/lib/python2.7/site-packages/qiime_default_reference/gg_13_8_otus/taxonomy/97_otu_taxonomy.txt"
# default value for OTU_RADIUS is 3.0
export OTU_RADIUS="5.0"
export MIN_SIZE="3"


export PROJECT_DIR="/rsgrps/bhurwitz/hurwitzlab/amplicon-illumina/scripts"
#export PROJECT_DIR="${DATA_DIR}"
export SCRIPT_DIR="${PROJECT_DIR}/workers"


BASE=$(basename ${FOR_IN_READS} _for.fastq)



#export MOTHUR_TAX_MAP="${DATA_DIR}/Unite_ITS_database/mothur/UNITEv6_sh_97.tax"

### OUTPUT FILENAMES ###
# shouldn't really mess with these too much

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

# barcodes matching the filtered reads
export FOR_BARCODES="${FOR_OUT}/01_bc_subset.fastq"

# demultiplexed files
export FOR_DEMUX="${FOR_OUT}/02_demultiplexed_reads_trunc${TRUNCVAL}"

# dereplicated files
export FOR_DEREP="${FOR_OUT}/03_trunc${TRUNCVAL}_derep.fna"

# sorted files
export FOR_SORTED="${FOR_OUT}/04_trunc${TRUNCVAL}_derep_sorted.fna"

# OTUs
export FOR_OTU="${FOR_OUT}/05_trunc${TRUNCVAL}_otus.fasta"
#OTU results
export FOR_OTU_RESULTS="${FOR_OUT}/05_trunc${TRUNCVAL}_results.fasta"

# files containing non-chimeric OTUs
export FOR_NONCHIM="${FOR_OUT}/06_trunc${TRUNCVAL}_nonchim.fasta.uchime"

export FOR_CHIM_MAP="${FOR_OUT}/07_map_trunc${TRUNCVAL}_uchime.uc"

# OTU tables
export FOR_OTU_TABLE="${FOR_OUT}/08_trunc${TRUNCVAL}_otu_table.txt"

# taxonomy assignments
export FOR_TAXONOMY="${FOR_OUT}/09_trunc${TRUNCVAL}_taxonomy"

if [[ ${PAIRED_END} = "true" ]]; then

   export REV_READS=$(echo ${FOR_READS} | sed 's/_for/_rev/')
   export REV_BARCODES=$(echo ${FOR_READS} | sed 's/_for/_rev/')
   export REV_DEMUX=$(echo ${FOR_READS} | sed 's/_for/_rev/')
   export REV_DEREP=$(echo ${FOR_READS} | sed 's/_for/_rev/')
   export REV_SORTED=$(echo ${FOR_READS} | sed 's/_for/_rev/')
   export REV_OTU=$(echo ${FOR_READS} | sed 's/_for/_rev/')
   export REV_OTU_RESULTS=$(echo ${FOR_READS} | sed 's/_for/_rev/')
   export REV_NONCHIM=$(echo ${FOR_READS} | sed 's/_for/_rev/')
   export REV_CHIM_MAP=$(echo ${FOR_READS} | sed 's/_for/_rev/')
   export REV_OTU_TABLE=$(echo ${FOR_READS} | sed 's/_for/_rev/')
   export REV_TAXONOMY=$(echo ${FOR_READS} | sed 's/_for/_rev/')
fi
