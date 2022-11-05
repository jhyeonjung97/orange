#!/bin/bash

if [[ -z $1 ]]; then # simple potcar
    sh ~/bin/orange/vasp5.sh
    python ~/bin/shoulder/potcar_ara.py
else
    if [[ $1 == '-r' ]] || [[ $1 == 'all' ]]; then
        DIR='*/'
    elif [[ $1 == '-s' ]] || [[ $1 == '-select' ]]; then
        DIR=${@:2}
    elif [[ -z $2 ]]; then
        DIR=$(seq 1 $1)
    else
        DIR=$(seq $1 $2)
    fi
    
    for i in $DIR
    do
        i=${i%/}
        cd $i*
        if [[ -d POSCAR ]]; then
            sh ~/bin/orange/vasp5.sh
            python ~/bin/shoulder/potcar_ara.py
        else
            ending="there is no POSCAR file in directory $i.."
        fi
        cd ..
    done
fi