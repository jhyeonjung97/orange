#!/bin/bash

for file in $@
do
    if [[ -n $file ]]; then
        ~/bin/rm_mv $file
    fi
done