#!/bin/bash
i=1
j=1
while [[ -n $(grep EDIFF stdout.log) ]] && [[ $j -le 3 ]]
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
    ediff=$(grep 'EDIFF ' INCAR | tail -c 2)
    if [[ $j -eq 2 ]]; then
        sh ~/bin/orange/modify.sh INCAR EDIFF 1E-0$(($ediff+1))
    fi
    rm stdout.log
    sh mpiexe.sh
    j=$(($j+1))
done
