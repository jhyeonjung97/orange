#!/bin/bash

if [[ -z $1 ]]; then
    read -p 'which files? ' f
else
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

for dir in */
do
    cd $dir
    numb=$(echo $dir | cut -c 1)$(echo $dir | cut -c 2)
    for file in *
    do
        if [[ $file =~ $pattern ]]; then
            if [[ -n $filename ]]; then
                if [[ $pattern == 'POSCAR' ]] && [[ -e initial.vasp ]]; then
                    cp initial.vasp ../$filename$numb.vasp
                elif [[ $pattern == 'CONTCAR' ]] && [[ ! -s $file ]]; then
                    cp POSCAR ../$filename$numb.vasp
                else
                    cp $pattern ../$filename$numb.vasp
                fi
            else
                filename="${file%.*}"
                extension="${file##*.}"
                cp $file ../$filename$numb.$extension
            fi
        fi
    done
    cd ..
done

read -p 'vaspsend? [y/n] (default: y) ' send
if [[ $send == 'port' ]]; then
    cp *.vasp ~/port/
elif [[ ! $send =~ 'n' ]]; then
    sh ~/bin/orange/vaspsend.sh
fi