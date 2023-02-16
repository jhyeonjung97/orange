#!/bin/bash
j=1
while [[ -n $(grep EDIFF stdout.log) ]]
do 
    i=1
    save="conti_$i"
    while [[ -d "conti_$i" ]]
    do
        i=$(($i+1))
        save="conti_$i"
    done
    mkdir $save
<<<<<<< HEAD
    cp * $save
    cp POSCAR .POSCAR
    cp CONTCAR POSCAR
=======
    mv * $save
    cd $save/
    mv */ ..
    cp POSCAR ../.POSCAR
    cp CONTCAR ../POSCAR
    cp INCAR KPOINTS POTCAR run_slurm.sh .POSCAR mpiexe.sh vdw_kernel.bindat ..
    cd ..
>>>>>>> 4975ddffe290a3948ac9f76e64f08c62a9aafd04
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

