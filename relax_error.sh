#!/bin/bash

if [[ ${here} == 'burning' ]]; then
    if [[ -n $(grep beef run_slurm.sh) ]]
        sed -n '16,18p' run_slurm.sh > run_conti.sh
    else
        sed -n '16p' run_slurm.sh > run_conti.sh
    fi
elif [[ ${here} == 'kisti' ]] || [[ ${here} == 'nurion' ]]; then
    if [[ -n $(grep beef run_slurm.sh) ]]
        sed -n '11,13p' run_slurm.sh > run_conti.sh
    else
        sed -n '11p' run_slurm.sh > run_conti.sh
    fi
else
    echo 'where am i..? please modify [con2pos.sh] code'
    exit 1
fi

if [[ -e conti_2 ]]; then
    i=3
elif [[ -e conti_1 ]]; then
    i=2
else
    i=1
fi 

while [[ $i < 3 ]] && [[ -n $(grep "please rerun with smaller EDIFF, or copy CONTCAR" std*) ]]
do
    mkdir conti_$i
    cp * conti_$i
    i=$(($i+1))
    rm std* STD*
    mv CONTCAR POSCAR
    sh run_conti.sh
done

if [[ $i = 3 ]] && [[ -n $(grep "please rerun with smaller EDIFF, or copy CONTCAR" std*) ]]; then
    echo "please check if your calculation is okay to be continued.."
    cp ~/input_files/SPOTCAR .
    exit 2
fi

