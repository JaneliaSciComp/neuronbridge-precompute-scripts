#!/bin/bash

# generate mips metadata for the MCFO dataset

source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

LIBNAME=flylight_gen1_mcfo_published
LIBDIR=/nrs/jacs/jacsData/filestore/system/ColorDepthMIPs/JRC2018_Unisex_20x_HR/flylight_gen1_mcfo_published

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    groupMIPsByPublishedName \
    --jacsURL ${JACSV2URL} \
    --authorization "Bearer ${JACSTOKEN}" \
    -l ${LIBNAME} \
    --librariesVariants ${LIBNAME}:searchable_neurons:${LIBDIR}/segmentation \
    --include-mips-without-publishing-name 2 \
    --segmented-image-handling 1 \
    --segmented-mips-variant searchable_neurons \
    --urls-relative-to 1 \
    -od ${MIPS_DIR} \
    -lmdir ${MCFO_DIR}

