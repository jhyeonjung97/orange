#!/bin/bash


function submit {
    if [[ -z $(grep pw.x run_slurm.sh) ]] ; then
        sed -i "/NPAR/c\NPAR   = ${npar}" INCAR
        grep NPAR INCAR
        grep Selective POSCAR
        grep MAGMOM INCAR
        if [[ -n $(grep walltime run_slurm.sh | grep 120) ]]; then
            sed -i 's/max_seconds = 170000/max_seconds = 430000/' incar.in
            sed -i 's/max_seconds = 170000/max_seconds = 430000/' qe-relax.in
        elif [[ -n $(grep walltime run_slurm.sh | grep 48) ]]; then
            sed -i 's/max_seconds = 430000/max_seconds = 170000/' incar.in
            sed -i 's/max_seconds = 430000/max_seconds = 170000/' qe-relax.in
        fi
    fi
    if [[ ${account} == 'x2347a10' ]]; then
        sed -i -e 's/x2431a10/x2347a10/g' run_slurm.sh
        qsub run_slurm.sh
    elif [[ ${account} == 'x2431a10' ]]; then
        sed -i -e 's/x2347a10/x2431a10/g' run_slurm.sh
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