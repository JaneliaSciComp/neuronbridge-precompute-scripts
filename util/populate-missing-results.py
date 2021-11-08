#!/bin/env python
"""

sometimes mips just don't have matches; the distributed search process does
not create empty json files for them, so we need to do it as a separate script

note that the empty results files contain some metadata about the mask, too; looks like;
    {
      "maskId" : "2711776302980923403",
      "maskPublishedName" : "LH2454",
      "maskLibraryName" : "FlyLight Split-GAL4 Drivers",
      "maskSampleRef" : null,
      "maskRelatedImageRefId" : null,
      "maskImageURL" : null,
      "results" : [ 
        (this will be empty)
      ]
    }



input file must be the output json file from find-missing-results.py script

the other input parameter is the directory into which to write the files; this
    is typically the appropriate cdsresults.final/ subdirectory

usage: populate-missing-results.py <inputfile> <final results directory>

"""

# imports
import json
import os
import sys



def writeresults(missing, resultsdir):

    missingIDs = missing["missing-results"]
    libs = missing["missing-results-libraries"]

    for name in missingIDs:
        library = libs[name]
        for mipID in missingIDs[name]:
            searchresult = {
                "maskId": mipID,
                "maskPublishedName": name,
                "maskLibraryName": library,
                "maskSampleRef": None,
                "maskRelatedImageRefId": None,
                "maskImageURL": None,
                "results" : [ ]
                }
            path = os.path.join(resultsdir, mipID + ".json")
            with open(path, 'wt') as f:
                json.dump(searchresult, f)


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

    missing = json.loads(open(inputpath, 'rt').read())
    writeresults(missing, resultsdir)


# script start
if __name__ == '__main__':
    main()
