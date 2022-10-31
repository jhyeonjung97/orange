#!/bin/bash

if [[ -z $2 ]]; then
    sed -i "/#SBATCH --job-name/c\#SBATCH --job-name=\"$1\"" run_slurm.sh
    sed -i "/#PBS -N/c\#PBS -N $1" run_slurm.sh
else
    for i in {$1..$2}
    do
    sed -i "/#SBATCH --job-name/c\#SBATCH --job-name=\"$2$i\"" $i*/run_slurm.sh
    sed -i "/#PBS -N/c\#PBS -N $2$i" $i*/run_slurm.sh
    done
fi
