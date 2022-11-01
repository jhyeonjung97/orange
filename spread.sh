#!/bin/bash

if [[ -z $2 ]]; then
    SET='*/'
elif [[ $2 == '2']]; then
    SET='*/*/'
elif [[ $2 == '3']]; then
    SET='*/*/*/'
fi

for dir in $SET
do
    cp $1 $dir
done