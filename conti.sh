#!/bin/bash

if [[ -d conti ]]; then
    echo 'this can remove some data in <conti> directory..'
    save='conti'
elif [[ -d conti_2 ]]; then
    save='conti'
elif [[ -d conti_1 ]]; then
    save='conti_2'
else
    save='conti_1'
fi

if [[ ! -d conti ]]; then
    mkdir $save
fi

mv * $save
cd $save/
mv */ ..
cp POSCAR ../initial.vasp
cp POSCAR CONTCAR INCAR KPOINTS POTCAR run_slurm.sh initial.vasp ..
cd ..

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