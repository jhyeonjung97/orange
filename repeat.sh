#!/bin/bash

i=1
j=1
iter=600
while [[ $iter -gt 1 ]] && [[ $j -le 9 ]]
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
    if [[ -z initial.vasp ]]; then
        cp POSCAR initial.vasp
    fi
    cp CONTCAR POSCAR
    sh mpiexe.sh
    j=$(($j+1))
    E0_list=$(grep E0 OSZICAR | tail -1)
    E0_array=($E0_list)
    E0_org=${E0_array[4]}
    iter=${E0_array[0]}
    echo "iter: $iter, j: $j"
done