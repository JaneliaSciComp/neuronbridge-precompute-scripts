#!/bin/bash

# generate input JSON for Split Gal4 dataset

source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

LIBNAME=flylight_split_gal4_published
LIBDIR=/nrs/jacs/jacsData/filestore/system/ColorDepthMIPs/JRC2018_Unisex_20x_HR/flylight_split_gal4_published

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    createColorDepthSearchJSONInput \
    --jacsURL ${JACSV2URL} \
    --authorization "Bearer ${JACSTOKEN}" \
    -l ${LIBNAME} \
    --librariesVariants \
    ${LIBNAME}:searchable_neurons:${LIBDIR}/segmentation \
    ${LIBNAME}:gradient:${LIBDIR}/grad \
    ${LIBNAME}:zgap:${LIBDIR}/zgap \
    ${LIBNAME}:gamma1_4:${LIBDIR}/gamma1_4 \
    --include-mips-without-publishing-name 2 \
    --segmented-image-handling 2 \
    --segmented-mips-variant searchable_neurons \
    --segmentation-channel-base 1 \
    --urls-relative-to 1 \
    -od ${MIPS_DIR} \
    --output-filename ${SG4_INPUT}
