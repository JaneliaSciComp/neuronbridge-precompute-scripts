#!/bin/bash

# merge LM results

# global parameters
source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

# merging can't handle the symlinks I put in alas

# SG4_DIR="${CDGAS_RESULTS_DIR}/${SG4_INPUT}-vs-${EM_INPUT}"
# MCFO_DIR="${CDGAS_RESULTS_DIR}/${MCFO_INPUT}-vs-${EM_INPUT}"
SG4_DIR=/nrs/neuronbridge/v2.2/cdsresults.ga/split_gal4-vs-hemibrain1.2.1/
MCFO_DIR=/nrs/neuronbridge/v2.3.0/brain/cdsresults.ga/mcfo-vs-hemibrain1.2.1/
ANN_MCFO_DIR="${CDGAS_RESULTS_DIR}/${ANN_MCFO_INPUT}-vs-${EM_INPUT_ALT}"


java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    mergeResults \
    -cleanup \
    -rd ${SG4_DIR} ${MCFO_DIR} ${ANN_MCFO_DIR} \
    -od ${CDS_FINAL_DIR}-new/flylight-vs-flyem \
