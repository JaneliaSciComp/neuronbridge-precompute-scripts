#!/bin/bash

# generate the "publishedNames.txt" file; derived from a code fragment from Cristian

source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

find ${MIPS_DIR} \
    -type f \
    -name "*.json" \
    -printf "%f\n" | sed s/.json// | sort -u > ${WORKING_DIR}/publishedNames.txt
