#!/bin/bash

if [[ -z $1 ]]; then
    sed -i "/NPAR/c\NPAR   = ${npar}" INCAR
    grep NPAR INCAR
    grep Selective POSCAR
    grep MAGMOM INCAR
    if [[ ${here} == 'nurion' ]] || [[ ${here} == 'kisti' ]]; then
        qsub run_slurm.sh
    else
        sbatch run_slurm.sh
    fi
    cd ..
    
else
    if [[ -z $2 ]] && ( [[ $1 == '-r' ]] || [[ $1 == 'all' ]] ) ; then
        DIR='*/'
    elif [[ -z $2 ]]; then
        DIR=$(seq 1 $1)
    else
        DIR=$(seq $1 $2)
    fi
    
    for i in $DIR
    do
        cd $i*
        sed -i "/NPAR/c\NPAR   = ${npar}" INCAR
        grep NPAR INCAR
        grep Selective POSCAR
        grep MAGMOM INCAR 
        if [[ ${here} == 'nurion' ]] || [[ ${here} == 'kisti' ]]; then
            qsub run_slurm.sh
        else
            sbatch run_slurm.sh
        fi
        cd ..
    done
fi