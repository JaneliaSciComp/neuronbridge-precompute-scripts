#!/bin/bash

# merge EM results; just like merge LM results, but flip the mask/lib orders

# global parameters
source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

# this merge is a little different; we only recalculated the MCFO, so we'll
#   merge in the SG4 from v2.2
SG4_DIR=/nrs/neuronbridge/v2.2/cdsresults.ga/hemibrain1.2.1-vs-split_gal4
# SG4_DIR="${CDGAS_RESULTS_DIR}/${EM_INPUT}-vs-${SG4_INPUT}"
MCFO_DIR="${CDGAS_RESULTS_DIR}/${EM_INPUT}-vs-${MCFO_INPUT}"

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    mergeResults \
    -cleanup \
    -rd ${SG4_DIR} ${MCFO_DIR} \
    -od ${CDS_FINAL_DIR}/flyem-vs-flylight \
