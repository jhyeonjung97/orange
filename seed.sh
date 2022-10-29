#!/bin/bash

extension="${1##*.}"
filename="${1%.*}"

echo $filename
echo $extension

sed "/seed/c\seed $2" $1 > $filename$2.inp