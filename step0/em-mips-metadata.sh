#!/bin/bash

# generate mips metadata for EM dataset

source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

LIBNAME=flyem_hemibrain_1_2_1

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    groupMIPsByPublishedName \
    --jacsURL ${JACSV2URL} \
    --authorization "Bearer ${JACSTOKEN}" \
    -l ${LIBNAME} \
    --include-mips-without-publishing-name 3 \
    --urls-relative-to 1 \
    -od ${MIPS_DIR} \
    -emdir ${EM_DIR}
