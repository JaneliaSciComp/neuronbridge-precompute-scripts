#!/bin/bash

# merge EM results; just like merge LM results, but flip the mask/lib orders

# global parameters
source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

# merging can't handle the symlinks I put in alas

# SG4_DIR="${CDGAS_RESULTS_DIR}/${EM_INPUT}-vs-${SG4_INPUT}"
# MCFO_DIR="${CDGAS_RESULTS_DIR}/${EM_INPUT}-vs-${MCFO_INPUT}"
SG4_DIR=/nrs/neuronbridge/v2.2/cdsresults.ga/hemibrain1.2.1-vs-split_gal4/
MCFO_DIR=/nrs/neuronbridge/v2.3.0/brain/cdsresults.ga/hemibrain1.2.1-vs-mcfo/
ANN_MCFO_DIR="${CDGAS_RESULTS_DIR}/${EM_INPUT_ALT}-vs-${ANN_MCFO_INPUT}"

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    mergeResults \
    -cleanup \
    -rd ${SG4_DIR} ${MCFO_DIR} ${ANN_MCFO_DIR} \
    -od ${CDS_FINAL_DIR}-new/flyem-vs-flylight \
