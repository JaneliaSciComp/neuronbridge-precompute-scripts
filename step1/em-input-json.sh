#!/bin/bash

# generate input JSON for EM dataset

source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

LIBNAME=flyem_hemibrain_1_1
LIBDIR=/nrs/jacs/jacsData/filestore/system/ColorDepthMIPs/JRC2018_Unisex_20x_HR/flyem_hemibrain_1_1

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    createColorDepthSearchJSONInput \
    --jacsURL ${JACSV2URL} \
    --authorization "Bearer ${JACSTOKEN}" \
    -l ${LIBNAME} \
    --librariesVariants \
    ${LIBNAME}:searchable_neurons:${LIBDIR}/cdm \
    ${LIBNAME}:gradient:${LIBDIR}/grad \
    ${LIBNAME}:zgap:${LIBDIR}/zgap \
    --include-mips-without-publishing-name 3 \
    --segmented-image-handling 2 \
    --segmented-mips-variant searchable_neurons \
    --urls-relative-to 1 \
    -od ${MIPS_DIR} \
    --output-filename ${EM_INPUT}
