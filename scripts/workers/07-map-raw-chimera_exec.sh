#PBS -N map-raw-chimera
#PBS -m bea
#PBS -M whwilder@email.arizona.edu
#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=2:mem=4Gb
#PBS -l cput=6:0:0
#PBS -l walltime=24:00:00
set -u
pwd
source ${PROJECT_DIR}/config.sh

cd $FOR_OUT
${BIN_DIR}/usearch -usearch_global ${FOR_DEMUX} -db ${FOR_NONCHIM} -strand plus -id 0.97 -uc ${FOR_CHIM_MAP} -threads 1 2> 07-map.for_ee${MAXEE}_trunc${TRUNCVAL}_uchime.log
### Do above steps for the reverse reads
### note to self - find a way to do forward and reverse reads in one step
cd $REV_OUT
${BIN_DIR}/usearch -usearch_global ${REV_DEMUX} -db ${REV_NONCHIM} -strand plus -id 0.97 -uc ${REV_CHIM_MAP} -threads 1 2> 07-map.rev_ee${MAXEE}_trunc${TRUNCVAL}_uchime.log
