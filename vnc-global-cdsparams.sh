# global parameters for most or all steps in the workflow

# ------------------------------------------------------------
# global values expected be edited by the user:

# locations
# the working directory that will holds *everything*, including scripts;
#   vnc subdir is for vnc data only
export WORKING_DIR=/nrs/neuronbridge/v2.2/
export VNC_DIR=${WORKING_DIR}/vnc


# code locations
CDS_JAR_VERSION="2.8.0"
export CDS_JAR=${WORKING_DIR}/colormipsearch/target/colormipsearch-${CDS_JAR_VERSION}-jar-with-dependencies.jar
export SCRIPT_DIR=${WORKING_DIR}/colormipsearch/colormipsearch-tools/src/main/scripts


# JAVA options

# you can add Java options here, eg, for debugging
export JAVA_OPTS=""
# export JAVA_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005"

# if needed one can set the Java runtime like this:
# export JAVA_HOME=${HOME}/tools/jdk-14.0.1
# export JAVA_EXEC=${JAVA_HOME}/bin/java



# ------------------------------------------------------------
# values that describe the data for use in later step; the user will fill these in

# data sizes to be filled in by the user
# EM_COUNT: `grep imageURL ${MIPS_DIR}/${EM_INPUT}.json | wc` (first value)
export EM_COUNT=

# MCFO_COUNT: `grep imageURL ${MIPS_DIR}/${MCFO_INPUT}.json | wc` (first value)
export MCFO_COUNT=

# SG4_COUNT: `grep imageURL ${MIPS_DIR}/${SG4_INPUT} | wc` (first value)
export SG4_COUNT=




# ------------------------------------------------------------
# values below here are not expected to change; in general, do not edit!
# ------------------------------------------------------------


# ------------------------------------------------------------
# directory and filenames:

# JACS service
JACSV2URL='https://workstation.int.janelia.org/SCSW/JACS2SyncServices/v2'


# directories within VNC_DIR:
export MIPS_DIR="${VNC_DIR}/mips"

# relative subdirectory names
EM_DIR="em_bodies"
SG4_DIR="split_gal4_lines"
MCFO_DIR="gen1_mcfo_lines"

# filenames

# input json files (.json suffix will be added)
EM_INPUT="vnc"
SG4_INPUT="split_gal4"
MCFO_INPUT="mcfo"

# search output directory
CDSMATCHES_SUBDIR=cdsresults.matches
export CDSMATCHES_RESULTS_DIR=${VNC_DIR}/${CDSMATCHES_SUBDIR}

# gradient score directory
CDSGA_SUBDIR=cdsresults.ga
export CDGAS_RESULTS_DIR=${VNC_DIR}/${CDSGA_SUBDIR}

# final results directory
CDS_FINAL_SUBDIR=cdsresults.final
export CDS_FINAL_DIR=${VNC_DIR}/${CDS_FINAL_SUBDIR}


# ------------------------------------------------------------
# cluster info
export CLUSTER_PROJECT_CODE="neuronbridge"


# ------------------------------------------------------------
# processing details

# Color depth search params
export MASK_THRESHOLD=20
export DATA_THRESHOLD=20
export XY_SHIFT=2
export PIX_FLUCTUATION=1
export PIX_PCT_MATCH=1

# this specifies the number of lines to select for gradient scoring.
export TOP_RESULTS=300
export SAMPLES_PER_LINE=0

