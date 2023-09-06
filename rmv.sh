#!/bin/bash

for file in $@
do
    if [[ -s $file ]]; then
        ~/bin/rm_mv $file
    fi
done