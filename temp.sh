#!/bin/bash

sh ~/bin/orange/run-burning.sh
sh ~/bin/orange/spread.sh run_slurm.sh

for i in {1..5}
do
    cd $i
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
done