#!/bin/bash
set -u
source ./config.sh

#FOR_READS=$1
#sed -i 's/FOR_READS*/FOR_READS=${FOR_READS}/' config.sh

CWD=$PWD
export PROG=$(basename $0 ".sh")
export FOR_BASE=$(basename $DATA_DIR/*_for.fastq.aa .fastq.aa)
export REV_BASE=$(basename $DATA_DIR/*_rev.fastq.aa .fastq.aa)

# file containing all the files containing forward reads; qsub doesn't accept
# a regular list of files
export FOR_FILES_LIST=${HOME}/${FOR_BASE}.for
rm -f $FOR_FILES_LIST
# find all the forward files
FOR_FILES=$(ls $DATA_DIR/*_for.fastq.a[a-z])
for FILE in $FOR_FILES; do
   echo $FILE >> $FOR_FILES_LIST
done
# repeat above for reverse files; maybe try to collapse this into one step
export REV_FILES_LIST=${HOME}/${REV_BASE}.rev
rm -f $REV_FILES_LIST
REV_FILES=$(ls $DATA_DIR/*_rev.fastq.a[a-z])
for FILE in $REV_FILES; do
   echo $FILE >> $REV_FILES_LIST
done

JOB=$(qsub -j oe -v FOR_FILES_LIST,REV_FILES_LIST,PROJECT_DIR workers/testpipeline_exec.sh)
echo "Job ID: ${JOB}"
