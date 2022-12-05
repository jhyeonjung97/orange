#!/bin/bash

if [[ -z $1 ]] || [[ -z $2 ]]; then
    echo 'wrong usage...'
    exit 1
else
    a=$3
fi

if [[ -z $a ]]; then
    read -p 'lattice parameter? (A) ' a
fi

name1="${1%.*}"
ext1="${1##*.}"

name2="${2%.*}"
ext2="${2##*.}"

if [[ -e $1 ]]; then
    python ~/bin/orange/cluster.py $1 $2 $a
fi
    
for i in {0..9}
do
    if [[ -e $name1$i.$ext1 ]]; then
        python ~/bin/orange/cluster.py $name1$i.$ext1 $name2$i.$ext2 $a
        # echo "python ~/bin/orange/cluster.py $name1$i.$ext1 $name2$i.$ext2 $a"
    fi
done