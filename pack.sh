#!/bin/bash

if [[ $1 =~ '-h' ]]; then
    echo 'usage: pack.sh [filename.inp] [seed]'
    exit 1
fi

if [[ -z $3 ]]; then
    SET=$(seq 1 $2)
else
    SET=$(seq $2 $3)
fi

filename="${1%.*}"
for i in $SET
do
    sed -i -e "/output/c\output $filename$i.xyz" $1
    sed -i -e "/seed/c\seed $i" $1
    ~/bin/packmol/packmol < $1
done

read -p "lattice parameter (A): " a
if [[ -z $a ]]; then
    echo 'use default lattice parameter, 40 A ...'
    a=40.
elif [[ ! $a =~ '.' ]]; then
    a=$a.
fi
python3 ~/bin/orange/convert.py xyz vasp $a