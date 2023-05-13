#!/bin/bash

if [[ -d wave ]]; then
    if [[ -s WAVECAR ]]; then
        mkdir wave
        cp * wave
        mv conti*/ wave
    else
        echo 'no wavecar...'
        exit 1
    fi
fi

cp wave/CONTCAR POSCAR
sh ~/bin/orange/modify.sh INCAR ISTART 1
sh ~/bin/orange/modify.sh INCAR LSOL .TRUE.
sh ~/bin/orange/modify.sh INCAR LWAVE .FALSE.
sh ~/bin/orange/modify.sh INCAR EB_k 80
sh ~/bin/orange/modify.sh INCAR LAMBDA_D_K 4.36