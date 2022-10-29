#!/bin/bash

filename="${1%.*}"
extension="${1##*.}"

echo $filename
echo $extension
echo $1
echo $2

sed "/seed/c\seed $2" $1 #> $filename$2.inp