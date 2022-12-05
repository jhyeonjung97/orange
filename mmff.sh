#!/bin/bash

extension="${1##*.}"
filename="${1%.*}"

if [[ -f $1 ]]; then
    obminimize -n 100000 -sd -c 1e-10 -ff MMFF94s $1 > $filename.pdb
fi
    
for i in {0..9}
do
    if [[ -f $filename$i.mol2 ]]; then
        obminimize -n 100000 -sd -c 1e-10 -ff MMFF94s $filename$i.mol2 > $filename$i.pdb
    fi
done