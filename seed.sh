#!/bin/bash

if [[ -z $2 ]]; then
    echo 'usage: seed [FILENAME.inp] [SEED]'
    break
else
    filename="${1%.*}"
    extension="${1##*.}"

    sed "/seed/c\seed $2" $1 > $filename$2.inp
fi