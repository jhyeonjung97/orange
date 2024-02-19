#!/bin/bash

path_now="$PWD"
if [[ ! -d /global/cfs/cdirs/m2997 ]]; then
    echo "Here is not perlmutter..."
    exit 1
fi

if [[ -s mpiexe.sh ]]; then
    rm mpiexe.sh
fi
cp ~/input_files/run_slurm.sh .