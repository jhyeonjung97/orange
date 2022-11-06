#!/bin/bash

sh ~/bin/orange/run-burning.sh g3 0 0

for i in {1..5}
do
    # POSCAR
    cp i$i.vasp $i/POSCAR
    # INCAR KPOINTS run_slurm.sh
    cp INCAR KPOINTS run_slurm.sh $i
    sh ~/bin/orange/jobname.sh FNC-S-SO$i
    
    cd $i
    # XCELL
    python ~/bin/pyband/xcell.py
    mv out*.vasp POSCAR
    # MAGMOM
    python3 ~/bin/orange/magmom.py
    # POTCAR
    sh ~/bin/orange/potcar.sh
    
    mkdir 1
    mv * 1
    sh ~/bin/orange/duplicate.sh 1 6
    cd 1
    sh ~/bin/orange/modify.sh INCAR ENCUT 400
    sh ~/bin/orange/modify.sh INCAR ISMEAR 0
    sh ~/bin/orange/modify.sh INCAR SIGMA 0.05
    cd ../2
    sh ~/bin/orange/modify.sh INCAR ENCUT 400
    sh ~/bin/orange/modify.sh INCAR ISMEAR -5
    sh ~/bin/orange/modify.sh INCAR SIGMA
    cd ../3
    sh ~/bin/orange/modify.sh INCAR ENCUT 400
    sh ~/bin/orange/modify.sh INCAR ISMEAR 1
    sh ~/bin/orange/modify.sh INCAR SIGMA
    cd ../4
    sh ~/bin/orange/modify.sh INCAR ENCUT 520
    sh ~/bin/orange/modify.sh INCAR ISMEAR 0
    sh ~/bin/orange/modify.sh INCAR SIGMA 0.05
    cd ../5
    sh ~/bin/orange/modify.sh INCAR ENCUT 520
    sh ~/bin/orange/modify.sh INCAR ISMEAR -5
    sh ~/bin/orange/modify.sh INCAR SIGMA
    cd ../6
    sh ~/bin/orange/modify.sh INCAR ENCUT 520
    sh ~/bin/orange/modify.sh INCAR ISMEAR 1
    sh ~/bin/orange/modify.sh INCAR SIGMA
    cd ..
    
    for j in {1..6}
    do
        cd $j
        sh ~/bin/orange/chgdos.sh 1 1 0 0
        cd ..
    done
    sh ~/bin/orange/run1.sh
    cd ..
done