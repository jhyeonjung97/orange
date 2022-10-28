#!/bin/bash

~/bin/packmol/packmol < $1

extension="${1##*.}"
filename="${1%.*}"

mv mixture.xyz $filename.xyz

python3 ~/bin/orange/xyz2hex.py $filename.xyz

#echo "scp $filename.vasp hailey@134.79.69.172:~/Desktop/au"
#scp $filename.vasp hailey@134.79.69.172:~/Desktop/au

sed -n 6p $filename.vasp >> temp1
sed 1d $filename.vasp >> temp2
cat temp1 temp2 > $filename.vasp
rm temp1 temp2

echo "cp $filename.vasp ~/port/"
cp $filename.vasp ~/port/