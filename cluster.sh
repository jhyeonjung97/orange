#!/bin/bash

if [[ -z $1 ]] || [[ -z $2 ]]; then
    echo 'wrong usage...'
    exit 1
elif [[ -z $3 ]]; then
    read -p 'lattice parameter? (A) ' 3
fi

name1="${1%.*}"
ext1="${1##*.}"

name2="${2%.*}"
ext2="${2##*.}"

if [[ -e $1 ]]; then
    python ~/bin/orange/change.py $1 $2 $3
fi
    
for i in {0..9}
do
    if [[ -e $name1$i.$ext1 ]]; then
        python ~/bin/orange/change.py $name1$i.$ext1 $name2$i.$ext2 $3
    fi
done