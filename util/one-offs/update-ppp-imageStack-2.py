#!/bin/env python
"""
we need to do a one-off splicing of the imageStack attribute onto the 
PPP results; the PPP results don't have MIPs or MIPs metadata files, so 
we need to grab the data from the database

- we're doing it in multiple scripts, to be run in sequence
- some things hard-coded
- we can generalize and refactor later if we need to reuse this

NOTE: the first two of these scripts are over-optimized; I was worried about performance
    and started putting in parallelization from the start (also partly as an exercise),
    but I don't think it was needed on any of them

step 2: read the IDs from step 1 and get the URL from the db for each of them
--> JACS auth token must be in env var JACSTOKEN!

usage: update-ppp-imageStack-2.py inputIDfile outputIDfile

"""

# std lib
import json
import multiprocessing
import os
import sys
import time

# 3rd party
import requests


# constants

# stuff for getting URLs from JACS:
baseurl = "http://jacs2.int.janelia.org:9190/api/rest-v2/publishedImage/image"
tokenvar = "JACSTOKEN"
header = {}


# mouse2 has 40 CPUs, so pick something comfortably under that
# getting "cannot assign requested address" error; looks like running out of local ports?
# cheap solution: run sequential in one big batch (turns out *way* faster than I expected, sigh)
ncpu = 1
chunksize = 50000


def getURL(triplet):
    # input: [slideCode, alignmentSpace, objective]; output: [slideCode, alignmentSpace, objective, URL]

    # unfortunate choice of order in the triplet, alas
    url = baseurl + "/" + triplet[1] + "/" + triplet[2] + "/" + triplet[0]
    r = requests.get(url, headers=header)
    if r.status_code != requests.codes.OK:
        h5jURL = ""
    else:
        image = r.json()[0]
        try:
            h5jURL = image["files"]["VisuallyLosslessStack"]
        except:
            h5jURL = ""
    return triplet + [h5jURL]


def main():
    if len(sys.argv) < 3:
        print("usage: update-ppp-imageStack-2.py inputIDfile outputIDfile")
        sys.exit(1)
    inputIDfile = sys.argv[1]
    outputIDfile = sys.argv[2]

    print(f"{time.asctime()}: beginning")
    if not os.path.exists(inputIDfile):
        print(f"{inputIDfile} doesn't exist")
        sys.exit(1)
    if os.path.exists(outputIDfile):
        print(f"{outputIDfile} already exists")
        sys.exit(1)

    # check we have auth:
    if tokenvar not in os.environ:
        print(f"your JACS token must be stored in {tokenvar}!")
        sys.exit(1)
    else:
        global header
        header['Authorization'] = 'Bearer ' + os.environ[tokenvar]

    # data is list of [slideCode, alignmentSpace, objective], so it's 
    #   already in the form we want
    inputdata = json.loads(open(inputIDfile, 'rt').read())


    with multiprocessing.Pool(ncpu) as p:
        outputlist = p.map(getURL, inputdata, chunksize=chunksize)
    with open(outputIDfile, 'wt') as f:
        json.dump(list(outputlist), f, indent=2)


    print(f"{time.asctime()}: ending")

if __name__ == '__main__':
    main()
