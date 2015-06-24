#PBS -N qiime_demult
#PBS -m bea
#PBS -M whwilder@email.arizona.edu
#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=2:mem=4Gb
#PBS -l cput=6:0:0
#PBS -l walltime=24:00:00
set -u
source ${PROJECT_DIR}/config.sh

module load qiime/1.8.0

cd $FOR_OUT
split_libraries_fastq.py -o 02-for_demultiplexed_files -i ${FOR_READS} -b ${FOR_BARCODES} -m ${MAPFILE} -q 0 --barcode_type 12 --rev_comp_barcode --phred_offset=33 2> 02-qiime-demult.log

### Do above steps for the reverse reads
### note to self - find a way to do forward and reverse reads in one step
cd $REV_OUT
split_libraries_fastq.py -o 02-rev_demultiplexed_files -i ${REV_READS} -b ${REV_BARCODES} -m ${MAPFILE} -q 0 --barcode_type 12 --rev_comp_barcode --phred_offset=33 2> 02-qiime-demult.log
