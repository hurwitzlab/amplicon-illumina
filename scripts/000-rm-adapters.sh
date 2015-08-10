source config.sh

qsub -j oe -v PROJECT_DIR ${SCRIPT_DIR}/rm-adapters_exec.sh
