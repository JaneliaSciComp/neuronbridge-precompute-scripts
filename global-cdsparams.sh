# global parameters for most or all steps in the workflow

# ------------------------------------------------------------
# global values expected be edited by the user:

# locations
export WORKINGDIR=/nrs/scicompsoft/olbrisd/cdstests/working

CDS_JAR_VERSION="2.7.0"
export CDS_JAR=${WORKINGDIR}/colormipsearch/target/colormipsearch-${CDS_JAR_VERSION}-jar-with-dependencies.jar


# JAVA options

# if needed one can set java runtime like this:
# export JAVA_HOME=${HOME}/tools/jdk-14.0.1
# export JAVA_EXEC=${JAVA_HOME}/bin/java

# likewise, you can add Java options here, eg, for debugging
export JAVA_OPTIONS=""
# export JAVA_OPTIONS="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005"



# ------------------------------------------------------------
# values that describe the data for use in later step; the user will fill these in

# data sizes to be filled in by the user
# TOTAL_MASKS: `grep imageURL ${MIPSDIR}/${EMINPUT} | wc`
export TOTAL_MASKS=44593
# TOTAL_LIBRARIES: `grep imageURL ${MIPSDIR}/${MCFOINPUT} | wc`
export TOTAL_LIBRARIES=7391









# ------------------------------------------------------------
# values below here are not expected to change; they relate to filenames, 
#   directory structure, etc:

# JACS service
JACSV2URL='https://workstation.int.janelia.org/SCSW/JACS2SyncServices/v2'


# directories within WORKINGDIR:
MIPSDIR="${WORKINGDIR}/mips"

# relative subdirectory names
EMDIR="em_bodies"
SPLITGAL4DIR="split_gal4_lines"
MCFODIR="gen1_mcfo_lines"

# filenames

# input json files
EMINPUT="flyem_hemibrain-withDirs.json"
SPLITGAL4INPUT="all_flylight_split_gal4-withDirs.json"
MCFOINPUT="flylight_gen1_mcfo_published-withDirs.json"

