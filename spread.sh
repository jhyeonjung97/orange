#!/bin/bash

SET='*/'
file=$1

if [[ -n $2 ]]; then
    file=$2
    for i in $((seq 2 $1)); do
        SET+='*/'
    done
fi

for dir in $SET; do
    cp $file $dir
done