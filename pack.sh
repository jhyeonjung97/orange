#!/bin/bash

~/bin/packmol/packmol < $1

extension="${1##*.}"
filename="${1%.*}"

mv mixture.xyz $filename.xyz

python3 ~/bin/orange/xyz2hex.py $filename.xyz

#echo "scp $filename.vasp hailey@134.79.69.172:~/Desktop/au"
#scp $filename.vasp hailey@134.79.69.172:~/Desktop/au

echo "cp $filename.vasp ~/port/"
cp $filename.vasp ~/port/