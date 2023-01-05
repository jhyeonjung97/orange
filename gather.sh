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

list=''
read -p 'vaspsend destination (enter for skip): ' send

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
                list+="$filename$numb.vasp "
            elif [[ $pattern == 'CHGCAR' ]]; then
                cp $file ../chgcar$numb.vasp
                list+="chgcar$numb.vasp "
            elif [[ "${file##*.}" == "${pattern##*.}" ]]; then
                filename="${file%.*}"
                extension="${file##*.}"
                cp $file ../$filename$numb.$extension
                list+="$filename$numb.$extension "
            fi
        fi
    done
    cd ..
done

if [[ $send == 'port' ]]; then
    cp $list ~/port/
elif [[ $send =~ 'w' ]]; then
    echo "scp $list jhyeo@192.168.1.251:~/Desktop/$send"
    scp $list jhyeo@192.168.1.251:~/Desktop/$send
elif [[ $send =~ 'x2347' ]]; then
    echo "scp $list x2347a10@nurion.ksc.re.kr:~/vis"
    scp $list x2347a10@nurion.ksc.re.kr:~/vis
elif [[ $send =~ 'x2431' ]]; then
    echo "scp $list x2431a10@nurion.ksc.re.kr:~/vis"
    scp $list x2431a10@nurion.ksc.re.kr:~/vis
elif [[ $send =~ 'cori' ]]; then
    echo "scp $list jiuy97@cori.nersc.gov:~/vis"
    scp $list jiuy97@cori.nersc.gov:~/vis
elif [[ -n $send ]]; then
    echo "scp $list hailey@134.79.69.172:~/Desktop/$send"
    scp $list hailey@134.79.69.172:~/Desktop/$send
fi