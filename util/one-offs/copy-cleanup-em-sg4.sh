#!/bin/bash

# copy and cleanup EM-SG4 results (without merge to MCFO)

# global parameters
source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

SG4_DIR="${CDGAS_RESULTS_DIR}/${EM_INPUT}-vs-${SG4_INPUT}"

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    mergeResults \
    -cleanup \
    -rd ${SG4_DIR} \
    -od ${CDS_FINAL_DIR}/flyem-vs-flylight \
