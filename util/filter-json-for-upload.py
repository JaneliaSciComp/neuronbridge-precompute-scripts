#!/usr/bin/env python
"""

filter an aggregate mips json file (which just conatins a list of mip structs) so 
the output file only contains the entries that do not contain a populated (not empty)
"imageURL" field

this will be used to prepare a json file to give to Rob, who will upload the files and 
put the URL in the db for later retrieval back into a file like this

usage:

    filter-json-for-upload.py inputjsonpath outputjsonpath

"""

# std lib
import json
import os
import sys



def main():
    if len(sys.argv) < 3:
        print("usage: filter-json-for-upload.py inputjsonpath outputjsonpath")
        sys.exit(1)

    inputpath = sys.argv[1]
    outputpath = sys.argv[2]

    if not os.path.exists(inputpath):
        print(f"input path {inputpath} does not exist")
        sys.exit(1)

    if inputpath == outputpath:
        print("cannot overwrite input file!  input and output file paths must be different")
        sys.exit(1)

    data = json.loads(open(inputpath, 'rt').read())
    newdata = [item for item in data if "imageURL" not in item or item["imageURL"] == ""]
    with open(outputpath, 'wt') as f:
        json.dump(newdata, f, indent=2)


if __name__ == '__main__':
    main()