#!/bin/bash

# error cases
if [[ $1 == '-qe' ]] || [[ $1 == 'qe' ]]; then
    sh ~/bin/orange/autosub-qe.sh ${@:2}
    exit 1
elif [[ ! -e "INCAR" ]]; then
    echo "don't forget INCAR.."
    exit 2
elif [[ ! -e "KPOINTS" ]]; then
    echo "don't forget KPOINTS.."
    exit 2
elif [[ ! -e "run_slurm.sh" ]]; then
    echo "don't forget run_slurm.sh.."
    if [[ $here == 'burning' ]]; then
        sh ~/bin/orange/run-burning.sh
    elif [[ $here == 'kisti' ]] || [[ $here == 'nurion' ]]; then
        sh ~/bin/orange/run-nurion.sh
    fi
    exit 3
elif [[ -z $1 ]]; then
    echo 'usage: autosub (directory#1) [directory#2]'
fi

if [[ $1 == '-s' ]] || [[ $1 == '-select' ]]; then
    SET=${@:2}
elif [[ $1 == '-n' ]] || [[ $1 == '-non' ]]; then
    if [[ -z $3 ]]; then
        SET=$(seq 1 $2)
    else
        SET=$(seq $2 $3)
    fi
elif [[ -z $2 ]]; then
    SET=$(seq 1 $1)
else
    SET=$(seq $1 $2)
fi
    
read -p "POSCARs starts with: " p
read -p "job name: " n

if [[ -z $n ]]; then
    n=$p
fi

for i in $SET
do
    if [[ ! -d $i ]]; then
        mkdir $i
    fi
    cp INCAR KPOINTS run_slurm.sh $i
    cp $p$i.vasp $i/POSCAR
    cd $i
    python ~/bin/pyband/xcell.py #XCELL
    mv out*.vasp POSCAR #XCELL
    if [[ -n $(grep ISPIN INCAR | grep 2) ]]; then
        python3 ~/bin/orange/magmom.py
    fi
    sh ~/bin/orange/vasp5.sh
    # python3 ~/bin/shoulder/potcar_ara.py
    vaspkit -task 103 | grep --colour POTCAR
    sh ~/bin/orange/nelect.sh
    sed -i "/#SBATCH --job-name/c\#SBATCH --job-name=\"$n$i\"" run_slurm.sh
    sed -i "/#PBS -N/c\#PBS -N $n$i" run_slurm.sh
    cd ..
done

grep --colour NETCHG INCAR
read -p 'do you want to submit jobs? [y/n] (default: y) ' submit
if [[ ! $submit =~ 'n' ]]; then
    for i in $SET
    do
        cd $i
        sh ~/bin/orange/sub.sh
        cd ..
    done
fi