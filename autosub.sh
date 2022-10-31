#!/bin/bash

if [[ ! -e "INCAR" ]]; then
    echo "don't forget INCAR.."
    incar
    break
elif [[ ! -e "KPOINTS" ]]; then
    echo "don't forget KPOINTS.."
    k
    break
elif [[ ! -e "run_slurm.sh" ]]; then
    echo "don't forget run_slurm.sh.."
    run
    break
elif [[ -z $1 ]]; then
    echo 'usage: autosub (directory#1) [directory#2]'
else
    if [[ -z $2 ]]; then
        a=0
        b=$1
    else
        a=$1
        b=$2
    fi
    
    read -p "POSCARs starts with: " p
    read -p "job name: " n
    
    for i in $(seq $a $b)
    do
        mkdir $i
        cp INCAR KPOINTS run_slurm.sh $i
        cp $p$i.vasp $i/POSCAR
        
        cd $i
        python ~/bin/pyband/xcell.py #XCELL
        mv out*.vasp POSCAR #XCELL
        python3 ~/bin/orange/magmom.py
        
        sh ~/bin/orange/vasp5.sh
        python3 ~/bin/shoulder/potcar_ara.py
        
        sh ~/bin/orange/jobname.sh $n$i
        sh ~/bin/orange/sub.sh
        cd ..
    done
fi