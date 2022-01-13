#!/bin/env python
"""

compare mips and final results directories to verify all MIPs have results

- get published names from aggregate json MIPs file
- verify each name has an individual MIP file
- read each of those files
- verify each MIP in each file has a results file

output is printed to screen as json so you can, eg, read it into a tool 
that corrects any of these problems

output json has the following keys:
    'aggregate-mips-path': 
    'individual-mips-dir': 
    'results-dir': 
        - these are the input parameters
    'missing-mips': 
        - list of MIPs files that don't have lines in aggregate file
    'missing-names': 
        - list of line names in aggregate file that don't have individual MIPs files
    'missing-results': 
        - dict: {"line name": [list of MIPs IDs without match files]}
    'missing-results-count': 
        - total count of MIPs IDs without match files
    'missing-results-libraries': 
        - dict: {"line name": "library"}

usage: find-missing-results.py <aggregate mip file> <directory of individual mips> <final results directory>

"""

# imports
import json
import os
import sys


def readonemip(filepath):
    # read data from a single MIP file
    data = json.loads(open(filepath, 'rt').read())
    return data["results"]

def readaggregatemip(filepath):
    # read data from an aggregate MIP file
    return json.loads(open(filepath, 'rt').read())

def namesfrommip(filepath):
    # get published names and libraries from an aggregate MIP
    data = readaggregatemip(filepath)
    return {item["publishedName"]: item["libraryName"] for item in data}

def idsfrommips(filepath):
    # return list of IDs from one MIP file
    data = readonemip(filepath)
    return [item["id"] for item in data]

def idsfromresults(directory):
    # return IDs from directory with files named like <MIP ID>.json
    results = []
    for filename in os.listdir(directory):
        items = filename.split('.')
        if items[-1] == "json":
            results.append(items[0])
    return results

def checknames(namelist, mipdir):
    # return (list of names that don't have mips, list of mips that don't have names)
    mipfiles = os.listdir(mipdir)
    mipfilenames = set(fn[:-5] for fn in mipfiles if fn.endswith(".json"))
    nameset = set(namelist)
    return list(nameset - mipfilenames), list(mipfilenames - nameset)

def reportnamecheck(missingmips, missingnames):
    return {
        "missing-mips": missingmips,
        "missing-names": missingnames,
    }

def checkonemip(filepath, resultset):
    fileids = set(idsfrommips(filepath))
    return list(fileids - resultset)

def checkallmips(names, mipsdir, resultset):
    results = {}
    for n in names:
        path = os.path.join(mipsdir, n + ".json")
        temp = checkonemip(path, resultset)
        if temp:
            results[n] = temp
    return results

def reportcheckmips(results, namelib):
    count = 0
    missinglibs = {}
    for name in results:
        count += len(results[name])
        missinglibs[name] = namelib[name]
    return {
        "missing-results": results,
        "missing-results-count": count,
        "missing-results-libraries": missinglibs,
    }


def main():
    if len(sys.argv) < 4:
        print("usage: find-missing-results.py <aggregate mip file> <directory of individual mips> <final results directory> [verbose]")
        sys.exit(0)

    aggmipspath = sys.argv[1]
    mipsdir = sys.argv[2]
    resultsdir = sys.argv[3]

    report = {
        "aggregate-mips-path": os.path.abspath(aggmipspath),
        "individual-mips-dir": os.path.abspath(mipsdir),
        "results-dir": os.path.abspath(resultsdir),
    }

    # find names in agg file that don't have individual mips files, and v.v.
    namelib = namesfrommip(aggmipspath)
    names = list(namelib.keys())
    missingmips, missingnames = checknames(names, mipsdir)
    report.update(reportnamecheck(missingmips, missingnames))

    # of the names in agg file, check that each mip in each file has a result
    # (the inverse doesn't make sense; results will have both sg4 and mcfo
    #   mixed, so will always miss some)
    resultids = set(idsfromresults(resultsdir))
    missingdict = checkallmips(names, mipsdir, resultids)
    report.update(reportcheckmips(missingdict, namelib))

    print(json.dumps(report, indent=2))


# script start
if __name__ == '__main__':
    main()
