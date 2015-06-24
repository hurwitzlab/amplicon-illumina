#!/bin/bash

set -u
source ./config.sh

CWD=$PWD
export PROG=$(basename $0 ".sh")
export FOR_BASE=$(basename $DATA_DIR/*_for.fastq.aa .fastq.aa)
export REV_BASE=$(basename $DATA_DIR/*_rev.fastq.aa .fastq.aa)

# file containing all the files containing forward reads; qsub doesn't accept
# a regular list of files
export FOR_FILES_LIST=${HOME}/${PROG}.for
rm -f $FOR_FILES_LIST
# find all the forward files
FOR_FILES=$(ls $DATA_DIR/*_for.fastq.a[a-z])
for FILE in $FOR_FILES; do
   echo $FILE >> $FOR_FILES_LIST
done
# repeat above for reverse files; maybe try to collapse this into one step
export REV_FILES_LIST=${HOME}/${PROG}.rev
rm -f $REV_FILES_LIST
REV_FILES=$(ls $DATA_DIR/*_rev.fastq.a[a-z])
for FILE in $REV_FILES; do
   echo $FILE >> $REV_FILES_LIST
done
#NUM_FOR=$(wc -l $FOR_FILES)
#NUM_REV=$(wc -l $REV_FILES)
#echo (wc -l < $FOR_FILES)
#NUM_FILES=$(($NUM_FOR+$NUM_REV))

i=0
   if [[ ! -d $FOR_OUT ]]; then
      mkdir "$FOR_OUT"
   fi  
   if [[ ! -d $REV_OUT ]]; then
      mkdir "$REV_OUT"
   fi  
   JOB=$(qsub -j oe -v TRUNCVAL,FOR_FILES_LIST,REV_FILES_LIST,DATA_DIR,BIN_DIR,PROJECT_DIR ${SCRIPT_DIR}/usearch_exec.sh)
   printf "%5d: %s\n" $i $JOB
