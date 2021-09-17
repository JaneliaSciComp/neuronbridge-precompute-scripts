#!/usr/bin/env python
"""

create a json file to give Rob for image upload; go through a directory of 
individual MIPS and find those with blank "imageURL" field; then filter the
aggregate MIPs json and only leave those that don't have "imageURL" in the
individual MIPs (since all the agg json MIPs probably have it, whether the
image has been uploaded or not)

this will be used to prepare a json file to give to Rob, who will upload the files and 
put the URL in the db for later retrieval back into the individual MIPs

usage:

    filter-json-for-upload.py inputjsondir inputjsonpath outputjsonpath

"""

# std lib
import json
import os
import sys



def main():
    if len(sys.argv) < 4:
        print("usage: filter-json-for-upload.py inputjsondir inputjsondir inputjsonpath outputjsonpath")
        sys.exit(1)

    inputdir = sys.argv[1]
    inputpath = sys.argv[2]
    outputpath = sys.argv[3]

    if not os.path.exists(inputdir):
        print(f"input dir {inputdir} does not exist")
        sys.exit(1)

    if not os.path.exists(inputpath):
        print(f"input path {inputpath} does not exist")
        sys.exit(1)

    if inputpath == outputpath:
        print("cannot overwrite input file!  input and output file paths must be different")
        sys.exit(1)

    # first go through the individuals:
    missing = set()
    mipfilenames = os.listdir(inputdir)
    for fn in mipfilenames:
        path = os.path.join(inputdir, fn)
        data = json.loads(open(path, 'rt').read())
        for item in data["results"]:
            if "imageURL" not in item or item["imageURL"] == "":
                missing.add(item["id"])
    print(f"found {len(missing)} IDs without 'imageURL'")

    # now filter the big file
    data = json.loads(open(inputpath, 'rt').read())
    newdata = [item for item in data if item["id"] in missing]
    with open(outputpath, 'wt') as f:
        json.dump(newdata, f, indent=2)


if __name__ == '__main__':
    main()
