#!/usr/bin/env python
"""

retrieve an authentication token for JACS; prompt user for password and print token to std out

intended use it to put it in an env variable:

    MYTOKEN=$(./get-jacs-token.py)

note that the password prompt does NOT get captured in the variable, as is desired

"""

# std lib
import getpass
import json
import sys

# required third-party library
import requests

# authentication service
authurl = "https://workstation.int.janelia.org/SCSW/AuthenticationService/v1/authenticate"

username = getpass.getuser()
pwd = getpass.getpass("Enter your password for JACS; this is usually your Janelia password:")

r = requests.post(authurl, json={"username": username, "password": pwd}, verify=False)
if (r.status_code != requests.codes.OK):
    print("Request for token failed with status ", r.status_code, file=sys.stderr)
    print("Message: ", r.text, file=sys.stderr)
else:
    token = r.json()["token"]
    print(token)