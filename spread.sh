#!/bin/bash

if [[ $1 == '-r' ]]; then
    DIR='*/'
    shift
elif [[ $1 == '-rr' ]]; then
    DIR='*/*/'
    shift
elif [[ $1 == '-rrr' ]]; then
    DIR='*/*/*/'
    shift
else
    DIR='*/'
fi

if [[ $1 == *.vasp ]] && [[ ! -f $1 ]]; then
    file=$1
    name=${file%.*}
    for i in {0..9}
    do
        if [[ -f $name$i.vasp ]]; then
            cp $name$i.vasp $i*/POSCAR
            echo "cp $name$i.vasp $i*/POSCAR"
        fi
    done
else
    file=${@}
    for dir in $DIR
    do
        cp $file $dir
        # if [[ ! -e $file ]]; then
        #     name=${file%.*}
        #     ext=${file##*.}
        #     numb=$(echo $dir | cut -c 1)
        #     # echo $name $ext $numb
        #     cp $name$numb.$ext $dir$name.$ext
        # else
        #     cp $file $dir
        # fi
        # if [[ $file == 'run_slurm.sh' ]]
        #     cp .run_conti.sh $dir
        # fi
    done
fi