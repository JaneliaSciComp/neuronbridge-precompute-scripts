# Scripts for precomputing NeuronBridge matches

[![DOI](https://zenodo.org/badge/355956072.svg)](https://zenodo.org/badge/latestdoi/355956072)

This repository contains scripts for running distributed color MIP mask searches as implemented in https://github.com/JaneliaSciComp/colormipsearch and utility scripts for related tasks. 

This repository is meant to record Janelia-specific operational knowledge and record how data for NeuronBridge was actually run. As such, it is:

- **very** Janelia-centric  
    + the scripts contain values relevant for Janelia data specifically
    + assumes a great deal of knowledge about the Janelia Fly Light imaging project
    + assumes/imposes a directory structure used at Janelia that is not required by the `colormipsearch` tools
    + assumes knowledge of the other NeuronBridge repositories, particularly the website, which is the primary downstream consumer of these searches
- fairly comprehensive; every detail except authentication secrets should appear in this repo
    + these are scripts as actually run; they can serve as a good example how the `colormipsearch` tools are run in practice
    + no secret auxiliary scripts that fix things "just this once"; even if something is done only once, the script should be included in the repo somewhere
- historical; each data release's scripts are frozen by tagging the repo at appropriate times
    + in principle, each script should be duplicated if run with different parameters in order to preserve this record

**NOTE** This documentation is a work in progress. We change procedures and add features with nearly every data release, and the documentation is in constant flux.


# General notes

## Note on running searches from scratch vs. adjusting old searches

As we add new features to the website, we often need to add information to old searches, in cases where we're adding metadata and the searches themselves don't need to be rerun. See section "Splicing attributes" for details of that procedure.


## Note on EM datasets: hemibrain vs. VNC

`colormipsearch` and `neuronbridge-precompute` were initially developed to run color depth searches for LM images against the hemibrain EM dataset (and vice versa). It can be used for VNC as well, but hasn't been as yet.

In general, to do so, everything would be very similar. You could either (a) duplicate all the scripts and files with (say) a prefix of "vnc-" and run it in parallel. Hemibrain data is stored in a "brain" subdir, and you'd want to segregate the vnc in a "vnc" subdirectory.

Alternately, you could just use the same scripts and plug in all the vnc-relevant values, as everything applies. This would be messier, as you wouldn't be able to do two calculations at the same time on the same branch in the same repo. However, it would be easily handled by just having a separate branch for each calculation. If anything useful was produced in terms of code changes, it could then be merged back to main.

This is due for a better refactor in the future.


## Note on LM datasets:

These scripts were initially written to handle two varieties of LM data, split gal4 and gen1 mcfo. I wrote a version of each script for each dataset. With the addition of the annotator gen1 mcfo dataset, it gets more complicated. Ideally, in hindsight, one would prefer a single LM script to which one would input the parameters, but in practice, it's going to take some manual labor each time in determining which pairs of mips need to be searched against one another, and later, which sets of results should be merged before upload.

For the annotator gen1 mcfo dataset, most of the processing was not run using these scripts. `global-parameters.sh` has been updated to add some variables, and the step 5 merge scripts were updated.


## Note on datasets: incremental updates

These scripts were written assuming that datasets would be all run together. In the future, we really need a way to do incremental updates. Changes needed:

- figure out how to determine which searches need to be done
    + in the past, it's been entire libraries in JACS db
    + in the future, we anticipate it will be a subset specified in some other way
        * possibly we can use the `publishedImage` collection in the JACS db
- file and directory naming conventions need rethinking; if we add some MCFO lines, then existing MCFO directories are no longer comprehensive; plus, new lines need good naming convention, too
- need to track which new directories get merged to which existing directories
    + probably the `.ga` directories ought to be all merged each time in to `.final`
    + but we need to be sure the merge tool can handle ever-increasing file sizes, and/or impose proper limits on how many search results we want to present online

## Note on PPP results

Some of the scripts in this repo reference "PPP" (Patch Per Pix) results. These are precomputed search results that are calculated using an entirely different algorithm than `colormipsearch`. As we present those results on the same website as the color depth search results, some of our scripts also do file wrangling for PPP results. These can be ignored if you don't have PPP results.


# Directory structure

All the computed data as well as the running code and scripts will be kept in one working directory. Usually that working directory is `/nrs/neuronbridge/v1.2.3`, where v1.2.3 is the current data version number (ie, the version of the precomputed search data, not to be confused with the website code version, or the project version).

This listing is reordered and commented.

```
workingdir/
    # config and current are website version config files
    config.json  
    current.txt  
    # release notes, copied from colormipsearch repo
    DATA_NOTES.md
    # repo for actual searches; Java, mostly by Cristian
    colormipsearch/
        target/ jar file
        src/stuff/scripts
    # this repo
    neuronbridge-precompute/
        step directories/
        parameter files
        util/
    # schemas for the json we upload
    schemas/
    brain/  
        # MIPs metadata files, both for processing and for upload;
        mips/  
        # pseudo-MIPs metadata files generated from PPP results
        pppresults/
        # three stages of precomputed search output
        cdsresults.matches/  
        cdsresults.ga/  
        cdsresults.final/  

```


# Setup, prerequisites, general notes

Prerequisites:
- color depth MIPs must be uploaded to the workstation (see "Loading color depth MIPs into JACS libraries" below)
- images should be uploaded to S3 by Rob (see "Uploading images to S3" below)
- user needs JACS auth
    + see https://wiki.int.janelia.org/wiki/display/JW/Authentication+Service
    + you will need to obtain a token and have it available in the JACSTOKEN environment variable for some steps
    + note that they expire in 24 hours
    + there's a helper script in this repository that will prompt for a password and output the retrieved token
        * it's a Python script that requires third-party "requests" library installed
        * usage: `export JACSTOKEN=$(util/get-jacs-token.py)`
        * note that the password prompt and any warnings will not be captured in the variable
- user needs AWS auth to do the uploads
- the working directory should have enough disk space (several terabytes)
- user needs access to servers: mouse1, mouse2, imagecatcher
- cluster access optional but highly recommended

Setup:
- determine the data version of the release
    + if there are any changes to the json output that will break the current website, increment the major version
    + otherwise, increment the minor version or patch level as appropriate
- create your working directory and clone two repos into it
- build the colormipsearch project
    + jar will end up in the target/ subdirectory
- edit global parameters file, mandatory:
    + WORKING_DIR
    + CDS_JAR_VERSION
- edit global parameters file, optional/as needed:
    + JAVA runtime variables and options
    + input file names if desired (`[EM|SG4|MCFO]_INPUT`)

General notes:
- adjust Java paths and parameters in the global parameters file
    + note you can enable/disable debugging here, for example
- the datasets vary quite a bit in size; when you run the same command over the EM or any of the LM datasets, the running time and disk space of the output may vary by an order of magnitude
    + generally Split Gal4 is by far the smallest, with EM much larger, and MCFO/annotator MCFO the largest

git for recording history:

The intention was that the user would edit various cdparams files as the workflow is run, but that _no value will be edited after it is used._ If so, it needs to be split into a new cdparams files (like the others)! Likewise, if any auxiliary scripts need to be run in order to fix or adjust things, they should appear as run somewhere in the directory structure (with notes, please). Then, once the workflow is done, the whole repo will contain the history of how it was run. That being said, due to the way the steps are currently ordered, it may not always happen in practice. But in an ideal world:

- do not edit anything (scripts or parameters) after it's been used
- commit all changes and all extra scripts etc. that were needed
- when done with a data release, add a tag describing the release just calculated
- side note: could use branches to help manage this; but typically we're only calculating one dataset at a time in a linear manner

# Loading color depth MIPs into JACS libraries

- the color depth MIPs are organized into libraries in JACS; they can be viewed in the Janelia Workstation
    + folder = "Color Depth Libraries"
    + subfolder = library, eg "flyem_hemibrain_1_2_1"
    + subsubfolder = alignment space, eg "JRC2018_Unisex_20x_HR"
    + subsubsubfolder = variants
- the library needs to exist in the config server http://config.int.janelia.org/config/cdm_library
    + if it does (if you're adding to existing library), skip to the next step
    + colormipsearch only cares about the "name" field; it should be set and present when the json input for the searches is run, and the "libraryName" field is populated from the config server "name" field
        * I'm 95% sure it's not needed during the library load phase...
        * ...but no harm in doing it early just in case
    + API is here: https://github.com/JaneliaSciComp/Centralized_Config
    + Rob Svirskas can do this (and probably should; we care about only that one field, and he cares about all of them, might want to insert other fields at the same time)
    + this applies to LM and EM libraries
- libraries are stored on disk: /nrs/jacs/jacsData/filestore/system/ColorDepthMIPs/
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
        * in the main directory, the `_FL.tif` files should not appear; move into fl/ subdirectory
            - this is how it was set up in v1.1
            - if you don't do this, you get spurious MIPs in the searches
            - this procedures still being worked on!
            - there will not be `_FL` variants for VNC or full brain; it's only to address the asymmetry in hemibrain images
    + adjust ownership & permissions:
        * (you)/scicompsoft works, as does jacs/jacsdata
        * ug+rw, o+r
            - I suspect write access isn't needed for running it, but is useful to let other people clean up stuff if needed
- copy files into directory (LM version):
    + (briefly, to be refined)
    + use the tool in the jar; do not do this by hand!  filenames need to be adjusted
    + there are two versions of step 1 scripts: one that operates from zip files, one from libraries; for this procedure, want the one with the zips
    + run it to create an aggregate json file where the variants point to the zip files
        * ie, run step1/xxxx-input-json-zips.sh script, after editing
        * note that you can run the searches from this json file (with the zips)!  however, it can't be used for image uploads, as that needs actual files on the file system
        * running time: ???
    + now you can run `util/copy-variants-xxx.sh` scripts (xxx = sg4 or mcfo); edit with the just-created json file path
        * expected running time: few minutes
- synchronization process:
    + if you wait for it to run automatically, can take up to a day or so (based on a few observation)
    + or you can start it manually via the REST API:
        * http://jacs2.int.janelia.org:9100/api/rest-v2/async-services/colorDepthLibrarySync
        * POST data = `{"owner": "user:olbrisd", "args": ["-alignmentSpace", "JRC2018_Unisex_20x_HR", "-library", "flylight_split_gal4_published"]}`
        * header = `header: {'Authorization': 'Bearer ' + your JACS token}`
        * adjust the username, token, and desired alignment space and library; note that variant libraries under the main lib will also be synced
    + either way: sync process logs: on jacs2 server, /opt/servers/jacs2/undertow/asyncweb/logs/jacs.log
- you can check results in the workstation
    + right-click to open the library/alignment space folder in a viewer
    + single-click images to check attributes in the Data Inspector

# Uploading images to S3

This is a confusing step!  Be careful.

- Rob Svirskas uploads images to S3; when he does, he stores those URLs in various fields in multiple collections in the JACS Mongo db 
- the individual json files will only populate imageURL field from the database; if they have that field, the image is uploaded
- however, the aggregate json file will populate the imageURL field with the URL it would or should have, whether it's been uploaded or not
- this aggregate json file is also the one Rob uses for input
    + he wants only the images that need uploading, though, not all of them (ie, just the updates)
- so the order of operation is something like this:
    + after the library has been created, run step 1 to create the aggregate json
    + run `util/filter-json-for-upload.py`; this script looks at the individual json files to determine which ones are missing imageURL and thus need uploading; it then filters the aggregate json and removes those that do have images
- the filtered json file can then be copied to `/groups/scicompsoft/informatics/data/release_libraries/v2.2.0` (with the right version number) for upload; try to name the file with the driver (split gal4, mcfo, whatever), the date, and the brain dataset (eg, hemibrain or vnc)
- let Rob know it's ready

Once Rob has done the upload and populated the db, it's time to start the workflow proper. You'll run step 0 and step 1 (again) at that time. Step 1 needs to be rerun so any new attributes will be picked up.


# Running the workflow - general

- Run each step in sequence. If a step has multiple scripts within a folder, order doesn't matter.

## Workflow overview

Step | Command | Memory | Parallel? | Computer | Running time
---- | ------- | ------ | --------- | -------- | ------------ 
Step 0: Generate MIPs metadata | `groupMIPsByPublishedName` |  |  |  |  ~30 minutes
Step 1: Prepare LM and EM JSON input | `createColorDepthSearchJSONInput` |  |  |  | ~1-2 hours
Step 2: Compute color depth matches | `searchFromJSON` |  | :white_check_mark: | mouse1, mouse2  | few hours (SG4) to few days (MCFO)
Step 3: Calculate gradient score | `gradientScore` | 180G+  | :white_check_mark: | mouse1,2 | few days 
Step 4: Update the gradient score | `gradientScoresFromMatchedResults` | 480G | | imagecatcher | days to weeks
Step 5: Merge flyem results | `mergeResults` | | | | ~30-40 minutes          


## Computational resources

Computer | CPU | Memory | AWS CLI? | Notes
-------- | --- | ------ | -------- | -----
mouse1, mouse2 | 40 | 192G |  | used for parallel jobs (ie, needing lots of individual CPUs)
imagecatcher | 28 | 500G | :white_check_mark: | used for high-memory jobs
c13u05 (aka nextflow) | 40 | 128G |  |
personal workstations |  |  |  | can be used for low resource jobs
cluster |  |  |  | can be used for parallel jobs if time critical and budget available

## Cluster use

Steps 2, 3, and 4 can and often should be run on the cluster. In the parameters file, you will need to make the following changes:

- in the global parameters file, check that `CLUSTER_PROJECT_CODE` is set to the proper current project code for cluster billing
- set `RUN_CMD="gridRun"`
- look over the computer resource section; you may need to adjust memory and number of cores available to match the cluster nodes rather than the SciComp servers
- look over the "job partitioning" section; you _will_ want to adjust how the jobs are batched up! performance varies _dramatically_ based on batching
    + the default parameters assume you're running on one SciComp server, and you may benefit from more jobs/batches when running on the cluster
    + in particular, since split gal 4 datasets are smaller, they are often run in one job on SciComp servers; you should run several on the cluster
    + MCFO jobs, though, are already batched into typically hundreds of jobs, so you probably don't need to adjust for the cluster


# Running the workflow - individual steps

These steps are documented as if you are running all split gal4 and MCFO from scratch. If you are adding a new LM dataset, for example, you need not run the old LM scripts, and you need not regenerate any of the EM MIPs metadata files.

These docs pre-date the Annotator Gen1 MCFO dataset! That dataset is at least as big as all the existing data, and all running times are at least double if that dataset is included.

## Step 0: generate MIPs metadata

These files will be uploaded to S3 for use by the website. They are not used in performing the precomputed searches.

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
- expected numbers as of v2.1.1 (late 2020)
- running time: ~20 minutes for all three
- files and directories created:
```
    working/mips
        ~2G total
        /em_bodies
            ~30k json files
        /split_gal4_lines
            ~600 json files
        /gen1_mcfo_lines
            ~5k json files
```
- each json file is small, most <= 10kb

## Step 1: create JSON input files

These files are the input for the precomputed searches.

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
- running time: ~2 hours for all (as of 2022)
- files created (v2.2 names):
```
    working/mips
        hemibrain1.2.1.json
        mcfo.json
        split_gal4.json
```
- filenames are specified in `global-cdsparams.sh` as `EM_INPUT` etc.
- each json file is mid-sized, up to ~700Mb
- optional: run `util/find-mip-mismatches.py <mips dir> <aggregate mips file>`; expected output is `ID sets match`
    + there will likely be many duplicates; this is fine, as (eg) multiple channels will count as duplicates
    + however, there should be no IDs in the directory that are not in the aggregate file; if that happens, it will cause problems later; the website will show images in the initial line/body ID search that will not have search results


## Step 2: Compute color depth matches

This is the initial search step.

### Count data input

Determine the number of MIPs found in step 1. Edit `global-cdsparams.sh` with the results of these commands:
- `source global-cdsparams.sh` (to populate the variables used below)
- edit `EM_COUNT` to `grep imageURL ${MIPSDIR}/${EMINPUT}.json | wc` (first value)
- edit `MCFO_COUNT` to `grep imageURL ${MIPSDIR}/${MCFOINPUT}.json | wc` (first value)
- edit `SG4_COUNT`: `grep imageURL ${MIPS_DIR}/${SG4_INPUT}.json | wc` (first value)
- edit job partitioning numbers in `step2/cdsparams-em-sg4.sh` and `step2/cdsparams-em-mcfo.sh`
    + for `MASKS_PER_JOB`, put in the number of EM files; we do all the masks in each job
    + for `LIBRARIES_PER_JOB`, we've been using about 5000; for MCFO, use that; for SG4, use the actual number of SG4 files, as it's close enough to 5000
    + leave `PROCESSING_PARTITION_SIZE` at 500
    + these numbers are chosen empirically; the results is that EM-SG4 will run in one job; EM-MCFO will require dozens (35 at last run)

### Perform searches

This step is done in parallel. Normally it's done on SciComp servers, but if there is budget and a need for speed, it can be run on the cluster. There's code in place for that, but it hasn't been used or tested much. In particular, billing control seems to be absent.

The mouse1 and mouse2 servers are appropriate for this step, as they have a lot of CPUs and adequate memory. The work is batched into sequential jobs, and each job runs multiple work threads.

In this step, in the parameter file, the masks = EM data, and the libraries = LM data, though output is produced for both directions.

**Run:**
- on mouse1/2
- from anywhere, any order, etc.
- `step2/submit-em-sg4.sh`
- `step2/submit-em-mcfo.sh`

**Expected output:**
- running time (v2.2):
    + split gal4: ~20 hours (cluster)
    + MCFO: ~42 hours (2 days) (one server) (timed before a performance-affecting fix!!)
- files created (v2.2 naming scheme):
```
    working/cdsresults.matches
        for each mask/library M/L pair:
            M-vs-L/ and L-vs-M/ directories, containing json results files
            log-M-L/ directory with search logs (M and L abbreviated here)
            mask-M-inputs-L-cdsParameters.json parameter file
        for v2.2, that is:
            ~5T total
            hemibrain1.2.1-vs-mcfo/ 
                ~45k json files
            hemibrain1.2.1-vs-split_gal4/
                ~45k json files
            mcfo-vs-hemibrain1.2.1/
                ~80k json files
            split_gal4-vs-hemibrain1.2.1/
                ~2k json files
            logs-em-mcfo/  
            logs-em-sg4/
            masks-hemibrain1-inputs-mcfo-cdsParameters.json        
            masks-hemibrain1-inputs-split_gal4-cdsParameters.json
```


## Step 3: Calculate gradient score for the EM to LM color depth matches

### Count results files

Determine the number of search results files found in step 2. Edit `step3/cdsparams-em-sg4.sh` with the results of these commands:
- `source global-cdsparams.sh`
- count number of results files: `ls ${CDSMATCHES_RESULTS_DIR}/${EM_INPUT}-vs-${SG4_INPUT} | wc`
- for running on mouse[12]
    + `FILES_PER_JOB=200` for SG4
    + `FILES_PER_JOB=100` for MCFO
- set `TOTAL_FILES` to the smallest multiple of `FILES_PER_JOB` that is greater or equal to the number of results files found above
    + eg, if # results = 1234 and `FILES_PER_JOB` is 200, choose 1400

Repeat for MCFO.

### Perform gradient scoring

As with step 2, this step is done in parallel, usually run on SciComp servers. Almost all of the step 2 comments above apply.

For this step, masks = EM, libraries = LM. Output is only produced for this combination.

**Run:**
- on mouse1/2
- from anywhere, any order, etc.
- `step3/submit-em-sg4.sh`
- `step3/submit-em-mcfo.sh`

**Expected output:**
- running time (v2.2):
    + split gal4: ~60h on cluster
    + MCFO: ~1400h on cluster
- files created:
```
    working/cdsresults.ga
        for each mask/library M/L pair:
            M-vs-L/ directory, containing json results files
            log-M-L/ directory with search logs (M and L abbreviated again)
        for v2.2, that is:
            hemibrain1.2.1-vs-mcfo/ 
            hemibrain1.2.1-vs-split_gal4/
            logs-em-mcfo/  
            logs-em-sg4/
```


## Step 4: Compute reverse gradient scores

This step basically reverses step 3 (masks <--> libraries). 

- needs to be run on high memory machine; the computer-related parameters (number CPUs, memory) _are_ different for step 4
- in the parameter file, it's still masks = EM, libraries = LM, even though we're really doing the reverse

This time you're counting the LM output files from step 2. Edit `step3/cdsparams-em-sg4.sh` with the results of these commands:
- `source global-cdsparams.sh`
- count number of results files: `ls ${CDSMATCHES_RESULTS_DIR}/${SG4_INPUT}-vs-${EM_INPUT} | wc`

Repeat for MCFO.

### Perform reverse gradient scoring

**Run:**
- on imagecatcher
- from anywhere, any order, etc.
- `step4/submit-em-sg4.sh`
- `step4/submit-em-mcfo.sh`

**Expected output:**
- running time:
    + (times after Cristian's fix for out-of-memory issues)
    + split gal4: ~10m 
    + MCFO: ~14h 
- files created:
```
    working/cdsresults.ga
        for each mask/library M/L pair:
            L-vs-M/ directory, containing json results files
            log-L-M/ directory with search logs
        for v.2:
            mcfo-vs-hemibrain1.2.1/
            split_gal4-vs-hemibrain1.2.1/
            logs-mcfo-em/     
            logs-sg4-em/  
```


## Step 5: Merge results

If you need to splice attributes, you might want to do it now, before merging.

Note that merging is more difficult now that we have several datasets that we've calculated at various times. Consult the wiki (https://wiki.int.janelia.org/wiki/display/ScientificComputing/NeuronBridge+data+versions) for the location of previous data version output. Edit the merge scripts so all the relevant datasets are properly merged.

**Run:**
- on any computer
- from anywhere, any order, etc.
- `step5/merge-lm.sh`
- `step5/merge-em.sh`

**Expected output:**
- running time: as of v2.4.0, 75m for LM, 
- files created:
```
    working/cdsresults.final
        ~ 300G total for v2.2
        flyem-vs-flylight/
            ~45k json results files
        flylight-vs-flyem/
            ~45k json results files
```



## Step 5.5: check for and populate missing search results

### check for missing match files

Some MIPs will not have any matches. For example, an image might be too dim or too dense. Or LM expression may be occurring only in regions not imaged in EM (eg, the hemibrain didn't image the optic lobes or the area near the VNC). In this case, there will be no results file at all, as the distributed search process only knows how to write results. It doesn't check later for lack of results. 

- for each dataset:
- run `util/find-missing-results.py`
    + input is the aggregate MIPs file, the directory of individual MIPs files, and the final match files directory
    + you should capture the screen output, which is in json format, to a file
    + that json contains all the lines and MIPs that have inconsistencies
    + see the script header for format of the output


### populate missing match files

For any MIPs that don't have match files, we need to provide an empty match file so the website can display the appropriate messages for am empty search that we did run vs. a MIP ID that doesn't exist that we never ran (eg, if the user edited the ID in the results URL).

- run `util/populate-missing-results.py` with the json file from the previous step as input 

Typically once the matches are uploaded to a dev site, the MIPs with missing matches will be examined to be sure they are legitimate. 


### future improvement

Note that we should fix this in the future so appropriate empty files are created by the search tool earlier on. There is a ticket for this.

The merge step also needs to write empty files. Not sure if the reverse search also has the same problem?


## Step 6: Normalize

This step is mentioned in the colormipsearch repo, but it is not needed any more.


## Step 7: AWS upload

This step uploads the data to the AWS cloud. There are several goups of files to be uploaded, and they need not be done all at the same time. The `util/upload.sh` script has all the commands, and they can be commented out/in as needed to do whichever part of the upload you want. 

**Preparation:**
- edit `util/upload.sh` 
    + set correct upload bucket for the website you're uploading data for
        * eg, dev, val, or prod
    + set version folder name based on data version
- edit `working/config.json` if needed (probably won't be; contains bucket info, usually edited as part of deployment)
    + likewise `working/current.txt`
    + do _not_ upload these files unless you are doing final deployment
- in the https://github.com/JaneliaSciComp/colormipsearch repository, edit `DATA_NOTES.md` with details of what's included and what's changed
    + copy that file to `working/DATA_NOTES.md`
    + **NOTE**: `publishedNames.txt` is has been used or not used at various times; be sure it's present if it needs to be; it should be generated by Rob from the AWS Dynamo db that he populates early on
- schemas: if the form of any of the uploaded json files has changed (MIPs metadata or search results), schemas should be regenerated and uploaded
    + use `util/generate-schemas.sh`, or run the jar directly (it's a very straightforward command)
- remove previous results: if you want to remove previous results, you can remove S3 objects (including "directories") like this:
    + this example leaves the ppp results in place but removes the rest of the results for v2.2.0:
    + `aws s3 rm s3://janelia-neuronbridge-data-int/v2_2_0/metadata/cdsresults --recursive`
    + `aws s3 rm s3://janelia-neuronbridge-data-int/v2_2_0/metadata/by_body --recursive`
    + `aws s3 rm s3://janelia-neuronbridge-data-int/v2_2_0/metadata/by_line --recursive`
    + generally this isn't desirable, as we usually only upload new results!

**Run:**
- on any computer that has AWS command-line client installed
- user must have credentials for our account, configured in the client
- (optional) if you need to remove previous results, the command looks like this:
    `aws s3 rm s3://bucket-name/example --recursive`
    + but generally we don't need or want to do this!
- in general, the command to upload is `util/upload.sh`
    + by default, for safety, the script will only print the commands it will execute
    + edit to comment in/out the two `EXEC_CMD` values; "echo" is the command preview; empty = do it for real
- running time:
    + upload mips: ~10 minutes
    + upload results: ~2h
    + upload misc text files: <1 minute


# Splicing Attributes

Sometimes the final match json files are missing fields. For example, if the searches are run before the images are uploaded to S3, the imageURL field in the match json will not be populated. Or we may add useful metadata to images to support website improvements. Rerunning the searches would be computationally expensive, so we need to update the matches to include the new fields.

The general flow of information is this:
- information is loaded into the JACS database by some method
- an aggregate MIPs metadata file is generated (step 1 above) that contains the new attribute
- one or more scripts is run to copy the new attribute from the aggregate MIPs file onto corresponding entries in the search results files; this may include:
    + the search results proper (color depth MIPs search)
    + the top mask section
    + search results for PPP results (for which we have pseudo-results)
    + (we don't expect to add attributes to the mask section for PPP, but I suppose it's possible in the future)
    + each of these splices is done differently
- the splicing may be done onto the Step 4 (ga) results or the Step 5 (final) results
    + earlier is better than later, but later tends to be easier
    + **Note** we have not done this fully consistent, and it's not clear which older results have all the proper results or not!


## Splicing attributes onto CDM results

This is the easiest procedure, and it is supported by a tool in the colormipsearch repo. 

- run step 1 to create an aggregate MIPs metadata file for the data in question; this file must contain the new attributes
- edit `util/update-attributes.sh`
    + `-attrs` is the source MIPs metadata file
    + `--input-dirs` is the directory of results to be updated
    + `-od` is the output directory; best not to overwrite input directory!
    + `--id-field` is the field in the json files used to correlate the metadata MIPs with the results; this should almost always be `id`
        * in rare cases where `id` is not unique (eg, for `searchablePNG` field), `imageURL` may suffice; determine on case-by-case basis
    + `fields-toUpdate` is a space-separated list of the attributes to update
- run it
- running time: depends on what is being updated; for all LM results, can be ~2 hours

Be sure to do any file-system cleanup that is needed. Eg, remove old results directory, rename newly spliced results directory, etc.


## Splicing attributes onto CDM masks

If we add an attribute that should be available for the mask in CDM results, the procedure is different. The tool in the colormipsearch jar does not work (currently) because:
- the field to match on is not the same between the source jar and the destination result (usually `id` and `maskId`)
- the field to update also doesn't match (eg, `imageStack` and `maskImageStack`)
- `util/one-offs/update-mask-attribute.py` is used to do this update instead


## Splicing attributes onto PPP results

PPP results are unusual in that they are not produced by our software. The results do not use our IDs, so they can't be correlated. As a result, the CDM result tool can't be used.

Instead, we need to retrieve the info another way based on the info that does appear in the results file. For the `imageStack` attribute, that means using the slide code, alignment space, and objective of the result to look up the attribute in the JACS db directly. This was done in a set of three scripts. The current, more general versions are `util/one-offs/update-ppp-publishedImage-[123].py`. 

Note, though, that this update procedure is going to vary on a case-by-case basis. For example, `util/one-offs/update-ppp-publishedImage-2alt.py` is a variation in which a different REST endpoint is required. Fortunately, the three scripts are somewhat modular; modifications are _most_ likely to be limited to the second, with the others working as-is.












