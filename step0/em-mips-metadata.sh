#!/bin/bash

# generate mips metadata for EM dataset

source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

LIBNAME=flyem_hemibrain_1_1

java -jar ${CDS_JAR} \
    ${JAVA_OPTIONS} \
    groupMIPsByPublishedName \
    --jacsURL ${JACSV2URL} \
    --authorization "Bearer ${JACSTOKEN}" \
    -l ${LIBNAME} \
    --include-mips-without-publishing-name 3 \
    --urls-relative-to 1 \
    -od ${MIPS_DIR} \
    -emdir ${EM_DIR}
