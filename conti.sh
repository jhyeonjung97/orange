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

sbatch run_slurm.sh