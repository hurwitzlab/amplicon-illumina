#PBS -N usearch-derep
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
#TODO: get output to use file basename
${BIN_DIR}/usearch -derep_fulllength ${FOR_DEMUX} -fastaout ${FOR_DEREP} -sizeout -threads 1 &> 03-usearch-derep.log
### Do above steps for the reverse reads
### note to self - find a way to do forward and reverse reads in one step
cd $REV_OUT
${BIN_DIR}/usearch -derep_fulllength ${REV_DEMUX} -fastaout ${REV_DEREP} -sizeout -threads 1 &> 03-usearch-derep.log
