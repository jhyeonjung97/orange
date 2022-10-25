#!/bin/bash

read -p "files starts with: " f

for i in $(seq 1 $1)
do
    cp 0$i/POSCAR $f-p$i.vasp
    cp 0$i/CONTCAR $f-c$i.vasp
done

cp 00/POSCAR $f-p0.vasp
cp 0$(($1+1))/POSCAR $f-p$(($1+1)).vasp
cp 00/POSCAR $f-c0.vasp
cp 0$(($1+1))/POSCAR $f-c$(($1+1)).vasp

read -p "to where?: " p

scp *.vasp hailey@134.79.69.172:~/Desktop/$p