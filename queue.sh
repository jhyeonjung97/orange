#!/bin/bash

if [[ $2 =~ n ]]; then
    q='normal'
elif [[ $2 =~ l ]]; then
    q='long'
fi

sed -i "/queue/c\#PBS -q $q" run_slurm.sh
grep queue run_slurm.sh