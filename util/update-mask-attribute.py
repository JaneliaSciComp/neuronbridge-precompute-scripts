#!/bin/env python
"""
we need to splice of attributes onto the mask part of search results; the 
standard replaceAttributes tool can't do this

to use, edit the constants, then run the scipt

usage: update-mask-attribute.py inputjson inputdir outputdir


revisions:
- original was hard-coded for "imageStack" attribute
- generalized for any single attribute, but still need to edit constants in script

future potential improvements:
- allow update of more than one attribute
- take attribute mapping as input instead of needing to edit script

"""

# imports
import collections
import json
import multiprocessing
import os
import sys
import time

# constants

# user should update these two constants:
SOURCEATTRIBUTE = "screenImage"
DESTINATIONATTRIBUTE = "maskScreenImage"

# these will likely never change
SOURCEID = "id"
DESTINATIONID = "maskId"



# note that start is inclusive, end is exclusive, like normal Python array indexing
Batch = collections.namedtuple("Batch", ['inputjson', 'inputdir', 'outputdir', 'start', 'end'])

def runbatch(batch):
    print(f"batch {batch.start} starting at {time.asctime()}")
    # build {id: attribute} 
    data = json.loads(open(batch.inputjson, 'rt').read())
    imageAttrs = {mip[SOURCEID]: mip[SOURCEATTRIBUTE] for mip in data if SOURCEATTRIBUTE in mip}

    files = os.listdir(batch.inputdir)
    for f in files[batch.start:batch.end]:
        inputpath = os.path.join(batch.inputdir, f)
        data = json.loads(open(inputpath, 'rt').read())
        if data[DESTINATIONID] in imageAttrs:
            data[DESTINATIONATTRIBUTE] = imageAttrs[data[DESTINATIONID]]    
        outputpath = os.path.join(batch.outputdir, f)
        with open(outputpath, 'wt') as f:
            json.dump(data, f, indent=2)
    print(f"batch {batch.start} ending at {time.asctime()}")


def main():
    if len(sys.argv) < 4:
        print("usage: update-mask-attribute.py inputjson inputdir outputdir")
        sys.exit(1)
    inputjson = sys.argv[1]
    inputdir = sys.argv[2]
    outputdir = sys.argv[3]

    if not os.path.exists(inputjson):
        print(f"{inputjson} doesn't exist")
        sys.exit(1)
    if not os.path.exists(inputdir):
        print(f"{inputdir} doesn't exist")
        sys.exit(1)
    if os.path.exists(outputdir):
        print(f"{outputdir} already exists")
        sys.exit(1)
    os.mkdir(outputdir)

    # non-parallel for testing:
    # b = Batch(inputjson, inputdir, outputdir, 0, -1)
    # runbatch(b)

    # parallel:
    # hardcoded batching; number of files in v2.4.0/brain/cdsresults.final/flylight-vs-flyem is 
    #   just under 240k; last time, doing 30 x 8000 seemed to overload something, so dial back
    #   to fewer jobs than physical cores (which is 20)
    nbatches = 16
    batchsize = 15000
    batches = [Batch(inputjson, inputdir, outputdir, i * batchsize, (i + 1) * batchsize)
        for i in range(nbatches)]
    with multiprocessing.Pool(nbatches) as p:
        p.map(runbatch, batches)


if __name__ == '__main__':
    main()
