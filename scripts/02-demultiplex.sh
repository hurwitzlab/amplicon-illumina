#!/bin/bash

set -u
source ./config.sh

CWD=$PWD
export PROG=$(basename $0 ".sh")


i=0
JOB=$(qsub -j oe -v REV_BARCODES,FOR_BARCODES,FOR_READS,REV_READS,DATA_DIR,BIN_DIR,PROJECT_DIR ${SCRIPT_DIR}/demultiplex_exec.sh)
printf "%5d: %s\n" $i $JOB
