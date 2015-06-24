#PBS -N filter-reads
#PBS -m bea
#PBS -M whwilder@email.arizona.edu
#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=2:mem=4Gb
#PBS -l cput=6:0:0
#PBS -l walltime=24:00:00
set -u
source ${PROJECT_DIR}/config.sh

cd $FOR_OUT
while read FILE; do 
   echo $FILE
   FILENAME=$(basename $FILE)
# these 2 variables are just here to help us name the output files
   BASENAME=${FILENAME%.fastq.a[a-z]}
   AFFIX=${FILENAME#*.fastq.}
   echo $BASENAME
#   $BIN_DIR/usearch -fastq_filter $FILE -fastqout ${BASENAME}_filtered -fastq_truncqual 15 -fastq_maxee $MAXEE --eeout -fastq_maxns 0 -fastq_ascii 33
   $BIN_DIR/usearch -fastq_filter $FILE -fastqout \
   00-${BASENAME}_ee${MAXEE}_trunc${TRUNCVAL}_filtered.fastq.$AFFIX \
   -fastq_trunclen ${TRUNCVAL} -fastq_maxee $MAXEE -threads 1 &> \
   00-usearch-filter.log
done < $FOR_FILES_LIST

# concatenate filtered files
TRUNCFILES=$(ls *_for_*.fastq.a[a-z])
cat $TRUNCFILES > ${FOR_READS}
# remove filtered split files after concatenating them
rm *_for_*.fastq.a[a-z]

# repeat above steps for reverse files
cd $REV_OUT
while read FILE; do
   echo $FILE
   FILENAME=$(basename $FILE)
   BASENAME=${FILENAME%.fastq.a[a-z]}
   AFFIX=${FILENAME#*.fastq.}
   echo $BASENAME
#   $BIN_DIR/usearch -fastq_filter $FILE -fastqout ${BASENAME}_filtered -fastq_truncqual 15 -fastq_maxee $MAXEE --eeout -fastq_maxns 0 -fastq_ascii 33
   $BIN_DIR/usearch -fastq_filter $FILE -fastqout \
   00-${BASENAME}_ee${MAXEE}_trunc${TRUNCVAL}_filtered.fastq.$AFFIX \
   -fastq_trunclen ${TRUNCVAL} -fastq_maxee $MAXEE -threads 1 &> \
   00-usearch-filter.log
done < $REV_FILES_LIST
TRUNCFILES=$(ls *_rev_*.fastq.a[a-z])
cat $TRUNCFILES > ${REV_READS}
# remove filtered split files after concatenating them
rm *_rev_*.fastq.a[a-z]
