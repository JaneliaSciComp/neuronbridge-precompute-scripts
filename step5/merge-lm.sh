#!/bin/bash

# merge LM results

# global parameters
source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

# this merge is a little different; we only recalculated the MCFO, so we'll
#   merge in the SG4 from v2.2
SG4_DIR=/nrs/neuronbridge/v2.2/cdsresults.ga/split_gal4-vs-hemibrain1.2.1
# SG4_DIR="${CDGAS_RESULTS_DIR}/${SG4_INPUT}-vs-${EM_INPUT}"
MCFO_DIR="${CDGAS_RESULTS_DIR}/${MCFO_INPUT}-vs-${EM_INPUT}"

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    mergeResults \
    -cleanup \
    -rd ${SG4_DIR} ${MCFO_DIR} \
    -od ${CDS_FINAL_DIR}/flylight-vs-flyem \
