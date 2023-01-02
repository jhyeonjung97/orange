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
            if [[ $pattern == 'POSCAR' ]] || [[ $pattern == 'CONTCAR' ]]; then
                if [[ $pattern == 'POSCAR' ]] && [[ -e initial.vasp ]]; then
                    cp initial.vasp ../$filename$numb.vasp
                elif [[ $pattern == 'CONTCAR' ]] && [[ ! -s $file ]]; then
                    cp POSCAR ../$filename$numb.vasp
                else
                    cp $pattern ../$filename$numb.vasp
                fi
            elif [[ "${file##*.}" == "${pattern##*.}" ]]; then
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
elif [[ $send =~ 'w' ]]; then
    echo "scp *.vasp jhyeo@192.168.1.251:~/Desktop/$send"
    scp *.vasp jhyeo@192.168.1.251:~/Desktop/$send
    rm *.vasp
elif [[ $send =~ 'x2347' ]]; then
    echo "scp *.vasp x2347a10@nurion.ksc.re.kr:~/vis"
    scp *.vasp x2347a10@nurion.ksc.re.kr:~/vis
    rm *.vasp
elif [[ $send =~ 'x2431' ]]; then
    echo "scp *.vasp x2431a10@nurion.ksc.re.kr:~/vis"
    scp *.vasp x2431a10@nurion.ksc.re.kr:~/vis
    rm *.vasp
elif [[ $send =~ 'cori' ]]; then
    echo "scp *.vasp jiuy97@cori.nersc.gov:~/vis"
    scp *.vasp jiuy97@cori.nersc.gov:~/vis
    rm *.vasp
elif [[ -n $send ]]; then
    echo "scp *.vasp hailey@134.79.69.172:~/Desktop/$send"
    scp *.vasp hailey@134.79.69.172:~/Desktop/$send
    rm *.vasp
fi