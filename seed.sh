#!/bin/bash

if [[ $2 == '-s' ]] || [[ $2 == '-select' ]]; then
    SET=${@:3}
elif [[ -z $3 ]]; then
    SET=$(seq 1 $2)
else
    SET=$(seq $2 $3)
fi

filename="${1%.*}"
extension="${1##*.}"

if [[ -z $2 ]] || [[ $extension != 'inp' ]]; then
    echo 'usage: seed [FILENAME.inp] [SEED]'
    break
fi

for i in $SET
do
    sed "/seed/c\seed $i" $1 > $filename$i.inp
    sh ~/bin/orange/pack.sh $filename$i.inp
done