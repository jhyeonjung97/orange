#!/bin/bash

# error cases
if [[ ! -e "incar.in" ]]; then
    echo "don't forget INCAR.."
    exit 2
elif [[ ! -e "kpoints.in" ]]; then
    echo "don't forget KPOINTS.."
    exit 2
elif [[ ! -e "run_slurm.sh" ]]; then
    echo "don't forget run_slurm.sh.."
    if [[ $here == 'burning' ]]; then
        sh ~/bin/orange/run-burning.sh
    elif [[ $here == 'kisti' ]] || [[ $here == 'nurion' ]]; then
        sh ~/bin/orange/run-nurion.sh
    fi
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
    
read -p "poscar.cif files starts with: " p
read -p "job name: " n

for i in $SET
do
    if [[ ! -d $i ]]; then
        mkdir $i
    fi
    cp incar.in kpoints.in run_slurm.sh $p$i.in $i
    cd $i
    sh ~/bin/orange/relax.sh $p
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