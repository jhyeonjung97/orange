#!/bin/bash

function resub {
    if [[ ${here} == 'nurion' ]] || [[ ${here} == 'kisti' ]]; then
        rm *.e* *.o*
    else
        rm STD* std*
    fi
    sh ~/bin/orange/sub.sh
}

if [[ $1 == '-r' ]]
    for dir in */
    do
        cd $dir
        resub
        cd ..
    done
else
    resub
fi