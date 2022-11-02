#!/bin/bash

if [[ -e c ]]; then
    rm c
fi

mkdir c
mv * c
cp c/POSCAR initial.vasp
cp c/POSCAR c/CONTCAR c/INCAR c/KPOINTS c/POTCAR c/run_slurm.sh c/initial.vasp .

if [[ -s CONTCAR ]]; then
    mv CONTCAR POSCAR
fi

if [[ ${here} == 'nurion' ]] || [[ ${here} == 'kisti' ]]; then
    qsub run_slurm.sh
else
    sbatch run_slurm.sh
fi