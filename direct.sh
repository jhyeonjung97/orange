#!/bin/bash

if [[ $1 == '-c' ]] || [[ $1 == '-n' ]]; then
    shift
    for file in $@
    do
        ase convert --write-args direct=False -f $file $file
        echo "Cartesin $file"
    done
else
    for file in $@
    do
        if ! [[ file =~ '-' ]]; then
            ase convert --write-args direct=True -f $file $file
            echo "Direct $file"
        fi
    done
fi