#!/bin/bash

if [[ $1 =~ '-h' ]] || [[ -z $2 ]] || [[ $extension != 'inp' ]]; then
    echo 'usage: seed [FILENAME.inp] [SEED] [lattice A, B, C]'
    exit 1
fi

filename="${1%.*}"
extension="${1##*.}"
shift

SET=$(seq 1 $1)
shift

a=$1
b=$2
c=$3
if [[ -z $a ]]; then
    echo 'use default lattice parameter 30 A, 30 A, 40 A...'
    a=30.
    b=30.
    c=40.
else
    if [[ ! $a =~ '.' ]]; then
        a=$a.
    fi
    if [[ ! $b =~ '.' ]]; then
        b=$b.
    fi
    if [[ ! $c =~ '.' ]]; then
        c=$c.
    fi
fi

for i in $SET
do
    sed "/output/c\output $filename$i" $filename.inp
    sed "/seed/c\seed $i" $filename.inp
    ~/bin/packmol/packmol < $filename.inp
done

python3 ~/bin/orange/convert.py xyz vasp $a $b $c