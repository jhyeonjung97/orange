#!/bin/bash

if [[ $1 == '-c' ]] || [[ $1 == '-n' ]]; then
    ase convert --write-args direct=False -f $2 $2
    echo "ase convert --write-args direct=False -f $2 $2"
else
    ase convert --write-args direct=True -f $1 $1
    echo "ase convert --write-args direct=True -f $1 $1"
fi