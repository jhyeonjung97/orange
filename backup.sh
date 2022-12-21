#!/bin/bash

read -p 'are you sure for backup? [y/n] (default: n) ' yn
read -p 'how about big files (CHG, DOS)? [y/n] (default: y) ' big

if [[ ! yn == y* ]]; then
    exit 1
fi

dir='.'
save=$PWD
deep=1
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
        if [[ $file == initial.vasp ]] || [[ $file == run_slurm.sh ]]; then
            continue
        elif [[ $file == vasprun.xml ]] || [[ $file == OUTCAR ]] || [[ $file == stdout.* ]]; then
            continue
        elif [[ -d $file ]] || [[ $file == conti_* ]]; then
            rm -r $file
        elif [[ -d $file ]]; then
            deep=1
        elif [[ ! -s $file ]]; then
            rm $file
        elif [[ ! $big == n* ]] && [[ $(stat -c%s $file) > 104857600 ]] ; then
            rm $file
        fi
    done
done
du -sh $save