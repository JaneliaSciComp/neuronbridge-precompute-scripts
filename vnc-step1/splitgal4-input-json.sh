#!/bin/bash

# generate input JSON for Split Gal4 dataset

source "$(dirname ${BASH_SOURCE[0]})/../vnc-global-cdsparams.sh"

# library not created yet

LIBNAME=
LIBDIR=/nrs/jacs/jacsData/filestore/system/ColorDepthMIPs/JRC2018_VNC_Unisex_40x_DS/ (libname here)

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    createColorDepthSearchJSONInput \
    --jacsURL ${JACSV2URL} \
    --authorization "Bearer ${JACSTOKEN}" \
    -l ${LIBNAME} \
    # is this needed?
    # --excluded-libraries flylight_splitgal4_drivers \
    # check variants
    # --librariesVariants \
    #     ${LIBNAME}:searchable_neurons:${LIBDIR}/Split_segmented_CDM_G14_06172021.zip \
    #     ${LIBNAME}:gradient:${LIBDIR}/Split_segmented_gradient_06172021.zip \
    #     ${LIBNAME}:zgap:${LIBDIR}/Split_segmented_RGB20px_06172021.zip \
    --include-mips-without-publishing-name 2 \
    --segmented-image-handling 2 \
    --segmented-mips-variant searchable_neurons \
    --segmentation-channel-base 1 \
    --urls-relative-to 1 \
    -od ${MIPS_DIR} \
    --output-filename ${SG4_INPUT}
