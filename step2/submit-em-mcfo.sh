#!/bin/bash

# start the jobs that run the search in parallel, EM (masks) vs MCFO (libraries)
# this is a modified version of submitCDSBatch.sh in the main repo

# global parameters first, then common parameters for this step
source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"
source "$(dirname ${BASH_SOURCE[0]})/step2-cdsparams-em-mcfo.sh"


function localRun {
    if [[ $# -lt 2 ]] ; then
      echo "localRun <from> <to>"
            exit 1
    fi
    from=$1
    to=$2
    for ((LSB_JOBINDEX=${from}; LSB_JOBINDEX<=${to}; LSB_JOBINDEX++)) ; do
        ${SCRIPT_DIR}/submitCDSJob.sh $LSB_JOBINDEX
    done
}

function gridRun {
    if [[ $# -lt 2 ]] ; then
      echo "gridRun <from> <to>"
            exit 1
    fi
    from=$1
    # this is tricky and has not been tested yet because we have to run a function from this file
    to=$2
    bsub -n ${CORES_RESOURCE} -J CDS[${from}-${to}] -P emlm \
        ${SCRIPT_DIR}/submitCDSJob.sh
}

echo "Total jobs: $TOTAL_JOBS"

mkdir -p $JOB_LOGPREFIX

# to run locally use localRun <from> <to>
# to run on the grid use gridRun <from> <to>
FIRST_JOB=${FIRST_JOB:-1}
LAST_JOB=${LAST_JOB:-${TOTAL_JOBS}}
startcmd="${RUN_CMD} ${FIRST_JOB} ${LAST_JOB}"
echo $startcmd
($startcmd)
