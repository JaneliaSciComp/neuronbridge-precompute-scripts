#!/bin/bash

# merge LM results

# global parameters
source "$(dirname ${BASH_SOURCE[0]})/../vnc-global-cdsparams.sh"

SG4_DIR="${CDGAS_RESULTS_DIR}/${SG4_INPUT}-vs-${EM_INPUT}"
MCFO_DIR="${CDGAS_RESULTS_DIR}/${MCFO_INPUT}-vs-${EM_INPUT}"

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    mergeResults \
    -cleanup \
    -rd ${SG4_DIR} ${MCFO_DIR} \
    -od ${CDS_FINAL_DIR}/flylight-vs-flyem \
