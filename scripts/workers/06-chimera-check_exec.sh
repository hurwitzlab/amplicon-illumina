#PBS -N chimera-check
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
FOR_OTU_BASE=$(basename ${FOR_OTU#*05-*} .fasta)
${BIN_DIR}/usearch -uchime_ref ${FOR_OTU} -db ${ITS_REF_DATABASE} -uchimeout 06-chimeras.uchime -strand plus -nonchimeras ${FOR_NONCHIM} -threads 1 2> 06-chimera-check.log
### Do above steps for the reverse reads
### note to self - find a way to do forward and reverse reads in one step
cd $REV_OUT
REV_OTU_BASE=$(basename ${REV_OTU#*05-*} .fasta)
${BIN_DIR}/usearch -uchime_ref ${REV_OTU} -db ${ITS_REF_DATABASE} -uchimeout 06-chimeras.uchime -strand plus -nonchimeras ${REV_NONCHIM} -threads 1 2> 06-chimera-check.log
