#!/bin/bash

# generate input JSON for MCFO dataset

source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

LIBNAME=flylight_gen1_mcfo_published
BASELIBDIR=/nrs/jacs/jacsData/filestore/system/ColorDepthMIPs/JRC2018_Unisex_20x_HR
# LIBDIR=${BASELIBDIR}/flylight_gen1_mcfo_published
LIBDIR=/nrs/scicompsoft/emlm/public_release_2021

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    createColorDepthSearchJSONInput \
    --jacsURL ${JACSV2URL} \
    --authorization "Bearer ${JACSTOKEN}" \
    -l ${LIBNAME} \
    --librariesVariants \
        ${LIBNAME}:searchable_neurons:${LIBDIR}/40x_MCFO_segmented_2021_04_CDM.zip \
        ${LIBNAME}:gradient:${LIBDIR}/40xMCFO_segmented_2021_04_gradient_20px.zip \
        ${LIBNAME}:zgap:${LIBDIR}/40x_MCFO_segmented_2021_04_RGB20px.zip \
        ${LIBNAME}:gamma1_4:${LIBDIR}/40x_MCFO_release_gamma14_2021_05.zip \
    --include-mips-without-publishing-name 2 \
    --segmented-image-handling 2 \
    --segmented-mips-variant searchable_neurons \
    --segmentation-channel-base 1 \
    --urls-relative-to 1 \
    -od ${MIPS_DIR} \
    --output-filename ${MCFO_INPUT}-zips
