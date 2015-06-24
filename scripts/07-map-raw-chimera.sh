#!/bin/bash

set -u
source ./config.sh

CWD=$PWD
export DATA_DIR="/rsgrps/bhurwitz/hurwitzlab/data/jana"
export PROG=$(basename $0 ".sh")

export FOR_OUT="${DATA_DIR}/for-$MAXEE"
export REV_OUT="${DATA_DIR}/rev-$MAXEE"

export FOR_READS="${FOR_OUT}/run1_for_ee${MAXEE}_trunc${TRUNCVAL}.fastq"
export REV_READS="${REV_OUT}/run1_rev_ee${MAXEE}_trunc${TRUNCVAL}.fastq"

export FOR_OTU="${FOR_OUT}/otus"
export REV_OTU="${REV_OUT}/otus"
if [[ ! -d ${FOR_OTU} ]]; then
   mkdir ${FOR_OTU}
fi
if [[ ! -d ${REV_OTU} ]]; then
   mkdir ${REV_OTU}
fi
# demultiplexed files
export FOR_DEMUX="slout_for_ee${MAXEE}_trunc${TRUNCVAL}/seqs.fna"
export REV_DEMUX="slout_rev_ee${MAXEE}_trunc${TRUNCVAL}/seqs.fna"
# nonchimeras
export FOR_NONCHIM="${FOR_OUT}/06-for_ee${MAXEE}_trunc${TRUNCVAL}.OTUrep.fasta.uchime"
export REV_NONCHIM="${FOR_OUT}/06-rev_ee${MAXEE}_trunc${TRUNCVAL}.OTUrep.fasta.uchime"
i=0
JOB=$(qsub -j oe -v FOR_DEMUX,REV_DEMUX,REV_NONCHIM,FOR_NONCHIM,TRUNCVAL,MAXEE,DATA_DIR,BIN_DIR,FOR_OUT,REV_OUT,PROJECT_DIR  ${SCRIPT_DIR}/map-raw-chimera_exec.sh)
printf "%5d: %s\n" $i $JOB
