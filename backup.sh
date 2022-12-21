#!/bin/bash

read -p 'are you sure for backup? [y/n] (default: n) ' yn
read -p 'how about big files (CHG, DOS)? [y/n] (default: y) ' big

if [[ ! yn == y* ]]; then
    exit 1
fi

if [[ ${here} == nurion ]]; then
    echo "cp -r $PWD /scratch/x2347a10/backup"
    cp -r $PWD /scratch/x2347a10/backup
elif [[ ${here} == kisti ]]; then
    echo "cp -r $PWD /scratch/x2431a10/backup"
    cp -r $PWD /scratch/x2431a10/backup
elif [[ ${here} == burning ]]; then
    echo "cp -r $PWD ~/backup"
    cp -r $PWD ~/backup
else
    echo 'where are you?'
    exit 2
fi

dir='.'
save=$PWD
deep=1
zero=0
size=104857600
while [[ $deep == 1 ]]
do
    deep=0
    rm $dir/CHG*
    rm $dir/DOS*
    rm $dir/*.err
    rm $dir/INCAR
    rm $dir/KPOINTS
    rm $dir/POTCAR
    rm $dir/POSCAR
    rm $dir/CONTCAR
    rm $dir/PCDAT
    rm $dir/REPORT
    rm $dir/IBZKPT
    rm $dir/OSZICAR
    rm $dir/XDATCAR
    rm $dir/WAVECAR
    rm $dir/EIGENVAL
    dir+='/*'
    for file in $dir
    do
        echo $file $(stat -c%s $file)
        # if [[ $file == initial.vasp ]] || [[ $file == run_slurm.sh ]]; then
        # elif [[ $file == vasprun.xml ]] || [[ $file == OUTCAR ]] || [[ $file == stdout.* ]]; then
        if [[ -d $file ]] && [[ $file == conti_* ]]; then
            rm -r $file
        elif [[ -d $file ]]; then
            deep=1
        elif [[ $(stat -c%s $file) -eq $zero ]]; then
            echo 'number 3'
            rm $file
        elif [[ ! $big == n* ]] && [[ $(stat -c%s $file) -ge $size ]] ; then
            echo 'number 4'
            rm $file
        fi
    done
done
du -sh $save