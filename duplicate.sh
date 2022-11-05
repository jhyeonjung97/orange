#!/bin/bash

for i in $(seq $(($1+1)) $2)
do
    cp -r $1 $i
done