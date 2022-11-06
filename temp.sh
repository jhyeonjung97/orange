#!/bin/bash

sh ~/bin/orange/run-burning.sh g3 0 0
sh ~/bin/orange/spread.sh run_slurm.sh
sh ~/bin/orange/jobname.sh -r FNC-S-SO

for i in {1..5}
do
    cd $i
    rm std* STD*
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