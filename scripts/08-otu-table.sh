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
export FOR_CHIM_MAP="${FOR_OUT}/otus/07-map.run1_for_ee${MAXEE}_trunc${TRUNCVAL}_uchime.uc"
export REV_CHIM_MAP="${REV_OUT}/otus/07-map.run1_rev_ee${MAXEE}_trunc${TRUNCVAL}_uchime.uc"
i=0
JOB=$(qsub -j oe -v FOR_CHIM_MAP,REV_CHIM_MAP,TRUNCVAL,MAXEE,DATA_DIR,BIN_DIR,FOR_OUT,REV_OUT,PROJECT_DIR ${SCRIPT_DIR}/otu-table_exec.sh)
printf "%5d: %s\n" $i $JOB
