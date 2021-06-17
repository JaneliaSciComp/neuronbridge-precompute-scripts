# colormipsearch-scripts

This repo contains scripts for running distributed color MIP mask searches as implemented in https://github.com/JaneliaSciComp/colormipsearch.

This repository is meant to record Janelia-specific operational knowledge and record how data for NeuronBridge was actually run. As such, it is:

- private; appropriate for Janelia only
- assumes/imposes a specific directory structure
- reproducible; every detail except authentication secrets should appear in this repo
    + so no secret auxiliary scripts that fix things "just this once"; if you need to do something, include the script
    + changeable details should be isolated and centralized, however
- historical; use tags and/or branches as needed so what was actually run can be frozen while allowing future runs to have different details

**NOTE** This is a work in progress. Obviously going to have to renumber the steps.


# Directory structure

All the computed data as well as the running code and scripts will be kept in one working directory.

```
workingdir/
    colormipsearch/
        target/ jar file
        src/stuff/scripts
    colormipsearch-scripts/
        stuff
    mips/
    (etc)

```


# Setup, prerequisites, general notes

Prerequisites:
- color depth MIPs must be uploaded to the workstation (see section below)
- user needs JACS auth
    + see https://wiki.int.janelia.org/wiki/display/JW/Authentication+Service
    + you will need to obtain a token and have it available in the JACSTOKEN environment variable for some steps
    + note that they expire in 24 hours
    + there's a helper script in this repository that will prompt for a password and output the retrieved token
        * it's a Python script that requires third-party "requests" library installed
        * usage: `export JACSTOKEN=$(util/get-jacs-token.py)`
        * note that the password prompt and any warnings will not be captured in the variable
- user needs AWS auth
- the working directory should have enough disk space (3T+)
- user needs access to servers: mouse1, mouse2, imagecatcher
- cluster access optional

Setup:
- create your working directory and clone two repos into it
- build the colormipsearch project
    + jar will end up in the target/ subdirectory
- edit global parameters file, mandatory:
    + WORKING_DIR
    + CDS_JAR_VERSION
- edit global parameters file, optional/as needed:
    + JAVA runtime variables and options
    + (?) input file names ([EM|SG4|MCFO]_INPUT)

General notes:
- adjust Java paths and parameters in the global parameters file
    + note you can enable/disable debugging here, for example
- the datasets vary quite a bit in size; when you run the same command over the EM or any of the LM datasets, the running time and disk space of the output may vary by an order of magnitude
    + generally Split Gal4 is by far the smallest, with EM much larger, and MCFO the largest

git for recording history:

The intention is that the user will edit various cdparams files as the workflow is run, but that _no value will be edited after it is used._ If so, it needs to be split into a new cdparams files (like the others)! Likewise, if any auxiliary scripts need to be run in order to fix or adjust things, they should appear as run somewhere in the directory structure (with notes, please). Then, once the workflow is done, the whole repo will contain the history of how it was run. To that end:

- at the outset, after cloning, create and checkout a branch of colormipsearch-scripts with a good descriptive name for this iteration
- do not edit anything (scripts or parameters) after it's been used
- commit all changes and all extra scripts etc. that were needed
- when done, commit and push the branch
- switch back to main
- as needed, merge improvements back to main from the branch

# Loading color depth MIPs into JACS

- the color depth MIPs are organized into libraries in JACS; they can be viewed in the Janelia Workstation
    + folder = "Color Depth Libraries"
    + subfolder = library, eg "flyem_hemibrain_1_2_1"
    + subsubfolder = alignment space, eg "JRC2018_Unisex_20x_HR"
- first, the library needs to exist in the config server http://config.int.janelia.org/config/cdm_library
    + API is here: https://github.com/JaneliaSciComp/Centralized_Config
    + Rob Svirskas can do this
- stored on disk here: /nrs/jacs/jacsData/filestore/system/ColorDepthMIPs/
    + again, subdir = alignment space
- create a subdirectory in the appropate alignment space with the library's identifier
- copy files into directory (EM version):
    + in that new directory, create emdataset.json file:
    {
        "name": "hemibrain",
        "version": "1.2.1"
    }
        * name and version must match corresponding entry in Fly EM Datasets in jacs
    + unzip files (from Hideo, usually, from /nrs/scicompsoft/emlm/public_release_(dates))
        * filenames should tell you which archives hold which variants
        * variants go in subdirectories
        * "CDM_PackBits" are the actual cdms ("cdm" variant)
        * "20pxRGB" = "zgap" variant
        * gradiants = "grad" variant
        * some archives might have more than one variant within
- copy files into directory (LM version):
    + (to be filled in)
- adjust ownership & permissions:
    + (you)/scicompsoft works, as does jacs/jacsdata
    + ug+rw, o+r
        * I suspect write access isn't needed for running it, but
    is useful to let other people clean up stuff if needed
- wait for synchronization process to run; can take a day
    + sync process logs: on jacs2 server, /opt/servers/jacs2/undertow/asyncweb/logs/jacs.log
- you can check results in the workstation
    + right-click to open the library/alignment space folder in a viewer
    + single-click images to check attributes in the Data Inspector



# Running the workflow

- Run each step in sequence. If a step has multiple scripts within a folder, order doesn't matter.

## Workflow overview

Step | Command | Memory | Parallel? | Computer | Running time
---- | ------- | ------ | --------- | -------- | ------------ 
Step 0: Generate MIPs metadata | `groupMIPsByPublishedName` |  |  |  |  several minutes
Step 1: Prepare LM and EM JSON input | `createColorDepthSearchJSONInput` |  |  |  | < 1 hour
Step 1': Replace image URLs (?) | `replaceAttributes` | | | | minutes (?)
Step 2: Compute color depth matches | `searchFromJSON` |  | :white_check_mark: | mouse1, mouse2  | several hours
Step 3: Calculate gradient score | `gradientScore` | 180G+  | :white_check_mark: | mouse1,2 | days to a week          
Step 4: Update the gradient score | `gradientScoresFromMatchedResults` | 480G | | imagecatcher | hours            
Step 5: Merge flyem results | `mergeResults` | | | | minutes          
Step 6: Normalize and rank results | `normalizeScores` | | | | minutes       
Step 7: Upload to AWS S3 | n/a | | | | hour

## Computational resources

Computer | CPU | Memory | AWS CLI? | Notes
-------- | --- | ------ | -------- | -----
mouse1, mouse2 | 40 | 192G |  | used for parallel jobs (ie, needing lots of individual CPUs)
imagecatcher | 28 | 500G | :white_check_mark: | used for high-memory jobs
c13u05 (aka nextflow) | 40 | 128G |  |
personal workstations |  |  |  | can be used for low resource jobs
cluster |  |  |  | can be used for parallel jobs if time critical and budget available

## Step 0: generate MIPs metadata

**Run:**
- authentication token into JACSTOKEN variable
- execute the following scripts 
    + from any location
    + in any order
    + on any computer
    + `step0/em-mips-metadata.sh`
    + `step0/splitgal4-mips-metadata.sh`
    + `step0/mcfo-mips-metadata.sh`

**Expected output:**
- expected numbers as of April 2021
- files and directories created:
```
    working/mips
        /em_bodies
            ~30k json files
        /split_gal4_lines
            ~600 json files
        /gen1_mcfo_lines
            ~5k json files
```
- each json file is small, most <= 10kb

## Step 1: create JSON input files

**Run:**
- authentication token into JACSTOKEN variable
- execute the following scripts 
    + from any location
    + in any order
    + on any computer
    + `step1/em-input-json.sh`
    + `step1/splitgal4-input-json.sh`
    + `step1/mcfo-input-json.sh`

**Expected output:**
- files created:
```
    working/mips
        flyem_hemibrain-withDirs.json
        all_flylight_split_gal4-withDirs.json
        flylight_gen1_mcfo_published-withDirs.json
```
- filenames may vary; they are specified in `global-cdsparams.sh` as `EM_INPUT` etc.
- each json file is mid-sized, ~5-500Mb


## maybe image URL update step?

Not sure if this step needs to be done at present. Or maybe this is what I am talking about below, that will get fixed if we just rerun step 1?


## Step 1.5: Rob uploads images to S3

Rob Svirskas will upload images to S3 and post their URLs to JACS.

- in /groups/scicompsoft/informatics/data/release_libraries, create subdir with data version name
- copy json files from step 1 to that new dir and let Rob know

Notes:
- the right order to do things is not clear to me yet
- "imageURL" and "thumbnailURL" attributes will be empty before Rob gets them into JACS
- but we need those to be populated later, in both the MIPs metadata files and the input files!
- so I suspect the right order is:
    + do step 1 ("imageURL" empty)
    + let Rob do uploads
    + do step 0 and step 1 (again) ("imageURL" should be picked up from db)
- once populated, those fields ought to be carried along to the end results json files
    + I am *fairly* sure of that; I don't believe any subsequent step goes back to the db for those values and fills them in later


## Step 2: Compute color depth matches

### Count data input

Determine the number of masks and libraries found in step 1. Edit `global-cdsparams.sh` with the results of these commands:
- `source global-cdsparams.sh` (to populate the variables used below)
- edit `EM_COUNT` to `grep imageURL ${MIPSDIR}/${EMINPUT}.json | wc` (first value)
- edit `MCFO_COUNT` to `grep imageURL ${MIPSDIR}/${MCFOINPUT}.json | wc` (first value)
- edit `SG4_COUNT`: `grep imageURL ${MIPS_DIR}/${SG4_INPUT}.json | wc` (first value)

You should not need to edit any of the job partitioning numbers. They are in `step2-cdsparams-em-sg4.sh` and `step-cdparams-em-mcfo.sh` if you do.

### Perform searches

This step is done in parallel. Normally it's done on SciComp servers, but if there is budget and a need for speed, it can be run on the cluster. There's code in place for that, but it hasn't been used or tested much. In particular, billing control seems to be absent.

The mouse1 and mouse2 servers are appropriate for this step, as they have a lot of CPUs and adequate memory. The work is batched into sequential jobs, and each job runs multiple work threads.

**Run:**
- on mouse1/2
- from anywhere, any order, etc.
- `step2/submit-em-sg4.sh`
- `step2/submit-em-mcfo.sh`

**Expected output:**
- files created:
```
    working/cdsresults.matches
        for each mask/library M/L pair:
            M-vs-L/ and L-vs-M/ directories, containing json results files
            log-M-L/ directory with search logs (M and L abbreviated here)
            mask-M-inputs-L-cdsParameters.json parameter file
```


## Step 3: Calculate gradient score for the EM to LM color depth matches

### Count results files

Determine the number of search results files found in step 2. Edit `step3/cdsparams-em-sg4.sh` with the results of these commands:
- `source global-cdsparams.sh`
- count number of results files: `ls ${CDSMATCHES_RESULTS_DIR}/${SG4_INPUT}-vs-${EM_INPUT} | wc`
- for running on mouse[12], leave `FILES_PER_JOB=200`
- set `TOTAL_FILES` to the smallest multiple of `FILES_PER_JOB` that is greater or equal to the number of results files found above
    + eg, if # results = 1234 and `FILES_PER_JOB` is 200, choose 1400

Repeat for MCFO.

### Perform gradient scoring 

As with step 2, this step is done in parallel, usually run on SciComp servers. All the above comments apply.

**Run:**
- on mouse1/2
- from anywhere, any order, etc.
- `step3/submit-em-sg4.sh`
- `step3/submit-em-mcfo.sh`

**Expected output:**
- files created:
```
    working/cdsresults.ga
        for each mask/library M/L pair:
            M-vs-L/ directory, containing json results files
            log-M-L/ directory with search logs (M and L abbreviated again)
```


## Step 4: Compute reverse gradient scores

This step basically reverses step 3 (masks <--> libraries). Note:

- it shares the job partitioning from step 3; no user parameters to update
    + although you can if you need to; copy the appropriate variables from the parameters file and update them
- needs to be run on high memory machine

### Perform reverse gradient scroing

**Run:**
- on imagecatcher
- from anywhere, any order, etc.
- `step4/submit-em-sg4.sh`
- `step4/submit-em-mcfo.sh`

**Expected output:**
- files created:
```
    working/cdsresults.ga
        for each mask/library M/L pair:
            L-vs-</ directory, containing json results files
            log-L-M/ directory with search logs
```


## Step 5: Merge results

**Run:**
- on any computer
- from anywhere, any order, etc.
- `step5/merge-lm.sh`
- `step5/merge-em.sh`


## Step 6: Normalize

This step seems not to be needed any more.


## Step 7: AWS upload













