#!/bin/bash

if [[ $1 =~ '-h' ]] || [[ $1 == '*.inp' ]] || [[ -z $2 ]]; then
    # echo 'usage: seed [FILENAME.inp] [SEED] [lattice A, B, C]'
    exit 1
fi

filename="${1%.*}"
extension="${1##*.}"
# echo $filename $extension
shift

SET=$(seq 1 $1)
# echo $SET
shift

a=$1
shift
b=$1
shift
c=$1
shift
if [[ -z $a ]]; then
    echo 'use default lattice parameter 30 A, 30 A, 40 A...'
    a=30.
    b=30.
    c=40.
else
    if [[ $a != '*.*' ]]; then
        a=$a.0
    fi
    if [[ $b != '*.*' ]]; then
        b=$b.0
    fi
    if [[ $c != '*.*' ]]; then
        c=$c.0
    fi
fi
# echo $a $b $c

for i in $SET
do
    # echo $i
    sed -i "/output/c\output $filename$i.xyz" $filename.inp
    # echo "sed \"/output/c\output $filename$i.xyz\" $filename.inp"
    sed -i "/seed/c\seed $i" $filename.inp
    # echo "sed \"/seed/c\seed $i\" $filename.inp"
    ~/bin/packmol/packmol < $filename.inp
done

python3 ~/bin/verve/convert.py xyz traj $a $b $c