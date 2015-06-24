#!/bin/bash

set -u
source ./config.sh

CWD=$PWD
export PROG=$(basename $0 ".sh")

export FOR_READS="${FOR_OUT}/run1_for_ee${MAXEE}_trunc${TRUNCVAL}.fastq"
export REV_READS="${REV_OUT}/run1_rev_ee${MAXEE}_trunc${TRUNCVAL}.fastq"

i=0
JOB=$(qsub -j oe -v BIN_DIR,PROJECT_DIR ${SCRIPT_DIR}/dereplicate_exec.sh)
printf "%5d: %s\n" $i $JOB
