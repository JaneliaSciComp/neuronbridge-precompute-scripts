# parameters for step 4, the reverse gradient adjustment: EM vs Split Gal 4

# these parameters are for running on the imagecatcher server


# ------------------------------
# same job partitioning as for step 3; source that params file for those value,
#   then update the rest of the variables belos

# if you need to adjust, copy the "job partition" section from that file
#   and update it here, and do not source it

source "$(dirname ${BASH_SOURCE[0]})/../vnc-step3/cdsparams-em-sg4.sh"


# ------------------------------
# the input from the previous step
export MASKS_FILES="${MIPS_DIR}/${EM_INPUT}.json"
export LIBRARIES_FILES="${MIPS_DIR}/${SG4_INPUT}.json"

# output directories:
export RESULTS_SUBDIR_FOR_MASKS="${EM_INPUT}-vs-${SG4_INPUT}"
export RESULTS_SUBDIR_FOR_LIBRARIES="${SG4_INPUT}-vs-${EM_INPUT}"

# note this is the lib subdirs (compare step 3, which was mask subdir)
export CDGA_INPUT_DIR=${CDSMATCHES_RESULTS_DIR}/${RESULTS_SUBDIR_FOR_LIBRARIES}
export CDGA_OUTPUT_DIR=${CDGAS_RESULTS_DIR}/${RESULTS_SUBDIR_FOR_LIBRARIES}


# log file; note reversed mask/lib order
export JOB_LOGPREFIX="${CDGAS_RESULTS_DIR}/logs-sg4-em/"


# ------------------------------
# computer-related numbers for imagecatcher
export CORES_RESOURCE=14
export CPU_RESERVE=1

# MEM_RESOURCE value is the memory in GB available on the host on which this runs
export MEM_RESOURCE=460

# a cache size of 100000 is OK if there are at least 160GB of memory - otherwise set it to 50000 or
# to some other reasonable value based on the available memory
export MIPS_CACHE_SIZE=100000
export MIPS_CACHE_EXPIRATION=60


# ------------------------------
# job control parameters

# FIRST_JOB and LAST_JOB specify the job range - if not set they default to first and last job respectivelly
# FIRST_JOB=1
# LAST_JOB=1

# use localRun to run on the host on which the command is invoked or gridRun to invoke it using bsub
RUN_CMD="localRun"
