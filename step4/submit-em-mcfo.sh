#!/bin/bash

# start the jobs that run the reverse gradient adjustment, EM vs MCFO
# this is a modified version of submitUpdateRevGABatch.sh in the main repo

# global parameters first, then common parameters for this step
source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"
source "$(dirname ${BASH_SOURCE[0]})/cdsparams-em-mcfo.sh"

function localRun {
    if [[ $# -lt 2 ]] ; then
      echo "localRun <from> <to>"
            exit 1
    fi
    from=$1
    to=$2
    echo "Running jobs: ${from} - ${to}"
    for ((LSB_JOBINDEX=${from}; LSB_JOBINDEX<=${to}; LSB_JOBINDEX++)) ; do
        ${SCRIPT_DIR}/submitUpdateRevGAJob.sh ${CDGA_INPUT_DIR} ${CDGA_OUTPUT_DIR} ${LSB_JOBINDEX}
    done
}

function gridRun {
    if [[ $# -lt 2 ]] ; then
      echo "gridRun <from> <to>"
            exit 1
    fi
    from=$1
    to=$2
    echo "Running jobs: ${from} - ${to}"
    bsub ${BSUB_OPTIONS} -n ${CORES_RESOURCE} -J CDGA[${from}-${to}] -P ${CLUSTER_PROJECT_CODE} \
        ${SCRIPT_DIR}/submitUpdateRevGAJob.sh ${CDGA_INPUT_DIR} ${CDGA_OUTPUT_DIR}
}

echo "Total jobs: ${TOTAL_JOBS}"

mkdir -p $JOB_LOGPREFIX

# to run locally use localRun <from> <to>
# to run on the grid use gridRun <from> <to>
FIRST_JOB=${FIRST_JOB:-1}
LAST_JOB=${LAST_JOB:-${TOTAL_JOBS}}
startcmd="${RUN_CMD} ${FIRST_JOB} ${LAST_JOB}"
echo $startcmd
($startcmd)
