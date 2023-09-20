#!/bin/bash

if [[ -z $1 ]]; then # simple potcar
    sh ~/bin/orange/vasp5.sh
    python ~/bin/shoulder/potcar_ara.py
else
    if [[ $1 == '0' ]] || [[ $1 =~ 'f' ]]; then
        sed -i -e '/RECOMMEND/s/.TRUE.  /.FALSE.  /' ~/.vaspkit
        exit 1
    elif [[ $1 == '1' ]] || [[ $1 =~ 't' ]]; then
        sed -i -e '/RECOMMEND/s/.FALSE.  /.TRUE.  /' ~/.vaspkit    
        exit 1
    elif [[ $1 == '-r' ]]; then
        DIR='*/'
    elif [[ $1 == '-s' ]]; then
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
        if [[ -e POSCAR ]]; then
            sh ~/bin/orange/vasp5.sh
            python ~/bin/shoulder/potcar_ara.py
        else
            ending+="there is no POSCAR file in directory $i..\n"
        fi
        cd ..
    done
fi

echo $ending