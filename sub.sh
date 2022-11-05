#!/bin/bash


function submit {
    sed -i "/NPAR/c\NPAR   = ${npar}" INCAR
    grep NPAR INCAR
    grep Selective POSCAR
    grep MAGMOM INCAR 
    if [[ ${here} == 'nurion' ]] || [[ ${here} == 'kisti' ]]; then
        qsub run_slurm.sh
    else
        sbatch run_slurm.sh
    fi
    }

if [[ -z $1 ]]; then # simple submit
    submit
else
    if [[ $1 == '-r' ]] || [[ $1 == 'all' ]]; then
        DIR='*/'
    elif [[ $1 == '-s' ]] || [[ $1 == '-select' ]]; then
        DIR=${@:2}
    elif [[ -z $2 ]]; then
        DIR=$(seq 1 $1)
    else
        DIR=$(seq $1 $2)
    fi
    
    for i in $DIR
    do
        i=${i%/}
        cd $i*
        submit
        cd ..
    done
fi