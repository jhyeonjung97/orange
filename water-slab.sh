#!/bin/bash

if [[ $1 =~ '-h' ]] || [[ $1 == '*.inp' ]] || [[ -z $2 ]]; then
    # echo 'usage: sh ~/bin/orange/water-slab.sh {a} {b} {top} {number} {seed} {output}'
    exit 1
fi

a=$1; shift
b=$1; shift
top=$1; shift
number=$1; shift
seed=$1; shift
output=$1; shift

cp ~/input_files/water.xyz .
cp ~/input_files/water-slab.inp .
sed -i "/number/c\  number $number" water-slab.inp
sed -i "/inside/c\  inside box 0. 0. 0. $a $b $top" water-slab.inp

for i in $(seq 1 $seed)
do
    sed -i "/output/c\output $output$i.xyz" water-slab.inp
    sed -i "/seed/c\seed $i" water-slab.inp
    ~/bin/packmol/packmol < water-slab.inp
done

python3 ~/bin/orange/convert.py xyz vasp $a $b $top