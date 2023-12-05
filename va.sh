#!/bin/bash

dir_now=$PWD

echo 'ZPE'
for i in '*/'
do
    cd $i
    vaspkit -task 501 | grep 'Zero-point energy E_ZPE'
    cd $dir_now
done

echo 'S_vib'
for i in '*/'
do
    cd $i
    vaspkit -task 501 | grep 'Entropy S'
    cd $dir_now
done