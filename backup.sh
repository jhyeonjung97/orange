#!/bin/bash

# read -p 'are you sure for backup? [y/n] (default: n) ' yn
# read -p 'how about big files (CHG, DOS)? [y/n] (default: y) ' big

# if [[ ! yn == y* ]]; then
#     exit 1
# fi

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

find . -name CHG* -type f -delete
find . -name DOS* -type f -delete
find . -name *err -type f -delete
find . -name PCDAT -type f -delete
find . -name REPORT -type f -delete
find . -name IBZKPT -type f -delete
find . -name OSZICAR -type f -delete
find . -name XDATCAR -type f -delete
find . -name WAVECAR -type f -delete
find . -name EIGENVAL -type f -delete
find . -name conti* -type d -delete
find . -name x -type d -exec rm -rv {} +
find . -empty -delete

size=10000000000
until [[ $(du -sb | cut -f 1) -lt 1000000000 ]]
do
    echo $size
    du -sh
    find . -size +"$size"c -type f -delete
    size=${size:0:-1}
done
du -sh

# dir='.'
# deep=1
# zero=0
# size=1000000
# while [[ $deep == 1 ]]
# do
#     deep=0
#     rm $dir/CHG*
#     rm $dir/DOS*
#     rm $dir/*.err
#     # rm $dir/INCAR
#     # rm $dir/KPOINTS
#     # rm $dir/POTCAR
#     # rm $dir/POSCAR
#     # rm $dir/CONTCAR
#     rm $dir/PCDAT
#     rm $dir/REPORT
#     rm $dir/IBZKPT
#     rm $dir/OSZICAR
#     rm $dir/XDATCAR
#     rm $dir/WAVECAR
#     rm $dir/EIGENVAL
#     dir+='/*'
#     for file in $dir
#     do
#         # if [[ $file == initial.vasp ]] || [[ $file == run_slurm.sh ]]; then
#         # elif [[ $file == vasprun.xml ]] || [[ $file == OUTCAR ]] || [[ $file == stdout.* ]]; then
#         if [[ -d $file ]] && [[ $file == conti_* ]]; then
#             rm -r $file
#         elif [[ -d $file ]]; then
#             deep=1
#         elif [[ $(stat -c%s $file) -eq $zero ]]; then
#             rm $file
#         elif [[ $(stat -c%s $file) -ge $size ]] ; then  # [[ ! $big == n* ]] && 
#             rm $file
#         fi
#     done
# done
# find . -empty -type d -delete
# du -sh ./