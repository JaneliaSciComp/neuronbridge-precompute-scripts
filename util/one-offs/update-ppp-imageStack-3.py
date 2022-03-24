#!/bin/env python
"""
we need to do a one-off splicing of the imageStack attribute onto the 
PPP results; the PPP results don't have MIPs or MIPs metadata files, so 
we need to grab the data from the database

- we're doing it in multiple scripts, to be run in sequence
- some things hard-coded
- we can generalize and refactor later if we need to reuse this

step 3: read the URLs from step 2 and apply to each of the search results files

usage: update-ppp-imageStack-3.py inputURLfile inputresultsdir outputresultsdir

"""

# std lib
import json
import os
import sys
import time

# 3rd party
import requests


def rewriteresuls(inputpath, outputpath, URLmap):
    data = json.loads(open(inputpath, 'rt').read())
    for mip in data["results"]:
        mip["imageStack"] = URLmap[mip["slideCode"], mip["alignmentSpace"], mip["objective"]]
    with open(outputpath, 'wt') as f:
        json.dump(data, f, indent=2)


def main():
    if len(sys.argv) < 4:
        print("usage: update-ppp-imageStack-3.py inputURLfile inputresultsdir outputresultsdir")
        sys.exit(1)
    inputURLfile = sys.argv[1]
    inputresultsdir = sys.argv[2]
    outputresultsdir = sys.argv[3]

    print(f"{time.asctime()}: beginning")
    if not os.path.exists(inputURLfile):
        print(f"{inputURLfile} doesn't exist")
        sys.exit(1)
    if not os.path.exists(inputresultsdir):
        print(f"{inputresultsdir} doesn't exist")
        sys.exit(1)
    if os.path.exists(outputresultsdir):
        print(f"{outputresultsdir} already exists")
        sys.exit(1)
    os.mkdir(outputresultsdir)

    # going to try this sequential first, as parallelization for the first
    #   two scripts turned out to be overkill or problematic

    # data file is list of [slideCode, alignmentSpace, objective, URL]
    inputdata = json.loads(open(inputURLfile, 'rt').read())
    URLmap = {(quad[0], quad[1], quad[2]): quad[3] for quad in inputdata}

    resultsfiles = os.listdir(inputresultsdir)
    for fn in resultsfiles:
        inputpath = os.path.join(inputresultsdir, fn)
        outputpath = os.path.join(outputresultsdir, fn)
        rewriteresuls(inputpath, outputpath, URLmap)

    print(f"{time.asctime()}: ending")

if __name__ == '__main__':
    main()
