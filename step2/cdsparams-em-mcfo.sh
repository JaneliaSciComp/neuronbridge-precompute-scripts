# parameters for step 2, the search: EM (masks) vs MCFO (libraries)

# these parameters are for running on the mouse1/mouse2 servers

# ------------------------------
# the input from the previous step
export MASKS_FILES="${MIPS_DIR}/${EM_INPUT}.json"
export LIBRARIES_FILES="${MIPS_DIR}/${MCFO_INPUT}.json"

# output directories:
export RESULTS_SUBDIR_FOR_MASKS="${EM_INPUT}-vs-${MCFO_INPUT}"
export RESULTS_SUBDIR_FOR_LIBRARIES="${MCFO_INPUT}-vs-${EM_INPUT}"


# log file 
export JOB_LOGPREFIX="${CDSMATCHES_RESULTS_DIR}/logs-em-mcfo/"


# ------------------------------
# on Konrad's big server this time
export CORES_RESOURCE=62
export CPU_RESERVE=1

# MEM_RESOURCE value is the memory in GB available on the host on which this runs
export MEM_RESOURCE=500

# a cache size of 100000 is OK if there are at least 160GB of memory - otherwise set it to 50000 or
# to some other reasonable value based on the available memory
# we don't trust expiration anymore
export MIPS_CACHE_SIZE=100000
export MIPS_CACHE_EXPIRATION=0


# ------------------------------
# job partitioning

# the selection of the number of masks or libraries per job is empirical based on the size of the libraries and/or masks
export MASKS_PER_JOB=5000
export LIBRARIES_PER_JOB=50000
export PROCESSING_PARTITION_SIZE=500

# round up the total numbers because the operations are integer divisions
export JOBS_FOR_LIBRARIES=$((MCFO_COUNT / LIBRARIES_PER_JOB + 1))
export JOBS_FOR_MASKS=$((EM_COUNT / MASKS_PER_JOB + 1))
export TOTAL_JOBS=$((JOBS_FOR_LIBRARIES * JOBS_FOR_MASKS))



# ------------------------------
# job control parameters

# FIRST_JOB and LAST_JOB specify the job range - if not set they default to first and last job respectivelly
FIRST_JOB=7
LAST_JOB=63

# use localRun to run on the host on which the command is invoked or gridRun to invoke it using bsub
RUN_CMD="localRun"

# bsub options, for gridRun
# BSUB_OPTIONS=""
# for example, set cloud queue with a 230 minute time limit:
# BSUB_OPTIONS="-q cloud -W 230"
