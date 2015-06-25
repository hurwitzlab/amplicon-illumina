#PBS -N test-pipeline
#PBS -m bea
#PBS -M whwilder@email.arizona.edu
#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=2:mem=4Gb
#PBS -l cput=1:0:0
#PBS -l walltime=24:00:00
set -u
source ${PROJECT_DIR}/config.sh

### STEP 0: FILTER READS ###

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


### STEP 1: FILTER BARCODES TO MATCH FILTERED READS ###

cd $FOR_OUT
FOR_BASENAME=$(basename $FOR_READS .fastq)
### GENERATE LIST OF SEQUENCES IN FILTERED FILE
grep '@M' ${FOR_READS} | sed 's/@//' > ${BASE}.accnos
### GET SEQUENCES FROM BARCODE READS TO MATCH FILTERED READS
${BIN_DIR}/usearch -fastx_getseqs ${BARCODES} -labels ${BASE}.accnos -fastqout ${FOR_BARCODES} 2> 01-bc-filter.log
### REMOVE ENDING ON BARCODE FILE NAME TO MATCH FILTERED READS FILE

### Do above steps for the reverse reads
### note to self - find a way to do forward and reverse reads in one step
cd $REV_OUT
REV_BASENAME=$(basename $REV_READS .fastq)
grep '@M' ${REV_READS} | sed 's/@//' > ${BASE}.accnos
${BIN_DIR}/usearch -fastx_getseqs ${BARCODES} -labels ${BASE}.accnos -fastqout ${REV_BARCODES} 2> 01-bc-filter.log


### STEP 2: DEMULTIPLEX ###

module load qiime/1.8.0

cd $FOR_OUT
split_libraries_fastq.py -o . -i ${FOR_READS} -b ${FOR_BARCODES} -m ${MAPFILE} -q 0 --barcode_type 12 --rev_comp_barcode --phred_offset=33 2> 02-qiime-demult.log
mv seqs.fna ${FOR_DEMUX}

### Do above steps for the reverse reads
### note to self - find a way to do forward and reverse reads in one step
cd $REV_OUT
split_libraries_fastq.py -o . -i ${REV_READS} -b ${REV_BARCODES} -m ${MAPFILE} -q 0 --barcode_type 12 --rev_comp_barcode --phred_offset=33 2> 02-qiime-demult.log
mv seqs.fna ${REV_DEMUX}


### STEP 3: DEREPLICATE ###

cd $FOR_OUT
${BIN_DIR}/usearch -derep_fulllength ${FOR_DEMUX} -fastaout ${FOR_DEREP} -sizeout -threads 1 &> 03-usearch-derep.log
### Do above steps for the reverse reads
### note to self - find a way to do forward and reverse reads in one step
cd $REV_OUT
${BIN_DIR}/usearch -derep_fulllength ${REV_DEMUX} -fastaout ${REV_DEREP} -sizeout -threads 1 &> 03-usearch-derep.log


### STEP 4: SORT BY SIZE, REMOVE SINGLETONS ###

cd $FOR_OUT
${BIN_DIR}/usearch -sortbysize ${FOR_DEREP} -fastaout "${FOR_SORTED}" -minsize ${MIN_SIZE} 2> 04-sort-discard.log
### Do above steps for the reverse reads
### note to self - find a way to do forward and reverse reads in one step
cd $REV_OUT
REV_BASENAME=$(basename ${REV_DEREP} .fna)
${BIN_DIR}/usearch -sortbysize ${REV_DEREP} -fastaout ${REV_SORTED} -minsize ${MIN_SIZE} 2> 04-sort-discard.log


### STEP 5: CLUSTER INTO OTUS ###

cd $FOR_OUT
${BIN_DIR}/usearch -cluster_otus ${FOR_SORTED} -otus ${FOR_OTU} -uparseout ${FOR_OTU_RESULTS} -otu_radius_pct ${OTU_RADIUS} 2> 05-for_otu_cluster_5.0.log
### Do above steps for the reverse reads
### note to self - find a way to do forward and reverse reads in one step
cd $REV_OUT
REV_BASENAME=$(basename ${REV_SORTED} _derep_sorted.fna)
${BIN_DIR}/usearch -cluster_otus ${REV_SORTED} -otus ${REV_OTU} -uparseout ${REV_OTU_RESULTS} -otu_radius_pct ${OTU_RADIUS} 2> 05-rev_otu_cluster_5.0.log


### STEP 6: CHECK FOR CHIMERAS ###

cd $FOR_OUT
FOR_OTU_BASE=$(basename ${FOR_OTU#*05-*} .fasta)
${BIN_DIR}/usearch -uchime_ref ${FOR_OTU} -db ${ITS_REF_DATABASE} -uchimeout 06-chimeras.uchime -strand plus -nonchimeras ${FOR_NONCHIM} -threads 1 2> 06-chimera-check.log
### Do above steps for the reverse reads
### note to self - find a way to do forward and reverse reads in one step
cd $REV_OUT
REV_OTU_BASE=$(basename ${REV_OTU#*05-*} .fasta)
${BIN_DIR}/usearch -uchime_ref ${REV_OTU} -db ${ITS_REF_DATABASE} -uchimeout 06-chimeras.uchime -strand plus -nonchimeras ${REV_NONCHIM} -threads 1 2> 06-chimera-check.log


### STEP 7: MAP DEMULTIPLEXED READS BACK TO CHIMERA-CHECKED OTUS ###

cd $FOR_OUT
${BIN_DIR}/usearch -usearch_global ${FOR_DEMUX} -db ${FOR_NONCHIM} -strand plus -id 0.97 -uc ${FOR_CHIM_MAP} -threads 1 2> 07-map.for_ee${MAXEE}_trunc${TRUNCVAL}_uchime.log
### Do above steps for the reverse reads
### note to self - find a way to do forward and reverse reads in one step
cd $REV_OUT
${BIN_DIR}/usearch -usearch_global ${REV_DEMUX} -db ${REV_NONCHIM} -strand plus -id 0.97 -uc ${REV_CHIM_MAP} -threads 1 2> 07-map.rev_ee${MAXEE}_trunc${TRUNCVAL}_uchime.log


### STEP 8: BUILD OTU TABLE ###

cd $FOR_OUT
python ${BIN_DIR}/drive5_py/uc2otutab_mod.py ${FOR_CHIM_MAP} > \
${FOR_OTU_TABLE} 2> 08-otu-table_for.log
### Do above steps for the reverse reads
### note to self - find a way to do forward and reverse reads in one step
cd $REV_OUT
python ${BIN_DIR}/drive5_py/uc2otutab_mod.py ${FOR_CHIM_MAP} > \
${REV_OTU_TABLE} 2> 08-otu-table_rev.log


### STEP 9: ASSIGN TAXONOMY ###

module load qiime/1.9.0
module load mothur

cd $FOR_OUT
parallel_assign_taxonomy_rdp.py -i ${FOR_NONCHIM} -o . -t ${QIIME_TAX_MAP} -r ${QIIME_REF_DATABASE} -O 4 --rdp_max_memory 3500 2> 09_assign_taxonomy.log
# rename output to something less confusing
mv ${FOR_NONCHIM%.uchime}_tax_assignments.txt ${FOR_TAXONOMY}

### Do above steps for the reverse reads
### note to self - find a way to do forward and reverse reads in one step
cd $REV_OUT
parallel_assign_taxonomy_rdp.py -i ${REV_NONCHIM} -o . -t ${QIIME_TAX_MAP} -r ${REF_DATABASE} -O 4 --rdp_max_memory 3500 2> 09_assign_taxonomy.log
mv ${REV_NONCHIM%.uchime}_tax_assignments.txt ${REV_TAXONOMY}
