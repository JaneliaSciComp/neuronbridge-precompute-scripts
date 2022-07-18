#!/bin/env python
"""
we need to splice attributes onto the PPP results; the PPP results 
don't have MIPs or MIPs metadata files, so we need to grab the data from the database;
this script does so for attributes in the publishedImage collection in JACS

- we're doing it in multiple scripts, to be run in sequence
- some things hard-coded
- we can generalize and refactor later if we need to reuse this

step 2: read the IDs from step 1 and get the URL from the db for each of them
--> JACS auth token must be in env var JACSTOKEN!

this version: getting screenImage requires a different endpoint call, and in this case
it was only on my server, not production

before running, edit the constant  "files" element from the 

usage: update-ppp-publishedImage-2alt.py inputIDfile outputIDfile

"""

# std lib
import json
import os
import sys
import time

# 3rd party
import requests


# constants
# element in the "files" object in "publishedImage" collection to retrieve
ELEMENTNAME = "ColorDepthMip1"
# original use: for imageStack:
# ELEMENTNAME = "VisuallyLosslessStack"

# stuff for getting URLs from olbrisd-ws3 when my dev server is up:
baseurl = "http://jacs2.int.janelia.org:9190/api/rest-v2/publishedImage/imageWithGen1Image"
# baseurl = "http://localhost:8080/api/rest-v2/publishedImage/imageWithGen1Image"
# baseurl = "http://jacs2.int.janelia.org:9190/api/rest-v2/publishedImage/image"
tokenvar = "JACSTOKEN"
header = {}


def getURL(triplet):
    # input: [slideCode, alignmentSpace, objective]; output: [slideCode, alignmentSpace, objective, URL]

    # unfortunate choice of order in the triplet, alas
    url = baseurl + "/" + triplet[1] + "/" + triplet[2] + "/" + triplet[0]
    r = requests.get(url, headers=header)
    if r.status_code != requests.codes.OK:
        targetURL = ""
    else:
        # note that for this URL, for this attribute, we want the second image
        image = r.json()[1]
        try:
            targetURL = image["files"][ELEMENTNAME]
        except:
            targetURL = ""
    return triplet + [targetURL]


def main():
    if len(sys.argv) < 3:
        print("usage: update-ppp-publishedImage-2.py inputIDfile outputIDfile")
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

    outputlist = [getURL(d) for d in inputdata]
    with open(outputIDfile, 'wt') as f:
        json.dump(list(outputlist), f, indent=2)


    print(f"{time.asctime()}: ending")

if __name__ == '__main__':
    main()
