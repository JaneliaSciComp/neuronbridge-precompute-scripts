# parameters for step 3, the gradient adjustment: EM (masks) vs MCFO (libraries)

# these parameters are for running on the mouse1/mouse2 servers


# ------------------------------
# user edited: job partitioning

# TOTAL_FILES is the least number > the number of files containing matches by EM that is divisible by FILES_PER_JOB
# the reason for that is that in bash TOTAL_FILES/FILES_PER_JOB is an integer division and if it does not divide exactly
# we may not process all the files
# so to calculate it `ls ${CDSMATCHES_RESULTS_DIR}/${EM_INPUT}-vs-${MCFO} | wc` then take the least number > the value
# that is divisible by the selected value for FILES_PER_JOB
# the value depends on the CPU and memory resources available on the machine. If running on the grid requesting 20 cores
export TOTAL_FILES=30800
# for split gal4 drivers we can use up to 200 files per job - for MCFO we cannot go higher than 100 since the number of MCFOs
# is much larger
export FILES_PER_JOB=100

export START_FILE_INDEX=0
export TOTAL_JOBS=$(((TOTAL_FILES - START_FILE_INDEX) / FILES_PER_JOB + 1))

# value should be smaller than for searches, perhaps 5-50 (vs 100-500 for searches)
export PROCESSING_PARTITION_SIZE=50

# grad and zgap locations
export GA_PRECOMPUTED_FILES_LOCATION=/nrs/jacs/jacsData/filestore/system/ColorDepthMIPs/JRC2018_Unisex_20x_HR/flylight_gen1_mcfo_published
export CDGA_GRADIENTS_LOCATION=${GA_PRECOMPUTED_FILES_LOCATION}/grad
export CDGA_ZGAP_LOCATION=${GA_PRECOMPUTED_FILES_LOCATION}/zgap
export CDGA_ZGAP_SUFFIX=_RGB20px

# ------------------------------
# the input from the previous step
export MASKS_FILES="${MIPS_DIR}/${EM_INPUT}.json"
export LIBRARIES_FILES="${MIPS_DIR}/${MCFO_INPUT}.json"

# output directories:
export RESULTS_SUBDIR_FOR_MASKS="${EM_INPUT}-vs-${MCFO_INPUT}"
export RESULTS_SUBDIR_FOR_LIBRARIES="${MCFO_INPUT}-vs-${EM_INPUT}"

export CDGA_INPUT_DIR=${CDSMATCHES_RESULTS_DIR}/${RESULTS_SUBDIR_FOR_MASKS}
export CDGA_OUTPUT_DIR=${CDGAS_RESULTS_DIR}/${RESULTS_SUBDIR_FOR_MASKS}

# log file 
export JOB_LOGPREFIX="${CDGAS_RESULTS_DIR}/logs-em-mcfo/"


# ------------------------------
# computer-related numbers for mouse1/2
export CORES_RESOURCE=20
export CPU_RESERVE=1

# MEM_RESOURCE value is the memory in GB available on the host on which this runs
export MEM_RESOURCE=170

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

# bsub options, for gridRun
BSUB_OPTIONS=""
# for example, set cloud queue with a 230 minute time limit:
# BSUB_OPTIONS="-q cloud -W 230"
