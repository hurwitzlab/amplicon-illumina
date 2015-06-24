#!/bin/bash

set -u
source ./config.sh

CWD=$PWD
export PROG=$(basename $0 ".sh")

i=0
JOB=$(qsub -j oe -v PROJECT_DIR ${SCRIPT_DIR}/sort-discard_exec.sh)
printf "%5d: %s\n" $i $JOB
