#!/bin/env python
"""
we need to splice attributes onto the PPP results; the PPP results 
don't have MIPs or MIPs metadata files, so we need to grab the data from the database;
this script does so for attributes in the publishedImage collection in JACS

- we're doing it in multiple scripts, to be run in sequence
- some things hard-coded
- we can generalize and refactor later if we need to reuse this

step 1: get all the MIP IDs and slide code, alignment space, and objective from
    all the PPP search results and produce the unique set of 

usage: update-ppp-publishedImage-1.py resultsdir outputfile

"""

import json
import os
import sys
import time


def getdata(path):
    data = json.loads(open(path, 'rt').read())
    return set((r["slideCode"], r["alignmentSpace"], r["objective"]) for r in data["results"])

def main():
    if len(sys.argv) < 3:
        print("usage: usage: update-ppp-publishedImage-1.py resultsdir outputfile")
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
    setlist = [getdata(p) for p in pathlist]

    # one-liner for merging list of sets
    finalset = set().union(*setlist)
    with open(outputfile, 'wt') as f:
        json.dump(list(finalset), f, indent=2)

    print(f"{time.asctime()}: ending")

if __name__ == '__main__':
    main()
