#!/bin/bash

nat_tag=$(grep nat qe-relax.in | sed 's/\t/ /')
IFS=' '
read -ra nat_arr <<< $nat_tag
nat=${nat_arr[2]}
echo $nat

ntyp_tag=$(grep ntyp qe-relax.in | sed 's/\t/ /')
IFS=' '
read -ra ntyp_arr <<< $ntyp_tag
ntyp=${ntyp_arr[2]}
echo $ntyp

atoms=$(grep ATOMIC_POSITIONS stdout.log -A $nat | tail -n $nat )

if [[ -e contcar.in ]]; then
    rm contcar.in
fi
sed '/ATOMIC_POSITIONS/,$d' poscar.in >> contcar.in
echo 'ATOMIC_POSITIONS (crystal)' >> contcar.in
echo $atoms >> contcar.in

if [[ -e contcar.xyz ]]; then
    rm contcar.xyz
fi
echo $nat >> contcar.xyz
echo $PWD >> contcar.xyz
echo $atoms >> contcar.xyz