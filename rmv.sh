#!/bin/bash

for file in $@
do
    if [[ -n $file ]]; then
        sh ~/bin/rm_mv $file
    fi
done