#!/bin/bash

if [[ $1 =~ '-h' ]]; then
    echo 'usage: mmff [filename.extention]'
fi

name="${1%.*}"
ext="${1##*.}"

a=$2
b=$3
c=$4
if [[ -z $a ]]; then
    read -p 'lattice parameter? (A) ' a
fi
if [[ -z $a ]]; then
    echo 'use default lattice parameter 50 A...'
    a=50.
fi

# if [[ -f $name.$ext ]]; then
#     # python ~/bin/orange/cluster.py $name.$ext $name.xyz $a
#     # obabel $name.xyz -O $name.mol2
#     if [[ $ext != 'mol2' ]]; then
#         obabel $name.$ext -O $name.mol2
#     fi
#     obminimize -n 10000000000 -sd -c 1e-10 -ff MMFF94s $name.mol2 > $name.pdb
# fi
    
for file in *
do
    name0="${file%.*}"
    ext0="${file##*.}"
    if [[ $name0 =~ $name ]] && [[ $ext0 == $ext ]]; then
        # python ~/bin/orange/cluster.py $name$i.$ext $name$i.xyz $a
        # obabel $name$i.xyz -O $name$i.mol2
        i=${file//[$name,'.',$ext]/}
        if [[ $ext != 'mol2' ]]; then
            obabel $name$i.$ext -O $name$i.mol2
            echo "obabel $name$i.$ext -O $name$i.mol2"
        fi
        obminimize -n 10000000000 -sd -c 1e-10 -ff MMFF94s $name$i.mol2 > $name$i.pdb
        echo "obminimize -n 10000000000 -sd -c 1e-10 -ff MMFF94s $name$i.mol2 > $name$i.pdb"
        # python ~/bin/orange/cluster.py $name$i.pdb $name$i.xyz $a
    fi
done

python3 ~/bin/orange/convert.py pdb xyz $a $b $c
python3 ~/bin/orange/convert.py xyz vasp $a $b $c
cp $name$i.vasp POSCAR