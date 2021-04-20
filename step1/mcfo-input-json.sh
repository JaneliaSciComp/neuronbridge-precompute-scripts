# generate input JSON for MCFO dataset

source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

LIBNAME=flylight_gen1_mcfo_published
BASELIBDIR=/nrs/jacs/jacsData/filestore/system/ColorDepthMIPs/JRC2018_Unisex_20x_HR
LIBDIR=${BASELIBDIR}/flylight_gen1_mcfo_published

java -jar ${CDS_JAR} \
    ${JAVA_OPTIONS} \
    createColorDepthSearchJSONInput \
    --jacsURL ${JACSV2URL} \
    --authorization "Bearer ${JACSTOKEN}" \
    -l ${LIBNAME} \
    --librariesVariants \
    ${LIBNAME}:searchable_neurons:${LIBDIR}/segmentation:_CDM \
    ${LIBNAME}:gradient:${LIBDIR}/grad:_gradient \
    ${LIBNAME}:zgap:${LIBDIR}/zgap:_RGB20px \
    ${LIBNAME}:gamma1_4:${BASELIBDIR}/flylight_gen1_mcfo_case_1/gamma1_4:-gamma1_4_CDM \
    --include-mips-without-publishing-name 2 \
    --segmented-image-handling 2 \
    --segmented-mips-variant searchable_neurons \
    --segmentation-channel-base 1 \
    --urls-relative-to 1 \
    -od ${MIPS_DIR} \
    --output-filename ${MCFO_INPUT}
