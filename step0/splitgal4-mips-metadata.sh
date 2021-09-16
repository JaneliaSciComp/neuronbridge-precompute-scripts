#!/bin/bash

# generate mips metadata for the Split Gal4 dataset

source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

LIBNAME=flylight_split_gal4_published
LIBDIR=/nrs/jacs/jacsData/filestore/system/ColorDepthMIPs/JRC2018_Unisex_20x_HR/flylight_split_gal4_published

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    groupMIPsByPublishedName \
    --jacsURL ${JACSV2URL} \
    --authorization "Bearer ${JACSTOKEN}" \
    -l ${LIBNAME} \
    --excluded-libraries flylight_splitgal4_drivers \
    --librariesVariants ${LIBNAME}:searchable_neurons:${LIBDIR}/segmentation \
    --include-mips-without-publishing-name 2 \
    --segmented-image-handling 1 \
    --segmented-mips-variant searchable_neurons \
    --urls-relative-to 1 \
    -od ${MIPS_DIR} \
    -lmdir ${SG4_DIR}
