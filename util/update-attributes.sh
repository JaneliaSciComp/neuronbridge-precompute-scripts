#!/bin/bash

# update attributes: if you need to update attributes in any kind of search results file,
#   but you don't need to rerun the searches (eg, for image URLs used for display on the site 
#   only), use this script; the correct attributes should be in the aggregate json file
#   produced by step 1 (the -attrs input); the output does not overwrite the input

# this script will likely be edited for each case where it is needed; all the 
#   usual location variables are available for use; note that the fileds names 
#   must match the fields in the json files; multiple fields are space separated

source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"


java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    replaceAttributes \
    -attrs ${MIPS_DIR}/${MCFO_INPUT}.json \
    --input-dirs ${CDGAS_RESULTS_DIR}/${EM_INPUT}-vs-${MCFO_INPUT} \
    --id-field imageName  \
    --fields-toUpdate imageURL thumbnailURL searchablePNG \
    -od ${CDGAS_RESULTS_DIR}/${EM_INPUT}-vs-${MCFO_INPUT}-updated
