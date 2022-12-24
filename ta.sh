#!/bin/bash

if [[ $1 =~ qe ]] || [[ -n $(grep pw.x run_slurm.sh) ]]; then
    for dir in */
    do
        cd $dir
        if [[ -e stdout.log ]]; then
            if [[ -n $(grep 'JOB DONE' stdout.log) ]]; then
                echo $dir$(grep 'JOB DONE' stdout.log | tail -n 1)
            else
                echo $dir$(grep 'Total force' stdout.log | tail -n 1)
            fi
            grep --colour 'NOT' stdout.log | tail -n 1 
            grep --colour 'total energy' stdout.log | grep Ry | tail -n 1
        else
            echo $dir
            echo '!'
        fi
        cd ..
    done
else
    tail -n 6 */stdout*
fi