#!/bin/bash

function resub {
    if [[ ${here} == 'nurion' ]] || [[ ${here} == 'kisti' ]]; then
        rm *.e* *.o*
    else
        rm STD* std*
    fi
    sh ~/bin/orange/sub.sh
}

if [[ -z $1 ]]; then # simple re-submit
    submit
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
        cd $i*
        submit
        cd ..
    done
fi