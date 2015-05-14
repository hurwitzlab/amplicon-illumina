#!/bin/bash

DATA=/rsgrps/bhurwitz/hurwitzlab/data/jana/

TMP_FILES=$(mktemp)

find $DATA -type f -name run1\* > $TMP_FILES

i=0
for read FILE; do
    let i++
    printf "%5d: %s" $i $FILE
    split -l 10000000 $FILE \"$FILE-\"
done < $TMP_FILES
