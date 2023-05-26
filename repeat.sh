#!/bin/bash

i=1
j=1
while [[ $iter -ne 1 ]]
do 
    i=1
    save="conti_$i"
    while [[ -d "conti_$i" ]]
    do
        i=$(($i+1))
        save="conti_$i"
    done
    mkdir $save
    cp * $save
    cp POSCAR .POSCAR
    cp CONTCAR POSCAR
    if [[ $j -eq 2 ]]; then
        sh ~/bin/orange/modify.sh INCAR EDIFF 1E-05
    fi
    sh mpiexe.sh
    j=$(($j+1))
    E0_list=$(grep E0 OSZICAR | tail -1)
    iter=${E0_array[0]}
done