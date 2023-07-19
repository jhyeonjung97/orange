#!/bin/bash


function submit {
    if [[ -n $(grep pw.x run_slurm.sh) ]] ; then
        if [[ -n $(grep walltime run_slurm.sh | grep 120) ]]; then
            sed -i 's/max_seconds = 170000/max_seconds = 430000/' incar.in
        elif [[ -n $(grep walltime run_slurm.sh | grep 48) ]]; then
            sed -i 's/max_seconds = 430000/max_seconds = 170000/' incar.in
        fi
        sed -i -e "s/x2658a09/${account}/g" incar.in
        sed -i -e "s/x2347a10/${account}/g" incar.in
        sed -i -e "s/x2431a10/${account}/g" incar.in
        sed -i -e "s/x2421a04/${account}/g" incar.in
    else
        if [[ -z $(grep POTIM INCAR) ]] || [[ -n $(grep POTIM INCAR | grep 0.015) ]]; then
            sed -i "/NPAR/c\NPAR   = ${npar}" INCAR
        fi
        grep NPAR INCAR
        grep Selective POSCAR
        grep MAGMOM INCAR
    fi
    if [[ ${here} == 'kisti' ]]; then
        sed -i -e "s/x2658a09/${account}/g" run_slurm.sh
        sed -i -e "s/x2347a10/${account}/g" run_slurm.sh
        sed -i -e "s/x2431a10/${account}/g" run_slurm.sh
        sed -i -e "s/x2421a04/${account}/g" run_slurm.sh
        qsub run_slurm.sh
    else
        sed -i -e "s/  / /g" INCAR
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