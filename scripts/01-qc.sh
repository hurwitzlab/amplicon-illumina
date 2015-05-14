#!/bin/bash

set -u

CWD=$PWD
PROG=$(basename $0 ".sh")
STDOUT_DIR="$CWD/out/$PROG"

if [[ ! -d $STDOUT_DIR ]]; then
  mkdir $STDOUT_DIR
fi

DATA_DIR=/rsgrps/bhurwitz/hurwitzlab/data/jana/
SCRIPT_DIR=$CWD/workers
TMP_FILES=$(mktemp)

echo DATA_DIR \"$DATA_DIR\"

cd $DATA_DIR

#rm -f split*
#
## bill to find only for/rev files
##find . -type f -name run1_(for|rev)* > $TMP_FILES
#find . -type f -name run1_(for|rev)* > $TMP_FILES
#
#i=0
#while read FILE; do
#    let i++
#    BASENAME=$(basename $FILE)
#    printf "%5d: %s\n" $i $BASENAME
#    split -l 10000000 $BASENAME "split-$BASENAME-"
#done < $TMP_FILES

# find the forwards
find . -type f -name split\*_for.\* > $TMP_FILES

export SCRIPT_DIR
export DATA_DIR

i=0
while read FILE; do
  let i++
  export FILE
  BASENAME=$(basename $FILE)
  JOB=$(qsub -j oe -o $STDOUT_DIR/$BASENAME -v SCRIPT_DIR,DATA_DIR,FILE $SCRIPT_DIR/quality_length.pbs)
  printf "%5d: %s\n" $i $JOB
done < $TMP_FILES

echo Done, submitted $i jobs.

