#!/bin/bash

if [[ $1 == '-r' ]] || [[ $1 == 'all' ]]; then
    DIR='*/'
elif [[ $1 == '-rr' ]]; then
    DIR='*/*/'
elif [[ $1 == '-rrr' ]]; then
    DIR='*/*/*/'
elif [[ $1 == '-s' ]] || [[ $1 == '-select' ]]; then
    DIR=${@:2}
elif [[ -z $2 ]]; then
    DIR=$(seq 1 $1)
else
    DIR=$(seq $1 $2)
fi

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