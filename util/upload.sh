#!/bin/bash

# upload files to AWS S3; requires aws cli to be installed
#   derived from script by Cristian

# comment sections in and out as needed; you probably won't be uploading everything at once

source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

# uploading to dev for external
UPLOAD_BUCKET=s3://janelia-neuronbridge-data-dev
VERSION_FOLDER=v2_3_0

# "echo" for previewing commands
EXEC_CMD=echo
# empty for actually executing them
# EXEC_CMD=


# MIPs metadata uploads

# MCFO lines
$EXEC_CMD aws s3 cp \
    ${WORKING_DIR}/mips/gen1_mcfo_lines \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/by_line --recursive


# NOTE: for this release, we didn't recalc sg4 or EM mips, so we're 
#   uploading them from the v2.2 area

# SplitGAL4 lines and EM bodies:
$EXEC_CMD aws s3 cp \
    /nrs/neuronbridge/v2.2/mips/split_gal4_lines \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/by_line --recursive
$EXEC_CMD aws s3 cp \
    /nrs/neuronbridge/v2.2/mips/em_bodies \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/by_body --recursive

# original commands, if we had uploaded sg4 and em from the usual places:
# $EXEC_CMD aws s3 cp \
#     ${WORKING_DIR}/mips/split_gal4_lines \
#     ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/by_line --recursive
# EM bodies
# $EXEC_CMD aws s3 cp \
#     ${WORKING_DIR}/mips/em_bodies \
#     ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/by_body --recursive

# CDS results
$EXEC_CMD aws s3 cp \
    ${WORKING_DIR}/${CDS_FINAL_SUBDIR}/flylight-vs-flyem \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/cdsresults --recursive
$EXEC_CMD aws s3 cp \
    ${WORKING_DIR}/${CDS_FINAL_SUBDIR}/flyem-vs-flylight \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/cdsresults --recursive

# metadata files
$EXEC_CMD aws s3 cp \
    ${TOP_DIR}/DATA_VERSION-2.3.0 \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/DATA_VERSION
$EXEC_CMD aws s3 cp \
    ${TOP_DIR}/DATA_NOTES-2.3.0.md \
    ${UPLOAD_BUCKET}/${VERSION_FOLDER}/DATA_NOTES.md

# do last; updating this file switchs to new results
$EXEC_CMD aws s3 cp \
    ${TOP_DIR}/paths-2.3.0.json \
    ${UPLOAD_BUCKET}/paths.json
