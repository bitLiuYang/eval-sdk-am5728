#!/bin/bash

# Usage: my-import.sh <input-abi-pathname>

# NOTE: Start from the "samples" directory containing the "current" directory
# to be imported

mkdir current-imported
cd current-imported; (cd ../current; find . -type d ! -name .) |xargs mkdir
cd ../current; mv stats ../StatsSave; find . -type f | while read line; do opimport  -a $1 -o ../current-imported/$line $line; done; mv ../StatsSave stats;
