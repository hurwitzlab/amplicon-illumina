#PBS -N assign-taxonomy
#PBS -m bea
#PBS -M whwilder@email.arizona.edu
#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=4:mem=23Gb
#PBS -l cput=0:30:0
#PBS -l walltime=24:00:00
#PBS -l jobtype=cluster_only
#PBS -l pvmem=23Gb

set -u
source ${PROJECT_DIR}/config.sh

module load qiime/1.8.0
module load blast
module load mothur

cd $FOR_OUT
parallel_assign_taxonomy_rdp.py -i ${FOR_NONCHIM} -o . -t ${QIIME_TAX_MAP} -r ${QIIME_REF_DATABASE} -O 4 --rdp_max_memory 3500 2> 09_assign_taxonomy.log
mv ${FOR_NONCHIM%.uchime}_tax_assignments.txt ${FOR_TAXONOMY}
#parallel_assign_taxonomy_rdp.py -i ../bacteriaFASTA.txt -o . -t /uaopt/qiime/1.9.0/lib/python2.7/site-packages/qiime_default_reference/gg_13_8_otus/taxonomy/97_otu_taxonomy.txt -r /uaopt/qiime/1.9.0/lib/python2.7/site-packages/qiime_default_reference/gg_13_8_otus/rep_set/97_otus.fasta -O 4 --rdp_max_memory 3500

#mothur "#classify.seqs(fasta=${FOR_NONCHIM}, reference=${MOTHUR_REF_DATABASE}, taxonomy=${MOTHUR_TAX_MAP}, cutoff=80, processors=8)" 2> 09_assign_taxonomy.log

### Do above steps for the reverse reads
### note to self - find a way to do forward and reverse reads in one step
#cd $REV_OUT
#mothur "#classify.seqs(fasta=${REV_NONCHIM}, reference=${MOTHUR_REF_DATABASE}, taxonomy=${MOTHUR_TAX_MAP}, cutoff=80, processors=8)" 2> 09_assign_taxonomy.log
#mv ${REV_NONCHIM%.uchime}.UNITEv6_sh_97.wang.taxonomy ${REV_TAXONOMY}
#parallel_assign_taxonomy_rdp.py -i ${REV_NONCHIM} -o ${REV_TAXONOMY} -t ${TAX_MAP} -r ${REF_DATABASE} -O 7 --rdp_max_memory 3500
