#!/bin/bash

if [[ $1 =~ '-h' ]]; then
    echo 'usage: mmff [filename.extention (ex. cation.xyz)] lattice a, b, c'
    exit 1
fi

name="${1%.*}"
ext="${1##*.}"
shift

a=$1
b=$2
c=$3
if [[ -z $a ]]; then
    echo 'use default lattice parameter 30 A, 30 A, 40 A...'
    a=30.
    b=30.
    c=40.
fi

for i in {0..9}
do
    echo "obabel $name$i.$ext -O $name$i.mol2"
    obabel $name$i.$ext -O $name$i.mol2
    echo "obminimize -n 100000000 -sd -c 1e-10 -ff MMFF94s $name$i.mol2 > $name$i.pdb"
    obminimize -n 100000000 -sd -c 1e-8 -ff MMFF94s $name$i.mol2 > $name$i.pdb
done

python3 ~/bin/orange/convert.py pdb json $a $b $c

if [[ -n $(grep mmff.sh run_slurm.sh) ]] && [[ -n $(grep mpiexe run_slurm.sh) ]]; then
    cp $name$i.vasp POSCAR
    python ~/bin/pyband/xcell.py #XCELL
    mv out*.vasp POSCAR #XCELL
    sh ~/bin/orange/vasp5.sh
    if [[ -s POTCAR ]]; then
        rm POTCAR
    fi
    vaspkit -task 103
    if [[ ! -s POTCAR ]]; then
        python3 ~/bin/shoulder/potcar_ara.py
    fi
    if [[ -n $(grep cep-sol.sh run_slurm.sh) ]]; then
        sh ~/bin/orange/nelect.sh
    fi
fi