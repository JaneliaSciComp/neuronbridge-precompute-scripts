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

step 1: get all the MIP IDs and slide code, alignment space, and objective from
    all the PPP search results and produce the unique set of 

usage: update-ppp-imageStack-1.py resultsdir outputfile

"""

import json
import multiprocessing
import os
import sys
import time


# constants
# mouse2 has 40 CPUs, so pick something comfortably under that
ncpu = 30
chunksize = 500


def getdata(path):
    data = json.loads(open(path, 'rt').read())
    return set((r["slideCode"], r["alignmentSpace"], r["objective"]) for r in data["results"])

def main():
    if len(sys.argv) < 3:
        print("usage: usage: update-ppp-imageStack-1.py resultsdir outputfile")
        sys.exit(1)
    resultsdir = sys.argv[1]
    outputfile = sys.argv[2]

    print(f"{time.asctime()}: beginning")
    if not os.path.exists(resultsdir):
        print(f"{resultsdir} doesn't exist")
        sys.exit(1)
    if os.path.exists(outputfile):
        print(f"{outputfile} already exists")
        sys.exit(1)

    filelist = os.listdir(resultsdir)
    pathlist = [os.path.join(resultsdir, f) for f in filelist]

    with multiprocessing.Pool(ncpu) as p:
        setlist = p.map(getdata, pathlist, chunksize=chunksize)

    # one-liner for merging list of sets
    finalset = set().union(*setlist)
    with open(outputfile, 'wt') as f:
        json.dump(list(finalset), f, indent=2)

    print(f"{time.asctime()}: ending")

if __name__ == '__main__':
    main()
