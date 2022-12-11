#!/bin/bash

if [[ -z $(grep DONE stdout.log) ]]; then
    sed -i 's/from_scratch/restart/' incar.in
    sed -i 's/from_scratch/restart/' qe-relax.in
    i=1
    while [[ -f "stdout$i.log" ]] || [[ -f "contcar$i.xyz" ]]
    do
        i=$(($i+1))
    done
    sh ~/bin/orange/out2xyz.sh
    cp contcar.xyz contcar$i.xyz
    cp stdout.log stdout$i.log
    if [[ ${here} == 'burning' ]]; then
        sbatch run_slurm.sh
    elif [[ ${here} == 'nurion' ]]; then
        sed -i -e 's/x2431a10/x2347a10/' *
        qsub run_slurm.sh
    elif [[ ${here} == 'kisti' ]]; then
        sed -i -e 's/x2347a10/x2431a10/' *
        qsub run_slurm.sh
    else
        echo 'where am i..? please modify [conti-qe.sh] code'
        exit 1
    fi
fi