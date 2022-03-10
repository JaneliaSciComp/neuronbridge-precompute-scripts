#!/bin/bash

# generate schemas for upload

source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

java ${JAVA_OPTS} \
    -jar ${CDS_JAR} \
    schemas \
    -od ${TOP_DIR} \
    --schemas-directory schemas-test