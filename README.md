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


# Setup

- create your working directory and clone two repos into it
- build the colormipsearch project
    + jar will end up in the target/ subdirectory
- edit global parameters file


# Running the workflow

Run each step in sequence. Within each step, script order doesn't matter.

## Workflow overview

Step | Command | Memory | Parallel? | Computer | Running time
--- | --- | --- | --- | --- | --- 
Step 0: Generate MIPs metadata | groupMIPsByPublishedName |  |  |  |  minutes
Step 1: Prepare LM and EM JSON input | createColorDepthSearchJSONInput |  |  |  | minutes

