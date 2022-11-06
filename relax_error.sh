#!/bin/bash

function run_conti {
    i=1
    save="conti_$i"
    while [[ -d "conti_$i" ]]
    do
        i=$(($i+1))
        save="conti_$i"
    done
    mkdir $save
    mv * $save
    cd $save/
    mv */ ..
    cp POSCAR ../initial.vasp
    cp POSCAR CONTCAR INCAR KPOINTS POTCAR run_slurm.sh initial.vasp .run_conti.sh ..
    cd ..

    if [[ -s CONTCAR ]]; then
        mv CONTCAR POSCAR
    fi
    sh .run_conti.sh
}

j=0
until [[ $j == 2 ]] || [[ -z $(grep "please rerun with smaller EDIFF, or copy CONTCAR" std*) ]]
do
    if [[ $j == 1 ]]; then
        sh ~/bin/orange/modify.sh INCAR EDIFF 1E-06
    fi
    run_conti
    j=$(($j+1))
done

