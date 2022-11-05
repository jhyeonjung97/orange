#!/bin/bash

i=1
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