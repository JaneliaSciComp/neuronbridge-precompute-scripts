# global parameters for most or all steps in the workflow

# ------------------------------------------------------------
# global values expected be edited by the user:

# locations
# the working directory that will hold *everything*:
export WORKING_DIR=/nrs/scicompsoft/olbrisd/cdstests/working

# code locations
CDS_JAR_VERSION="2.7.0"
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
# TOTAL_MASKS: `grep imageURL ${MIPS_DIR}/${EM_INPUT} | wc`
export TOTAL_MASKS=44593
# TOTAL_LIBRARIES: `grep imageURL ${MIPS_DIR}/${MCFO_INPUT} | wc`
# ? sum with sg4 lines?

export TOTAL_LIBRARIES=7391




# ------------------------------------------------------------
# job partitioning

# these are chosen empirically
export MASKS_PER_JOB=44593
export LIBRARIES_PER_JOB=7391







# ------------------------------------------------------------
# values below here are not expected to change; they relate to filenames, 
#   directory structure, etc:

# JACS service
JACSV2URL='https://workstation.int.janelia.org/SCSW/JACS2SyncServices/v2'


# directories within WORKING_DIR:
MIPS_DIR="${WORKING_DIR}/mips"

# relative subdirectory names
EM_DIR="em_bodies"
SG4_DIR="split_gal4_lines"
MCFO_DIR="gen1_mcfo_lines"

# filenames

# input json files (.json suffix will be added)
EM_INPUT="flyem_hemibrain-withDirs"
SG4_INPUT="all_flylight_split_gal4-withDirs"
MCFO_INPUT="flylight_gen1_mcfo_published-withDirs"

