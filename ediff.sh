#!/bin/bash
j=1
while [[ -n $(grep EDIFF stdout.log) ]]; then
do 
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
    cp POSCAR ../.POSCAR_ediff
    cp POSCAR CONTCAR INCAR KPOINTS POTCAR run_slurm.sh .POSCAR_ediff ..
    cd ..
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

