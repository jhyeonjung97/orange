#!/bin/bash

name="${1%.*}"
ext="${1##*.}"

a=$2

if [[ -z $a ]]; then
    read -p 'lattice parameter? (A) ' a
fi

if [[ -z $a ]]; then
    echo 'use default lattice parameter 30 A...'
    a=30.
fi

if [[ -f $name.$ext ]]; then
    python ~/bin/orange/cluster.py $name.$ext $name.xyz $a
    obabel $name.xyz -O $name.mol2
    obminimize -n 100000 -sd -c 1e-10 -ff MMFF94s $name.mol2 > $name.pdb
    python ~/bin/orange/cluster.py $name.pdb $name.xyz $a
fi
    
for i in {0..9}
do
    if [[ -f $name$i.$ext ]]; then
        python ~/bin/orange/cluster.py $name$i.$ext $name$i.cif $a
        # echo "python ~/bin/orange/cluster.py $name$i.$ext $name$i.cif $a"
        obabel $name$i.cif -O $name$i.mol2
        # echo "obabel $name$i.cif -O $name$i.mol2"
        obminimize -n 100000 -sd -c 1e-10 -ff MMFF94s $name$i.mol2 > $name$i.pdb
        python ~/bin/orange/cluster.py $name$i.pdb $name$i.xyz $a
    fi
done