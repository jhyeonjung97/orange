#!/bin/bash

if [[ -z $1 ]]; then
    sed -i "/NPAR/c\NPAR   = ${npar}" INCAR
    grep NPAR INCAR
    grep Selective POSCAR
    grep MAGMOM INCAR 
    sbatch run_slurm.sh
    cd ..
else
    for i in {$a..$b}
    do
        cd $i*
        sed -i "/NPAR/c\NPAR   = ${npar}" INCAR
        grep NPAR INCAR
        grep Selective POSCAR
        grep MAGMOM INCAR 
        sbatch run_slurm.sh
        cd ..
fi