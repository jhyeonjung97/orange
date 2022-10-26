#!/bin/bash

if [[ -z $2 ]] && [[ $1 == '-r' ]]; then
    sed -i "/job-name/c\#SBATCH --job-name=\"$1\"" run_slurm.sh
else
    for i in {0..9}
    do
    if [[ -e $i ]]; then
        sed -i "/job-name/c\#SBATCH --job-name=\"$2$i\"" $i*/run_slurm.sh
    fi
    done
fi
