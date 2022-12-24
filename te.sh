#!/bin/bash

IFS=' '
if [[ $1 =~ qe ]] || [[ -n $(grep pw.x run_slurm.sh) ]]; then
    echo 'Dir   Total force   Total energy   Status  '
    echo '————— ————————————— —————————————— ————————'
    for dir in */
    do
        cd $dir
        if [[ -e stdout.log ]]; then
            force_tag=$(grep 'Total force' stdout.log | tail -n 1 | sed 's/\t/ /')
            read -ra force_arr <<< $force_tag
            force=${force_arr[3]}
            energy_tag=$(grep 'total energy' stdout.log | grep Ry | tail -n 1 | sed 's/\t/ /')
            read -ra energy_arr <<< $energy_tag
            energy=${energy_arr[3]}
            if [[ -n $(grep 'JOB DONE' stdout.log) ]]; then
                stat='DONE'
            else
                stat='Not DONE'
            fi
        elif [[ -f conti_1/stdout.log ]]; then
            i=1
            while [[ -f "conti_$i/stdout.log" ]]
            do
                conti="conti_$i"
                i=$(($i+1))
            done
            force_tag=$(grep 'Total force' $conti/stdout.log | tail -n 1 | sed 's/\t/ /')
            read -ra force_arr <<< $force_tag
            force=${force_arr[3]}
            energy_tag=$(grep 'total energy' $conti/stdout.log | grep Ry | tail -n 1 | sed 's/\t/ /')
            read -ra energy_arr <<< $energy_tag
            energy=${energy_arr[3]}
            stat='Continued'
        else
            force=''
            energy=''
            stat='no data'
        fi
        printf '%-5s %-13s %-14s %-8s\n' $dir $force $energy $stat
        cd ..
    done
else
    sh ~/bin/playground/te.sh
fi