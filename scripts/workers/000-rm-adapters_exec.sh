#PBS -N cutadapt
#PBS -m bea
#PBS -M whwilder@email.arizona.edu
#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=2:mem=4Gb
#PBS -l cput=1:0:0
#PBS -l walltime=24:00:00
set -u
source ${PROJECT_DIR}/config.sh

if [[ $PAIRED_ENDS = "false" ]]; then
cd $FOR_OUT
   cutadapt -b ADAPTER -o ${FOR_ADAPT} $FOR_READS
else
   cutadapt -b ADAPTER_FWD -B ADAPTER_REV -o ${FOR_ADAPT} -p ${REV_ADAPT} $FOR_READS $REV_READS
fi
