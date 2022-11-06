#!/bin/bash

# error cases
if [[ ! -e "INCAR" ]]; then
    echo "don't forget INCAR.."
    incar
    exit 1
elif [[ ! -e "KPOINTS" ]]; then
    echo "don't forget KPOINTS.."
    k
    exit 2
elif [[ ! -e "run_slurm.sh" ]]; then
    echo "don't forget run_slurm.sh.."
    run
    exit 3
elif [[ -z $1 ]]; then
    echo 'usage: autosub (directory#1) [directory#2]'
fi

if [[ $1 == '-s' ]] || [[ $1 == '-select' ]]; then
    SET=${@:2}
elif [[ $1 == '-n' ]] || [[ $1 == '-non' ]]; then
    if [[ -z $3 ]]; then
        SET=$(seq 1 $2)
    else
        SET=$(seq $2 $3)
    fi
elif [[ -z $2 ]]; then
    SET=$(seq 1 $1)
else
    SET=$(seq $1 $2)
fi
    
read -p "POSCARs starts with: " p
read -p "job name: " n

for i in $SET
do
    if [[ ! -d $i ]]; then
        mkdir $i
    fi
    cp INCAR KPOINTS run_slurm.sh $i
    cp $p$i.vasp $i/POSCAR
    cd $i
    python ~/bin/pyband/xcell.py #XCELL
    mv out*.vasp POSCAR #XCELL
    python3 ~/bin/orange/magmom.py
    sh ~/bin/orange/vasp5.sh
    python3 ~/bin/shoulder/potcar_ara.py
    sh ~/bin/orange/jobname.sh $n$i
    cd ..
done

read -p 'do you want to submit jobs? [y/n] (default: y) ' submit
for i in $SET
do
    cd $i
    sh ~/bin/orange/sub.sh
    cd ..
done