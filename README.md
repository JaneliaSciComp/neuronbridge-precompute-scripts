# colormipsearch-scripts

This repo contains scripts for running distributed color MIP mask searches as implemented in https://github.com/JaneliaSciComp/colormipsearch.

This repository is meant to record Janelia-specific operational knowledge and record how data for NeuronBridge was actually run. As such, it is:

- private; appropriate for Janelia only
- assumes/imposes a specific directory structure
- reproducible; every detail except authentication secrets should appear in this repo
    + so no secret auxiliary scripts that fix things "just this once"; if you need to do something, include the script
    + changeable details should be isolated and centralized, however
- historical; use tags and/or branches as needed so what was actually run can be frozen while allowing future runs to have different details


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
- user needs JACS auth
    + see https://wiki.int.janelia.org/wiki/display/JW/Authentication+Service
    + you will need to obtain a token and have it available in the JACSTOKEN environment variable for some steps
    + note that they expire in 24 hours
    + there's a helper script in this repository that will prompt for a password and output the retrieved token
        * it's a Python script that requires third-party "requests" library installed
        * usage: `export JACSTOKEN=$(get-jacs-token.py)`
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

General notes:
- adjust Java paths and parameters in the global parameters file
    + note you can enable/disable debugging here, for example
- the datasets vary quite a bit in size; when you run the same command over the EM or any of the LM datasets, the running time and disk space of the output may vary by an order of magnitude
    + generally Split Gal4 is by far the smallest, with EM much larger, and MCFO the largest


# Running the workflow

- Run each step in sequence. If a step has multiple scripts within a folder, order doesn't matter.

## Workflow overview

Step | Command | Memory | Parallel? | Computer | Running time
--- | --- | --- | --- | --- | --- 
Step 0: Generate MIPs metadata | `groupMIPsByPublishedName` |  |  |  |  several minutes
Step 1: Prepare LM and EM JSON input | `createColorDepthSearchJSONInput` |  |  |  | < 1 hour



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
    working/mips
        /em_bodies
            ~30k json files
        /split_gal4_lines
            ~600 json files
        /gen1_mcfo_lines
            ~5k json files
- each json file is small, most <= 10kb

## Step 1: create JSON input files

**Run:**
- authentication token into JACSTOKEN variable
- execute the following scripts 
    + from any location
    + in any order
    + on any computer
    + `step1/em-input-json.sh`
    + gal4
    + mcfo

**Expected output:**
- files created:
    working/mips
        flyem_hemibrain-withDirs.json
        gal4
        mcfo
- each json file is mid-sized, ~5-500Mb

























