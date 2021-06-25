#!/bin/bash

# generate the "publishedNames.txt" file; derived from a code fragment from Cristian

source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

$PUBLISHED_PATH=${WORKING_DIR}/publishedNames.txt

find ${MIPS_DIR}/${EM_DIR} \
    -type f \
    -name "*.json" \
    -printf "%f\n" | sed s/.json// > ${PUBLISHED_PATH}

find ${MIPS_DIR}/${SG4_DIR} \
    -type f \
    -name "*.json" \
    -printf "%f\n" | sed s/.json// >> ${PUBLISHED_PATH}

find ${MIPS_DIR}/${MCFO_DIR} \
    -type f \
    -name "*.json" \
    -printf "%f\n" | sed s/.json// >> ${PUBLISHED_PATH}

# sort/uniquify in place
sort -u -o ${PUBLISHED_PATH} ${PUBLISHED_PATH}

