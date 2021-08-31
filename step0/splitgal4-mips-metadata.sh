#!/bin/bash

# generate mips metadata for the Split Gal4 dataset

source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

LIBNAME=flylight_split_gal4_published
LIBDIR=/nrs/scicompsoft/emlm/public_release_2021

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    groupMIPsByPublishedName \
    --jacsURL ${JACSV2URL} \
    --authorization "Bearer ${JACSTOKEN}" \
    -l ${LIBNAME} \
    --excluded-libraries flylight_splitgal4_drivers \
    --librariesVariants ${LIBNAME}:searchable_neurons:${LIBDIR}/Split_segmented_CDM_G14_06172021.zip \
    --include-mips-without-publishing-name 2 \
    --segmented-image-handling 1 \
    --segmented-mips-variant searchable_neurons \
    --urls-relative-to 1 \
    -od ${MIPS_DIR} \
    -lmdir ${SG4_DIR}
