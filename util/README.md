# util directory

This directory contains scripts that (mostly) don't use the `colormipsearch` codebase. Some are used in the processing pipeline, while others are used for convenience functions or for debugging.

*Note:* These scripts do not use the global parameter shell scripts! As such, they contain a lot more hard-coded directory information, and they may need to be edited if you change the default values in those parameter scripts.

- `copy-cleanup-em-sg4.py` (and mcfo): testing script that runs the "merge" step when there is no merge to be done, so the cleanup step is run
- `copy-variants-sg4.sh` (and mcfo): used when loading libraries; takes zip files of image variants and copies them into the filesystem in the right place with the right names; the libray sync routine will then add them to the db
- `filter-json-for-upload.py`: used to produce a list of MIPs images that have not been uploaded
- `find-mip-mismatches.py`: compares the list of IDs contained in the individual MIPs files and the aggregate MIPs file; if they don't match, there is likely something wrong
- `find-missing-results.py`: compare the IDs contained in the individual MIPs files and the final results files; identifies how many are missing
- `get-jacs-token.py`: the first two steps of the pipeline require a JACS token to be available in an env variable; see code snip in the main README for how his script does that
- `mips-summary.py`: this script reads through all the individual MIP files and writes to std out the MIP ID and published name of each MIP; save it in a file and you can grep through it when you need those numbers
- `update-attributes.sh`: used to transfer attributes in the json that are correct in the individual or aggregate json to the later results json files, without rerunning the searches
- `upload.sh`: this is the script that uploads everything to AWS S3; it is used in the pipeline and documented in the main README


