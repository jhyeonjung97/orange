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
    for i in $(seq $1 $2)
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