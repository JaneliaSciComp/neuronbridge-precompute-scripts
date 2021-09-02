#!/bin/bash

# generate mips metadata for the Split Gal4 dataset

source "$(dirname ${BASH_SOURCE[0]})/../vnc-global-cdsparams.sh"

# library not created yet

LIBNAME=
LIBDIR=/nrs/jacs/jacsData/filestore/system/ColorDepthMIPs/JRC2018_VNC_Unisex_40x_DS/ (libname here)

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    groupMIPsByPublishedName \
    --jacsURL ${JACSV2URL} \
    --authorization "Bearer ${JACSTOKEN}" \
    -l ${LIBNAME} \
    # need excluded libs?
    # --excluded-libraries flylight_splitgal4_drivers \
    # check variant exists
    # --librariesVariants ${LIBNAME}:searchable_neurons:${LIBDIR}/Split_segmented_CDM_G14_06172021.zip \
    --include-mips-without-publishing-name 2 \
    --segmented-image-handling 1 \
    --segmented-mips-variant searchable_neurons \
    --urls-relative-to 1 \
    -od ${MIPS_DIR} \
    -lmdir ${SG4_DIR}
