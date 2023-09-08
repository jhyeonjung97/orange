#!/bin/bash

if [[ $1 =~ '-h' ]]; then
    echo 'usage: mmff [filename.extention (ex. cation.xyz)] lattice a, b, c'
    exit 1
fi

name="${1%.*}"
ext="${1##*.}"
shift
# echo $name $ext

a=$1
b=$2
c=$3
if [[ -z $a ]]; then
    echo 'use default lattice parameter 30 A, 30 A, 40 A...'
    a=30.
    b=30.
    c=40.
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
    # echo $name0 $ext0
    if [[ $name0 =~ $name ]] && [[ $ext0 == $ext ]]; then
        # python ~/bin/orange/cluster.py $name$i.$ext $name$i.xyz $a
        # obabel $name$i.xyz -O $name$i.mol2
        i=${name0//$name/}
        if [[ $ext != 'mol2' ]]; then
            echo "obabel $name$i.$ext -O $name$i.mol2"
            obabel $name$i.$ext -O $name$i.mol2
        fi
        echo "obminimize -n 100 -sd -c 1e-10 -ff MMFF94s $name$i.mol2 > $name$i.pdb"
        obminimize -n 100 -sd -c 1e-10 -ff MMFF94s $name$i.mol2 > $name$i.pdb
        # obminimize -n 10000000000 -sd -c 1e-10 -ff MMFF94s a1.mol2 > a1.pdb
        # python ~/bin/orange/cluster.py $name$i.pdb $name$i.xyz $a
    fi
done

python3 ~/bin/orange/convert.py pdb vasp $a $b $c

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