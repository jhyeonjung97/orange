#!/bin/bash

extension1="${1##*.}"
filename1="${1%.*}"

extension2="${2##*.}"
filename2="${2%.*}"

for i in {0..9}
do
    if [[ -e $filename1$i.$extension1 ]]; then
        mv $filename1$i.$extension1 $filename2$i.$extension2
    fi
done