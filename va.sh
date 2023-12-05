#!/bin/bash

echo 'ZPE'
for i in */
do
    cd $i
    vaspkit -task 501 | grep 'Zero-point energy E_ZPE'
    cd ..
done

echo 'S_vib'
for i in */
do
    cd $i
    vaspkit -task 501 | grep 'Entropy S'
    cd ..
done