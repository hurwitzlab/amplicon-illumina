#!/bin/bash

## Usage: demultiplex.sh forward_labels.csv reverse_labels.csv oriented.fastq

FORWARD=$1
REVERSE=$2
FASTQ=$3

OLDIFS=$IFS
IFS=,

while read name label
do
	fqgrep -e -f -p $label $FASTQ > $name.fasta
done < $FORWARD


FILES=(*.fasta)
declare -a LABELS
let i=0

while read name label
do
	fqgrep -e -f -p $label ${FILES[i]} > $name\_${FILES[i]}
	((++i))
done < $REVERSE

IFS=$OLDIFS
