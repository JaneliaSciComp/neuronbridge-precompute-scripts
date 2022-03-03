#!/bin/env python
"""
when doing attribute splicing, it's nice to only do it once; this script
takes three aggregate mips files and effectively concatenates them into one

script checks that there are no duplicated MIP IDs

usage: collect-mips.py; you should edit the filenames in the script before running!

"""

import itertools
import json
import os
import sys

# list of mips files to collect together
mipspaths = [
    "/nrs/neuronbridge/v-test-djo/brain/mips/split_gal4.json+imageStack",
    "/nrs/neuronbridge/v-test-djo/brain/mips/mcfo.json+imageStack",
    "/nrs/neuronbridge/v-test-djo/brain/mips/annotator_gen1_mcfo_brain.json+imageStack",
    ]

# output filename
outputmipsfile = "/nrs/neuronbridge/v-test-djo/brain/mips/collected+imageStack.json"


def main():
    # check input paths; note that we will silently overwrite an existing output file!
    for path in mipspaths:
        if not os.path.exists(path):
            print(f"{path} does not exists")
            sys.exit(1)

    data = {}
    for path in mipspaths:
        data[path] = json.loads(open(path, 'rt').read())

    # check for duplicate IDs
    IDsets = {}
    for path in data:
        IDsets[path] = set(mip["id"] for mip in data[path])

    # itertools.combinations() produces all unique pairs from list
    duplicates = False
    for path1, path2 in itertools.combinations(mipspaths, 2):
        if not IDsets[path1].isdisjoint(IDsets[path2]):
            duplicates = True
            print(f"{path1} and {path2} have common IDs")

    # if we're clear, go ahead and concatenate all the MIP lists
    if duplicates:
        print("duplicate IDs found; no output written")
    else:
        newdata = []
        for path in mipspaths:
            newdata.extend(data[path])
        with open(outputmipsfile, 'wt') as f:
            json.dump(newdata, f, indent=2)

if __name__ == '__main__':
    main()