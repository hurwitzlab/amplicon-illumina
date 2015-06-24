#!/bin/bash

set -u
source ./config.sh

CWD=$PWD
export PROG=$(basename $0 ".sh")

i=0
JOB=$(qsub -j oe -v TRUNCVAL,MAXEE,DATA_DIR,BIN_DIR,PROJECT_DIR ${SCRIPT_DIR}/bc-filter_exec.sh)
printf "%5d: %s\n" $i $JOB
