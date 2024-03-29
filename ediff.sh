#!/bin/bash
i=1
j=1
save="conti_1"
while [[ -n $(tail stdout.log | grep EDIFF) ]] && [[ $j -le 3 ]]
do 
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
    if [[ $j -eq 2 ]]; then
        sh ~/bin/orange/modify.sh INCAR EDIFF 1E-05
    fi
    sh mpiexe.sh
    j=$(($j+1))
done
