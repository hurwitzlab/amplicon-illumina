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

export FOR_OTU="${FOR_OUT}/otus/05-for_ee${MAXEE}_trunc${TRUNCVAL}_otus.fasta"
export REV_OTU="${FOR_OUT}/otus/05-rev_ee${MAXEE}_trunc${TRUNCVAL}_otus.fasta"
export DATABASE="${DATA_DIR}/fungalITSdatabaseID.fasta"
i=0
JOB=$(qsub -j oe -v DATABASE,FOR_OTU,REV_OTU,TRUNCVAL,MAXEE,DATA_DIR,BIN_DIR,FOR_OUT,REV_OUT,PROJECT_DIR ${SCRIPT_DIR}/chimera-check_exec.sh)
printf "%5d: %s\n" $i $JOB
