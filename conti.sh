#!/bin/bash

if [[ -d conti ]]; then
    echo 'this can remove some data in <conti> directory..'
    save='conti'
elif [[ -e conti_2 ]]; then
    save='conti'
elif [[ -e conti_1 ]]; then
    save='conti_2'
else
    save='conti_1'
fi

if ! [[ -d conti ]]; then
    mkdir $save
fi

mv * $save
mv $save/*/ .
cp $save/POSCAR initial.vasp
cp $save/POSCAR $save/CONTCAR $save/INCAR $save/KPOINTS $save/POTCAR $save/run_slurm.sh $save/initial.vasp .

if [[ -s CONTCAR ]]; then
    mv CONTCAR POSCAR
fi

if [[ ${here} == 'burning' ]]; then
    sbatch run_slurm.sh
elif [[ ${here} == 'nurion' ]] || [[ ${here} == 'kisti' ]]; then
    qsub run_slurm.sh
else
    echo 'where am i..? please modify [con2pos.sh] code'
    exit 1
fi