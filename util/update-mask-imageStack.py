#!/bin/env python
"""
we need to do a one-off splicing of the imageStack attribute onto the mask part
of search results; the standard replaceAttributes tool can't do this


usage: update-mask-imageStack.py inputjson inputfolder outputfolder

"""

import json
import os
import sys


def main():
    if len(sys.argv) < 4:
        print("usage: update-mask-imageStack.py inputjson inputfolder outputfolder")
        sys.exit(1)
    inputjson = sys.argv[1]
    inputfolder = sys.argv[2]
    outputfolder = sys.argv[3]

    if not os.path.exists(inputjson):
        print(f"{inputjson} doesn't exist")
        sys.exit(1)
    if not os.path.exists(inputfolder):
        print(f"{inputfolder} doesn't exist")
        sys.exit(1)
    if os.path.exists(outputfolder):
        print(f"{outputfolder} already exists")
        sys.exit(1)
    os.mkdir(outputfolder)

    # build {id: imageStack} 
    data = json.loads(open(inputjson, 'rt').read())
    imageStacks = {mip["id"]: mip["imageStack"] for mip in data if "imageStack" in mip}

    files = os.listdir(inputfolder)
    for f in files:
        inputpath = os.path.join(inputfolder, f)
        data = json.loads(open(inputpath, 'rt').read())
        if data["maskId"] in imageStacks:
            data["maskImageStack"] = imageStacks[data["maskId"]]    
        outputpath = os.path.join(outputfolder, f)
        with open(outputpath, 'wt') as f:
            json.dump(data, f)

if __name__ == '__main__':
    main()