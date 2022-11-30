#!/bin/bash

if [[ $1 =~ q ]] || [[ -n $(grep qe-relax.in run_slurm.sh) ]]; then
    for dir in */
    do
        cd $dir
        if [[ -e stdout.log ]]; then
            echo $dir$(grep 'Total force' stdout.log | tail -n 1)
            grep --colour '!    total energy' stdout.log | tail -n 1
        else
            echo $dir
        fi
        cd ..
    done
else
    tail -n 6 */stdout*
fi