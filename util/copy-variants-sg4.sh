#!/bin/bash

# copy split gal 4 variants from zip to their proper place

# global parameters
source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

BASELIBDIR=/nrs/jacs/jacsData/filestore/system/ColorDepthMIPs/JRC2018_Unisex_20x_HR
LIBDIR=${BASELIBDIR}/flylight_split_gal4_published

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    copyMIPSegmentation \
    -i ${MIPS_DIR}/split_gal4-zips.json \
    -variantMappingsearchable_neurons=segmentation \
    -variantMappinggradient=grad \
    -variantMappingzgap=zgap \
    --targetDirectory ${LIBDIR}
