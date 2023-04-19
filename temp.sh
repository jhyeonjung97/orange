#!/bin/bash

if [[ -z $1 ]]; then # simple submit
    sh ~/bin/temp.sh
else
    if [[ $1 == '-r' ]] || [[ $1 == 'all' ]]; then
        DIR='*/'
    elif [[ $1 == '-rr' ]]; then
        DIR='*/*/'
    elif [[ $1 == '-rrr' ]]; then
        DIR='*/*/*/'
    elif [[ $1 == '-s' ]] || [[ $1 == '-select' ]]; then
        DIR=${@:2}
    elif [[ -z $2 ]]; then
        DIR=$(seq 1 $1)
    else
        DIR=$(seq $1 $2)
    fi
    echo $DIR
    for i in $DIR
    do
        # i=${i%/}
        # cd $i*
        cd $i
        sh ~/bin/temp.sh
        cd ..
    done
fi