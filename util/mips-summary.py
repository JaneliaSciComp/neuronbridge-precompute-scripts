#!/bin/env python

# create a summary of MIPs; iterate through all the files and print
#   to std out: 
#       file - publishedName - MIP ID
#   for all entries; there will be multiple lines in the file for some published names, 
#   as it's one to many; for EM, should be one MIP ID per body ID = published name


import json
import os
import time

mipsdir = "/nrs/neuronbridge/v2.2/mips"

libs = {
    "em": "em_bodies",
    "mcfo": "gen1_mcfo_lines",
    "sg4": "split_gal4_lines",
}

print("# summary of mips; grep through this file to match MIP ID to published names")
print(f"generated {time.asctime()}")
for tag, dirname in libs.items():
    libdir = os.path.join(mipsdir, dirname)
    for filename in os.listdir(libdir):
        filepath = os.path.join(libdir, filename)
        data = json.loads(open(filepath, 'rt').read())
        idlist = data["results"]
        for item in idlist:
            print(f"{tag} - {item['publishedName']} - {item['id']}")

