#!/usr/bin/python

import optparse
from optparse import OptionParser
from Bio import SeqIO
from string import upper
from Bio.Seq import Seq

parser=OptionParser()
parser.add_option("-i","--inputfile", 
                  action="store", type="string", dest="inputfile", 
                  default="NONE", help ="path to FASTQ-file")
parser.add_option("-o","--outputfile",
                  action="store", type="string", dest="outputfile", 
                  default="NONE", help ="path to FASTQ-file")
parser.add_option("-f","--forwardPrimer",
                  action="store", type="string", dest="forwardPrimer", 
                  default="NONE", help ="give forward primer sequence") 
parser.add_option("-r","--reversePrimer",
                  action="store", type="string", dest="reversePrimer", 
                  default="NONE", help ="give reverse primer sequence") 
(options, args) = parser.parse_args()

forward_seq = Seq(options.forwardPrimer)
reverse_seq = Seq(options.reversePrimer)

input_seq_iterator = SeqIO.parse(open(options.inputfile), "fastq")
short_seq_iterator = (record for record in input_seq_iterator \
                        if upper(str(record.seq)).count(str(forward_seq)) < 2 \
                        if upper(str(record.seq)).count(str(forward_seq.reverse_complement())) < 2 \
                        if upper(str(record.seq)).count(str(reverse_seq)) < 2 \
                        if upper(str(record.seq)).count(str(reverse_seq.reverse_complement())) < 2)
                         
output_handle = open(options.outputfile, "w")
SeqIO.write(short_seq_iterator, output_handle, "fastq")
output_handle.close()
