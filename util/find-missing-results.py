#!/bin/env python
"""

compare mips and final results directories to verify all MIPs have results

(derived from find-mip-mismatches.py)

"""

# imports
import json
import os
import sys


def readonemip(filepath):
    # read data from a single MIP file
    data = json.loads(open(filepath, 'rt').read())
    return data["results"]

def idsfrommips(filepath):
    # return list of IDs from one MIP file
    data = readonemip(filepath)
    return [item["id"] for item in data]

def idsfromdir(directory):
    # return IDs from directory with files named like <published name>.json or <body ID>.json
    results = []
    for filename in os.listdir(directory):
        path = os.path.join(directory, filename)
        if path.endswith(".json"):
            results.extend(idsfrommips(path))
    return results

def idsfromresults(directory):
    # return IDs from directory with files named like <MIP ID>.json
    results = []
    for filename in os.listdir(directory):
        items = filename.split('.')
        if items[-1] == "json":
            results.append(items[0])
    return results



def main():
    if len(sys.argv) < 3:
        print("usage: find-missing-results.py <directory of individual mips> <final results directory>")
        sys.exit(0)

    mipsdir = sys.argv[1]
    resultsdir = sys.argv[2]

    dirIDlist = idsfromdir(mipsdir)
    dirIDset = set(dirIDlist)

    resultsIDlist = idsfromresults(resultsdir)
    resultsIDset = set(resultsIDlist)

    if dirIDset == resultsIDset:
        print("results found for all MIPs")
    else:
        if len(dirIDset - resultsIDset) > 0:
            print(f"{len(dirIDset - resultsIDset)} MIPs do not have results")
        if len(resultsIDset - dirIDset) > 0:
            print(f"{len(resultsIDset - dirIDset)} results files do not have MIPs")


# script start
if __name__ == '__main__':
    main()
