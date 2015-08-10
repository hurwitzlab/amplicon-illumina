#!/bin/bash
export DATA_DIR="/rsgrps/bhurwitz/hurwitzlab/data/raw/GWATTS/16s_Sequencing/41_Strain_Isolates/FastaFiles"
#export DATA_DIR="/rsgrps/bhurwitz/hurwitzlab/data/jana/"
# Use this variable to get the pipeline to start at an arbitrary step, e.g., if
# it is 3, the pipeline will start at step 3.
#Still need to work out how to handle input files for this, though
START_STEP="8" 
export PROJECT_DIR="/rsgrps/bhurwitz/hurwitzlab/amplicon-illumina/scripts"
export FOR_IN_READS="${DATA_DIR}/01_41_strain_isolates_V1-V2.trimmed.fasta"

export SCRIPT_DIR="${PROJECT_DIR}/workers"

# specify whether input is paired-end reads
export PAIRED_END="false"

export MAXEE=0.25
export TRUNCVAL=200
export BIN_DIR="/rsgrps/bhurwitz/hurwitzlab/bin"
# barcode file for demultiplexing
export BARCODES="${DATA_DIR}/run1_bc.fastq"
# mapfile necessary for demultiplexing
export MAPFILE="${DATA_DIR}/map1.txt"

# reference databases
#export QIIME_REF_DATABASE="${DATA_DIR}/Unite_ITS_database/qiime/sh_refs_qiime_ver7_97_02.03.2015.fasta"
export ITS_REF_DATABASE="${PROJECT_DIR}/rdp_gold.fa"
export QIIME_REF_DATABASE="/uaopt/qiime/1.9.0/lib/python2.7/site-packages/qiime_default_reference/gg_13_8_otus/rep_set/97_otus.fasta"

# taxonomy mappings
#export QIIME_TAX_MAP="${DATA_DIR}/Unite_ITS_database/qiime/sh_taxonomy_qiime_ver7_97_02.03.2015.txt"
export QIIME_TAX_MAP="/uaopt/qiime/1.9.0/lib/python2.7/site-packages/qiime_default_reference/gg_13_8_otus/taxonomy/97_otu_taxonomy.txt"

# default value for OTU_RADIUS is 3.0
export OTU_RADIUS="5.0"
export MIN_SIZE="3"

BASE=$(basename ${FOR_IN_READS} .fasta)

#export MOTHUR_TAX_MAP="${DATA_DIR}/Unite_ITS_database/mothur/UNITEv6_sh_97.tax"

### OUTPUT FILENAMES ###
# shouldn't really mess with these too much

# output directories for forward and reverse
FOR_OUT="${PROJECT_DIR}/out/test-pipeline"
REV_OUT="${PROJECT_DIR}/out/test-pipeline/rev"
if [[ ! -d $FOR_OUT ]]; then
   mkdir "$FOR_OUT"
fi  

# reads w/ Illumina adapters removed
export FOR_ADAPT="${FOR_OUT}/no-adapters.fastq"

# filtered reads
export FOR_READS="${FOR_OUT}/00_trunc${TRUNCVAL}_filtered.fastq"

# barcodes matching the filtered reads
export FOR_BARCODES="${FOR_OUT}/01_bc_subset.fastq"

# demultiplexed files
export FOR_DEMUX="${FOR_OUT}/02_demultiplexed_reads_trunc${TRUNCVAL}"
#export FOR_DEMUX="${FOR_IN_READS}"

# dereplicated files
export FOR_DEREP="${FOR_OUT}/03_trunc${TRUNCVAL}_derep.fna"

# sorted files
export FOR_SORTED="${FOR_OUT}/04_trunc${TRUNCVAL}_derep_sorted.fna"

# OTUs
export FOR_OTU="${FOR_OUT}/05_trunc${TRUNCVAL}_otus.fasta"
#OTU results
export FOR_OTU_RESULTS="${FOR_OUT}/05_trunc${TRUNCVAL}_otu_results.fasta"

# files containing non-chimeric OTUs
export FOR_NONCHIM="${FOR_OUT}/06_trunc${TRUNCVAL}_nonchim.fasta.uchime"
#export FOR_NONCHIM="${FOR_OTU}"

export FOR_CHIM_MAP="${FOR_OUT}/07_map_trunc${TRUNCVAL}_uchime.uc"

# OTU tables
export FOR_OTU_TABLE="${FOR_OUT}/08_trunc${TRUNCVAL}_otu_table.txt"

# taxonomy assignments
export FOR_TAXONOMY="${FOR_OUT}/09_trunc${TRUNCVAL}_taxonomy"

if [[ ${PAIRED_END} = "true" ]]; then
   if [[ ! -d $REV_OUT ]]; then
      mkdir "$REV_OUT"
   fi

   export REV_IN_READS=$(echo ${FOR_IN_READS} | sed 's/_for/_rev/')
   export REV_ADAPT="${REV_OUT}/$(basename ${FOR_ADAPT})"
   export REV_READS="${REV_OUT}/$(basename ${FOR_READS})"
   export REV_BARCODES="${REV_OUT}/$(basename ${FOR_BARCODES})"
   export REV_DEMUX="${REV_OUT}/$(basename ${FOR_DEMUX})"
   export REV_DEREP="${REV_OUT}/$(basename ${FOR_DEREP})"
   export REV_SORTED="${REV_OUT}/$(basename ${FOR_SORTED})"
   export REV_OTU="${REV_OUT}/$(basename ${FOR_OTU})"
   export REV_OTU_RESULTS="${REV_OUT}/$(basename ${FOR_OTU_RESULTS})"
   export REV_NONCHIM="${REV_OUT}/$(basename ${FOR_NONCHIM})"
   export REV_CHIM_MAP="${REV_OUT}/$(basename ${FOR_CHIM_MAP})"
   export REV_OTU_TABLE="${REV_OUT}/$(basename ${FOR_OTU_TABLE})"
   export REV_TAXONOMY="${REV_OUT}/$(basename ${FOR_TAXONOMY})"
fi
