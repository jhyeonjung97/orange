#!/bin/bash

filename="${1%.*}"
extension="${1##*.}"

echo $filename
echo $extension

sed "/seed/c\seed $2" $1 #> $filename$2.inp