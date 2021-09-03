#!/bin/bash

# merge EM results; just like merge LM results, but flip the mask/lib orders

# global parameters
source "$(dirname ${BASH_SOURCE[0]})/../vnc-global-cdsparams.sh"

SG4_DIR="${CDGAS_RESULTS_DIR}/${EM_INPUT}-vs-${SG4_INPUT}"
MCFO_DIR="${CDGAS_RESULTS_DIR}/${EM_INPUT}-vs-${MCFO_INPUT}"

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    mergeResults \
    -cleanup \
    -rd ${SG4_DIR} ${MCFO_DIR} \
    -od ${CDS_FINAL_DIR}/flyem-vs-flylight \