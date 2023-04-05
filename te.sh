#!/bin/bash

function update {
    force_tag=$(grep 'Total force' $1 | tail -n 1 | sed 's/\t/ /')
    read -ra force_arr <<< $force_tag
    force=${force_arr[3]}
    energy_tag=$(grep 'total energy' $1 | grep Ry | tail -n 1 | sed 's/\t/ /')
    read -ra energy_arr <<< $energy_tag
    if [[ ${energy_arr[3]} =~ '=' ]]; then
        energy=${energy_arr[4]}
    else
        energy=${energy_arr[3]}
    fi
    if [[ -z $force ]]; then
        force='-'
    fi
    if [[ -z $energy ]]; then
        energy='-'
    fi
}

IFS=' '
if [[ $1 =~ qe ]] || [[ -n $(grep pw.x run_slurm.sh) ]]; then
    echo 'Dir   Total force   Total energy   Status  '
    echo '————— ————————————— —————————————— ————————'
    for dir in */
    do
        cd $dir
        if [[ -e stdout.log ]]; then
            if [[ -n $(grep 'Maximum CPU time exceeded' stdout.log) ]]; then
                stat='TIME_exceeded'
            elif [[ -n $(grep 'JOB DONE' stdout.log) ]]; then
                stat='DONE'
            else
                stat='Not_DONE'
            fi
            update stdout.log
        elif [[ -f conti_1/stdout.log ]]; then
            i=1
            stat='Continued'
            while [[ -f "conti_$i/stdout.log" ]]
            do
                conti="conti_$i"
                i=$(($i+1))
            done
            update $conti/stdout.log
        else
            force='-'
            energy='-'
            stat='no_data'
        fi
        printf '%-5s %-13s %-14s %-8s\n' $dir $force $energy $stat
        cd ..
    done
else
    sh ~/bin/shoulder/te.sh
fi