#PBS -N otu-cluster
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
${BIN_DIR}/usearch -cluster_otus ${FOR_SORTED} -otus ${FOR_OTU} -uparseout ${FOR_OTU_RESULTS} -otu_radius_pct ${OTU_RADIUS} 2> 05-for_otu_cluster_5.0.log
### Do above steps for the reverse reads
### note to self - find a way to do forward and reverse reads in one step
cd $REV_OUT
REV_BASENAME=$(basename ${REV_SORTED} _derep_sorted.fna)
${BIN_DIR}/usearch -cluster_otus ${REV_SORTED} -otus ${REV_OTU} -uparseout ${REV_OTU_RESULTS} -otu_radius_pct ${OTU_RADIUS} 2> 05-rev_otu_cluster_5.0.log
