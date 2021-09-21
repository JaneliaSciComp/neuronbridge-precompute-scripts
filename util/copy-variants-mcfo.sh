#!/bin/bash

# copy mcfo variants from zip to their proper place

# global parameters
source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

BASELIBDIR=/nrs/jacs/jacsData/filestore/system/ColorDepthMIPs/JRC2018_Unisex_20x_HR
LIBDIR=${BASELIBDIR}/flylight_gen1_mcfo_published

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    copyMIPSegmentation \
    -i ${MIPS_DIR}/mcfo-zips.json \
    -variantMappingsearchable_neurons=segmentation \
    -variantMappinggradient=grad \
    -variantMappingzgap=zgap \
    -variantMappinggamma1_4=gamma1_4 \
    --targetDirectory ${LIBDIR}
