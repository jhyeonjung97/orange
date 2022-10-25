#!/bin/bash

if [[ ! -e "INCAR" ]]; then
    echo "don't forget INCAR.."
    incar
    break
elif [[ ! -e "KPOINTS" ]]; then
    echo "don't forget KPOINTS.."
    k
    break
elif [[ ! -e "run_slurm.sh" ]]; then
    echo "don't forget run_slurm.sh.."
    run
    break
fi

read -p "POSCARs starts with: " p
read -p "job name: " n

SET=$(seq -s " " $1 $2)
for i in $SET
do
    mkdir $i
    cp INCAR KPOINTS run_slurm.sh $1
    cp $p$i.vasp $i/POSCAR
    cd $i
    xc
    magmom
    potcar
    sed -i -e "/job-name/c\#SBATCH --job-name="$n$i"" run_slurm.sh
    sbatch run_slurm.sh
    cd ..
done