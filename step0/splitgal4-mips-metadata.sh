# generate mips metadata for the Split Gal4 dataset

source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

LIBNAME1=flylight_split_gal4_published
LIBDIR1=/nrs/jacs/jacsData/filestore/system/ColorDepthMIPs/JRC2018_Unisex_20x_HR/flylight_split_gal4_published

java -jar ${CDS_JAR} \
    ${JAVA_OPTIONS} \
    groupMIPsByPublishedName \
    --jacsURL ${JACSV2URL} \
    --authorization "Bearer ${JACSTOKEN}" \
    -l ${LIBNAME1} \
    --librariesVariants ${LIBNAME1}:searchable_neurons:${LIBDIR1}/segmentation \
    --include-mips-without-publishing-name 2 \
    --segmented-image-handling 1 \
    --segmented-mips-variant searchable_neurons \
    --urls-relative-to 1 \
    -od ${MIPS_DIR} \
    -lmdir ${SG4_DIR}


LIBNAME2=flylight_splitgal4_drivers
LIBDIR2=/nrs/jacs/jacsData/filestore/system/ColorDepthMIPs/JRC2018_Unisex_20x_HR/flylight_split_gal4_published

java -jar ${CDS_JAR} \
    ${JAVA_OPTIONS} \
    groupMIPsByPublishedName \
    --jacsURL ${JACSV2URL} \
    --authorization "Bearer ${JACSTOKEN}" \
    -l ${LIBNAME2} \
    --librariesVariants ${LIBNAME2}:searchable_neurons:${LIBDIR2}/segmentation \
    --include-mips-without-publishing-name 2 \
    --segmented-image-handling 1 \
    --segmented-mips-variant searchable_neurons \
    --excluded-libraries flylight_split_gal4_published \
    --urls-relative-to 1 \
    -od ${MIPS_DIR} \
    -lmdir ${SG4_DIR}

