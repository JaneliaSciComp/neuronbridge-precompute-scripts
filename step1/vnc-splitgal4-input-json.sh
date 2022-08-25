#!/bin/bash

# generate input JSON for sg4 vnc dataset

source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

LIBNAME=flylight_split_gal4_published
BASELIBDIR=/nrs/jacs/jacsData/filestore/system/ColorDepthMIPs/JRC2018_VNC_Unisex_40x_DS
LIBDIR=${BASELIBDIR}/flylight_split_gal4_published
# not adjusted below here

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    createColorDepthSearchJSONInput \
    --jacsURL ${JACSV2URL} \
    --authorization "Bearer ${JACSTOKEN}" \
    -l ${LIBNAME} \
    --librariesVariants \
    ${LIBNAME}:searchable_neurons:${LIBDIR}/segmentation:_CDM \
    ${LIBNAME}:gradient:${LIBDIR}/grad:_gradient \
    ${LIBNAME}:zgap:${LIBDIR}/zgap:_RGB20px \
    --include-mips-without-publishing-name 2 \
    --segmented-image-handling 2 \
    --segmented-mips-variant searchable_neurons \
    --segmentation-channel-base 1 \
    --urls-relative-to 1 \
    -od ${MIPS_DIR} \
    --output-filename ${VNC_SG4_INPUT}
