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
    numb=$(echo $dir | cut -c 1)
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

read -p 'vaspsend destination (enter for skip): ' send
if [[ $send == 'port' ]]; then
    cp *.vasp ~/port/
elif [[ -n $send ]]; then
    echo "scp *.vasp hailey@134.79.69.172:~/Desktop/$send"
    scp *.vasp hailey@134.79.69.172:~/Desktop/$send
fi