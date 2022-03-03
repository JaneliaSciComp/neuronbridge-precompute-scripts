#!/bin/bash

# upload files to AWS S3; requires aws cli to be installed
#   derived from script by Cristian

# comment sections in and out as needed; you probably won't be uploading everything at once

source "$(dirname ${BASH_SOURCE[0]})/../global-cdsparams.sh"

UPLOAD_BUCKET=s3://janelia-neuronbridge-data-prod
VERSION_FOLDER=v2_4_0

# "echo" for previewing commands
EXEC_CMD=echo
# empty for actually executing them
# EXEC_CMD=

# this is going to be messier than it could be, as 

# MIPs metadata uploads
# Cristian merged all the mcfo lines (old gen1 and new annotator)
# MCFO lines
# $EXEC_CMD aws s3 cp \
#     ${WORKING_DIR}/mips/all_mcfo_lines \
#     ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/by_line --recursive
# SplitGAL4 lines, via symlink to older
# $EXEC_CMD aws s3 cp \
#     ${WORKING_DIR}/mips/split_gal4_lines \
#     ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/by_line --recursive
# EM bodies
# $EXEC_CMD aws s3 cp \
#     ${WORKING_DIR}/mips/em_bodies \
#     ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/by_body --recursive

# CDS results
# $EXEC_CMD aws s3 cp \
#     ${WORKING_DIR}/${CDS_FINAL_SUBDIR}/flylight-vs-flyem \
#     ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/cdsresults --recursive
# $EXEC_CMD aws s3 cp \
#     ${WORKING_DIR}/${CDS_FINAL_SUBDIR}/flyem-vs-flylight \
#     ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/cdsresults --recursive

# # metadata files
# $EXEC_CMD aws s3 cp \
#     ${TOP_DIR}/config.json \
#     ${UPLOAD_BUCKET}/${VERSION_FOLDER}/config.json
# $EXEC_CMD aws s3 cp \
#     ${TOP_DIR}/DATA_NOTES.md \
#     ${UPLOAD_BUCKET}/${VERSION_FOLDER}/DATA_NOTES.md

# schemas
# $EXEC_CMD aws s3 cp \
#     ${TOP_DIR}/schemas \
#     ${UPLOAD_BUCKET}/${VERSION_FOLDER}/schemas --recursive

# PPP results
# $EXEC_CMD aws s3 cp \
#     ${WORKING_DIR}/pppresults/flyem-to-flylight.public \
#     ${UPLOAD_BUCKET}/${VERSION_FOLDER}/metadata/pppresults --recursive

# # do last; updating this file switchs to new results
# $EXEC_CMD aws s3 cp \
#     ${TOP_DIR}/current.txt \
#     ${UPLOAD_BUCKET}/current.txt
