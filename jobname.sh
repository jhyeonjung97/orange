#!/bin/bash

function usage_error {
    echo 'usage: name (-r) [jobname] (dir#1) (dir#2)'
    exit 1
}

if [[ $1 =~ '-h' ]] || [[ $1 =~ '--h' ]] || [[ -z $1 ]]; then
    usage_error
fi

function numb {
    if [ $1 -eq $1 ] 2>/dev/null ; then
        return 0
    else
        usage_error
    fi
}

if [[ -z $2 ]]; then
    sed -i "/#SBATCH --job-name/c\#SBATCH --job-name=\"$1\"" run_slurm.sh
    sed -i "/#PBS -N/c\#PBS -N $1" run_slurm.sh
    exit 0
    
elif [[ $1 == '-r' ]] ; then
    if [[ -z $2 ]]; then
        usage_error
    elif [[ -z $3 ]]; then
        name=$2; SET='*/'
    elif [[ -z $4 ]]; then
        name=$2; SET=$(seq 1 $3)
    elif [[ -z $5 ]]; then
        name=$2; SET=$(seq $3 $4)
    else
        usage_error
    fi

elif [[ -z $3 ]]; then
    numb $2
    name=$1; SET=$(seq 1 $2)
elif [[ -z $4 ]]; then
    numb $3
    name=$1; SET=$(seq $2 $3)
else
    usage_error
fi

# loop
for i in $SET
do
sed -i "/#SBATCH --job-name/c\#SBATCH --job-name=\"$name$i\"" $i*/run_slurm.sh
sed -i "/#PBS -N/c\#PBS -N $name$i" $i*/run_slurm.sh
done
