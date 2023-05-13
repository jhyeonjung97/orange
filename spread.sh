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

file=${@}
for dir in $SET
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