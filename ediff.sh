#!/bin/bash
j=1
while [[ -n $(grep EDIFF stdout.log) ]]; then
do
    ediff=$(grep 'EDIFF ' INCAR | tail -c 2)
    if [[ $j -eq 2 ]]; then
        sh ~/bin/orange/modify.sh INCAR EDIFF 1E-0$(($ediff+1))
    fi
    sh mpiexe.sh
    j=$(($j+1))
done

if [[ -n $(grep EDIFF stdout.log) ]]; then
    exit 4
fi