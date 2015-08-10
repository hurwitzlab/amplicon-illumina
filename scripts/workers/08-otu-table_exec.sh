#PBS -N otu-table
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
python ${BIN_DIR}/drive5_py/uc2otutab_mod.py ${FOR_CHIM_MAP} > \
${FOR_OTU_TABLE} 2> 08-otu-table_for.log
### Do above steps for the reverse reads
### note to self - find a way to do forward and reverse reads in one step
if [[ $PAIRED_END = "true" ]]; then
   cd $REV_OUT
   python ${BIN_DIR}/drive5_py/uc2otutab_mod.py ${FOR_CHIM_MAP} > \
   ${REV_OTU_TABLE} 2> 08-otu-table_rev.log
fi
