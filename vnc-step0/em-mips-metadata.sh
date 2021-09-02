#!/bin/bash

# generate mips metadata for EM dataset

source "$(dirname ${BASH_SOURCE[0]})/../vnc-global-cdsparams.sh"

LIBNAME=flyem_vnc_0_5

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
