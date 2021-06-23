#!/bin/bash

# copy and cleanup SG4-EM results (without merge to MCFO)

# global parameters
source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

SG4_DIR="${CDGAS_RESULTS_DIR}/${SG4_INPUT}-vs-${EM_INPUT}"

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    mergeResults \
    -cleanup \
    -rd ${SG4_DIR} \
    -od ${CDS_FINAL_DIR}/flylight-vs-flyem \
