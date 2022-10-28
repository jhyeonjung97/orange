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
elif [[ -z $2 ]]; then
    echo 'usage: autosub [directory#1] [directory#2]'
    break
fi

read -p "POSCARs starts with: " p
read -p "job name: " n

for i in $(seq $1 $2)
do
    mkdir $i
    cp INCAR KPOINTS run_slurm.sh $i
    cp $p$i.vasp $i/POSCAR
    cd $i
    python ~/bin/pyband/xcell.py
    mv out*.vasp POSCAR
    sed -n 6p POSCAR >> temp1
    sed 1d POSCAR >> temp2
    cat temp1 temp2 > POSCAR
    rm temp1 temp2
    python3 ~/bin/orange/magmom.py
    python3 ~/bin/shoulder/potcar_ara.py
    sed -i "/job-name/c\#SBATCH --job-name=\"$n$i\"" run_slurm.sh
    sbatch run_slurm.sh
    cd ..
done