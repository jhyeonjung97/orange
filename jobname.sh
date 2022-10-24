#!/bin/bash

read -p "job name: " a
read -p "how many: " b
if [[ -z $b ]]; then
    sed -i "/job-name/c\#SBATCH --job-name=\"$a\"" run_slurm.sh
else
    for i in {0..$b}
    do
    sed -i "/job-name/c\#SBATCH --job-name=\"$a$c\"" $c*/run_slurm.sh
    done
fi
