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
    if [[ -z $2 ]]; then
        a=1
        b=$1
    else
        a=$1
        b=$2
    fi
    
    for i in $(seq $a $b)
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