#!/bin/bash

# Usage: ./extract_magnetization.sh input_file

# Check if input file is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 OUTCAR"
    exit 1
fi

# Extract part between 'magnetization (x)' and 'tot ~~~'
awk '/magnetization \(x\)/,/tot /' "$1"
