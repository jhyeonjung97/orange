#!/bin/bash

read -p "files starts with: " f

a=$1+1
for i in $(seq 0 $a)
do
    cp 0$i/POSCAR $a-p$i.vasp
    cp 0$i/CONTCAR $f-c$i.vasp
done

cp 00/POSCAR $f-c0.vasp
cp 0$b/POSCAR $f-c$a.vasp

read -p "to where?: " p

echo "scp *.vasp hailey@134.79.69.172:~/Desktop/$p"
scp *.vasp hailey@134.79.69.172:~/Desktop/$p