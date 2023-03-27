#!/bin/bash

if [[ $1 =~ n ]]; then
    q='normal'
elif [[ $1 =~ l ]]; then
    q='long'
fi

sed -i "/queue/c\#PBS -q $q" run_slurm.sh
grep '#PBS -q' run_slurm.sh