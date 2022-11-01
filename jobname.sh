#!/bin/bash

if [[ $1 =~ '-h' ]] || [[ $1 =~ '--h' ]] || [[ -z $1 ]]; then
    echo 'usage: name (-r) [jobname] (dir#1) (dir#2)'
    exit 1
fi

if [[ $1 == '-r' ]]; then

    if [[ -z $2 ]]; then
        echo 'usage: name (-r) [jobname] (dir#1) (dir#2)'
        exit 1
    elif [[ -z $3 ]]; then
        a=0; b=9
    elif [[ -z $4 ]]; then
        a=1; b=$3
    elif [[ -z $5 ]]; then
        a=$3; b=$4
    else
        echo 'usage: name (-r) [jobname] (dir#1) (dir#2)'
        exit 1
    fi
    
    for i in $(seq $a $b)
    do
    sed -i "/#SBATCH --job-name/c\#SBATCH --job-name=\"$2$i\"" $i*/run_slurm.sh
    sed -i "/#PBS -N/c\#PBS -N $2$i" $i*/run_slurm.sh
    done
    
elif [[ -z $2 ]]; then
    sed -i "/#SBATCH --job-name/c\#SBATCH --job-name=\"$1\"" run_slurm.sh
    sed -i "/#PBS -N/c\#PBS -N $1" run_slurm.sh
    
else
    echo 'usage: name (-r) [jobname] (number)'
    exit 1
fi

