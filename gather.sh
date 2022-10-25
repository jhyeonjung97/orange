#!/bin/bash

if [[ -z $1 ]]; then
    read -p 'which files? ' f
elif
    f=$1
fi
    
if [[ $f == 'p' ]] || [[ $f == 'pos' ]]; then
    pattern='POSCAR'
    read -p "filename starts with? " filename
elif [[ $f == 'c' ]] || [[ $f == 'con' ]]; then
    pattern='CONTCAR'
    read -p "filename starts with? " filename
else
    pattern=$f
fi

for i in {0..9}
do
    if [[ -d $i ]]; then
        cd $i
        for file in *
        do
            if [[ $file =~ $pattern ]]; then
                if [[ $pattern == 'POSCAR' ]] || [[ $pattern == 'CONTCAR' ]]; then
                    cp $file ../$filename$i.vasp
                else
                    extension="${file##*.}"
                    filename="${file%.*}"
                    cp $file ../$filename$i.$extension
                fi
            fi
            
            if [[ $pattern == 'POSCAR' ]] && [[ $file =~ 'initial' ]]; then
                cp $file ../$filename$i.vasp
            fi
        done
        cd ..
    fi
done