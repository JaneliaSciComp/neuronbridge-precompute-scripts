#!/bin/env python
"""

sometimes mips just don't have matches; the distributed search process does
not create empty json files for them, so we need to do it as a separate script

input file can be either:
- plain text file with MIP IDs, one per line
- output json file from find-missing-results.py script

the other input parameter is the directory into which to write the files; this
    is typically the appropriate cdsresults.final/ subdirectory

usage: populate-missing-results.py <inputfile> <final results directory>

"""

# imports
import json
import os
import sys



def readinputfile(path):
    # returns list of IDs as string

    # could be json or plain text:
    try:
        # assumes output format from find-missing-results.py
        data = readinputjson(path)
        missing = data["missing-results"]
        IDs = []
        for name in missing:
            IDs.extend(missing[name])

    except json.JSONDecodeError:
        data = readinputtext(path)
        IDs = [line.strip() for line in data]

    return IDs


def readinputjson(path):
    return json.loads(open(path, 'rt').read())

def readinputtext(path):
    return open(path, 'rt').readlines()

def writeresults(missingIDs, resultsdir):

    # not going to bother with the json module for this:
    for ID in missingIDs:
        path = os.path.join(resultsdir, ID + ".json")
        with open(path, 'wt') as f:
            f.write("[ ]\n")


def main():
    if len(sys.argv) < 3:
        print("usage: populate-missing-results.py <inputfile> <final results directory>")
        sys.exit(0)

    inputpath = sys.argv[1]
    resultsdir = sys.argv[2]

    if not os.path.exists(inputpath):
        print(f"{inputpath} does not exist")
        sys.exit(1)

    if not os.path.exists(resultsdir):
        print(f"{resultsdir} does not exist")
        sys.exit(1)

    missingIDs = readinputfile(inputpath)
    writeresults(missingIDs, resultsdir)


# script start
if __name__ == '__main__':
    main()
