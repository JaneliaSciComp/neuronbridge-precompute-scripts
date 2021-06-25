#!/bin/bash

# upload files to AWS S3; requires aws cli to be installed
#   derived from script by Cristian

# comment sections in and out as needed; you probably won't be uploading everything at once

source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

UPLOAD_BUCKET=s3://janelia-neuronbridge-data-int
VERSION_FOLDER=v2_2_0

# "echo" for previewing commands
EXEC_CMD=echo
# empty for actually executing them
# EXEC_CMD=


# MIPs metadata uploads
# MCFO lines
$EXEC_CMD aws s3 cp \
    ${WORKING_DIR}/mips/gen1_mcfo_lines \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/by_line --recursive
# SplitGAL4 lines
$EXEC_CMD aws s3 cp \
    ${WORKING_DIR}/mips/split_gal4_lines \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/by_line --recursive
# EM bodies
$EXEC_CMD aws s3 cp \
    ${WORKING_DIR}/mips/em_bodies \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/by_body --recursive

# CDS results
$EXEC_CMD aws s3 cp \
    ${WORKING_DIR}/${CDS_FINAL_SUBDIR}/flylight-vs-flyem \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/cdsresults --recursive
$EXEC_CMD aws s3 cp \
    ${WORKING_DIR}/${CDS_FINAL_SUBDIR}/flyem-vs-flylight \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/cdsresults --recursive

# metadata files
$EXEC_CMD aws s3 cp \
    ${WORKING_DIR}/DATA_VERSION \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/DATA_VERSION
$EXEC_CMD aws s3 cp \
    ${WORKING_DIR}/DATA_NOTES.md \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/DATA_NOTES.md
$EXEC_CMD aws s3 cp \
    ${WORKING_DIR}/publishedNames.txt \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/publishedNames.txt

# do last; updating this file switchs to new results
$EXEC_CMD aws s3 cp \
    ${WORKING_DIR}/paths.json \
    ${UPLOAD_BUCKET}/paths.json
