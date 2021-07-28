#!/bin/env python
"""

look at a directory of MIPS and the aggregate file; see if the same IDs appear in both or not

"""

# imports
import json
import os
import sys
import time


def readonemip(filepath):
    # read data from a single MIP file
    data = json.loads(open(filepath, 'rt').read())
    return data["results"]

def readaggregatemip(filepath):
    # return data (list of MIP json) from an aggregate MIP file
    return json.loads(open(filepath, 'rt').read())    

def idsfrommips(filepath):
    # return list of IDs from one MIP file
    data = readonemip(filepath)
    return [item["id"] for item in data]

def idsfromdir(directory):
    # return IDs from directory with files named like <MIP ID>.json
    results = []
    for filename in os.listdir(directory):
        path = os.path.join(directory, filename)
        if path.endswith(".json"):
            results.extend(idsfrommips(path))
    return results

def idsfromaggregate(filepath):
    # return IDs from an aggregate MIP file
    data = readaggregatemip(filepath)
    return [item["id"] for item in data]
        
def main():
    if len(sys.argv) < 3:
        print("usage: find-mip-mismatches.py <directory of individual mips> <aggregate mip file>")
        sys.exit(0)

    mipsdir = sys.argv[1]
    mipsfile = sys.argv[2]

    dirIDlist = idsfromdir(mipsdir)
    dirIDset = set(dirIDlist)
    fileIDlist = idsfromaggregate(mipsfile)
    fileIDset = set(fileIDlist)

    # first check: are there duplicates within a list?
    if len(dirIDlist) != len(dirIDset):
        print(f"{mipsdir} has {len(dirIDlist) - len(dirIDset)} duplicates of {len(dirIDlist)} entries")
    if len(fileIDlist) != len(fileIDset):
        print(f"{mipsfile} has {len(fileIDlist) - len(fileIDset)} duplicates of {len(fileIDlist)} entries")

    # the real test: do the other MIPs match?  if not, we're going to have a bad time later on
    if fileIDset != dirIDset:
        if len(dirIDset - fileIDset) > 0:
            print(f"{len(dirIDset - fileIDset)} IDs in the directory are not in the aggregate file")
        if len(fileIDset - dirIDset) > 0:
            print(f"{len(fileIDset - dirIDset)} IDs in the aggregate file are not in the directory")
    else:
        print("ID sets match")


# script start
if __name__ == '__main__':
    main()