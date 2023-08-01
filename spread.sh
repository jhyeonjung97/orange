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

if [[ $1 == '*.vasp' ]]; then
    echo hello1
elif [[ ! -f $1 ]]; then
    echo hello2
fi

if [[ $1 == '*.vasp' ]] && [[ ! -f $1 ]]; then
    file=$1
    name=${file%.*}
    for i in $NUM
    do
        cp $name$i.vasp $i*/
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