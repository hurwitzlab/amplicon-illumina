#PBS -N sort-discard
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
FOR_BASENAME=$(basename ${FOR_DEREP} .fna)
#echo ${FOR_DEREP}
#echo ${FOR_BASENAME}
${BIN_DIR}/usearch -sortbysize ${FOR_DEREP} -fastaout "${FOR_SORTED}" -minsize ${MIN_SIZE} 2> 04-sort-discard.log

### Do above steps for the reverse reads
### note to self - find a way to do forward and reverse reads in one step
if [[ $PAIRED_END = "true" ]]; then
   cd $REV_OUT
   REV_BASENAME=$(basename ${REV_DEREP} .fna)
${BIN_DIR}/usearch -sortbysize ${REV_DEREP} -fastaout ${REV_SORTED} -minsize ${MIN_SIZE} 2> 04-sort-discard.log
fi
