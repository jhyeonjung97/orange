#!/bin/bash

for i in $(seq $1 $2)
do
    cp $1 $i
done

rm $1/$1/