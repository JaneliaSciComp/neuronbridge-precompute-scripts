#!/bin/bash

# upload files to AWS S3; requires aws cli to be installed
#   derived from script by Cristian

STEP_SUBDIR=cdsresults.final
DATA_DIR=/nrs/neuronbridge/v2.2
UPLOAD_BUCKET=s3://janelia-neuronbridge-data-int
VERSION_FOLDER=v2_2_0

# echo for command preview, empty for actually doing it
EXEC_CMD=echo

# MIPs metadata uploads
# MCFO lines
$EXEC_CMD aws s3 cp \
    ${DATA_DIR}/mips/gen1_mcfo_lines \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/by_line --recursive
# SplitGAL4 lines
$EXEC_CMD aws s3 cp \
    ${DATA_DIR}/mips/split_gal4_lines \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/by_line --recursive
# EM bodies
$EXEC_CMD aws s3 cp \
    ${DATA_DIR}/mips/em_bodies \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/by_body --recursive

# CDS results
$EXEC_CMD aws s3 cp \
    ${DATA_DIR}/${STEP_SUBDIR}/flylight-vs-flyem \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/cdsresults --recursive
$EXEC_CMD aws s3 cp \
    ${DATA_DIR}/${STEP_SUBDIR}/flyem-vs-flylight \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/cdsresults --recursive

# metadata files
$EXEC_CMD aws s3 cp \
    ${DATA_DIR}/DATA_VERSION \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/DATA_VERSION
$EXEC_CMD aws s3 cp \
    ${DATA_DIR}/DATA_NOTES.md \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/DATA_NOTES.md
$EXEC_CMD aws s3 cp \
    ${DATA_DIR}/publishedNames.txt \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/publishedNames.txt

# do last; updating this file switchs to new results
$EXEC_CMD aws s3 cp \
    ${DATA_DIR}/paths.json \
    ${UPLOAD_BUCKET}/paths.json
