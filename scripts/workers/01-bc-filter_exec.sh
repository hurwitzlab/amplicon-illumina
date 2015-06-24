#PBS -N bc-filter
#PBS -m bea
#PBS -M whwilder@email.arizona.edu
#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=2:mem=4Gb
#PBS -l cput=6:0:0
#PBS -l walltime=24:00:00
set -u
source ${PROJECT_DIR}/config.sh

#module load mothur

cd $FOR_OUT
FOR_BASENAME=$(basename $FOR_READS .fastq)
### GENERATE LIST OF SEQUENCES IN FILTERED FILE
grep '@M' ${FOR_READS} | sed 's/@//' > ${BASE}.accnos
### GET SEQUENCES FROM BARCODE READS TO MATCH FILTERED READS
#mothur "#get.seqs(accnos=$FOR_BASENAME.accnos2, fastq=${DATA_DIR}/run1_bc.fastq)"
${BIN_DIR}/usearch -fastx_getseqs ${BARCODES} -labels ${FOR_BASENAME}.accnos -fastqout ${FOR_BARCODES} 2> 01-bc-filter.log
### REMOVE ENDING ON BARCODE FILE NAME TO MATCH FILTERED READS FILE
#sed 's/ 1:N:0:0//' ${DATA_DIR}/run1_bc.pick.fastq > run1_bc.pick2.fastq

### Do above steps for the reverse reads
### note to self - find a way to do forward and reverse reads in one step
cd $REV_OUT
REV_BASENAME=$(basename $REV_READS .fastq)
grep '@M' ${REV_READS} | sed 's/@//' > ${BASE}.accnos
#mothur "#get.seqs(accnos=$REV_BASENAME.accnos2, fastq=${DATA_DIR}/run1_bc.fastq)"
${BIN_DIR}/usearch -fastx_getseqs ${BARCODES} -labels ${REV_BASENAME}.accnos -fastqout ${REV_BARCODES} 2> 01-bc-filter.log
#sed 's/1:N:0:0//' ${REV_BASENAME}.pick.fastq > ${REV_BASENAME}.pick2.fastq
