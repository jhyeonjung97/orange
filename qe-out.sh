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
grep ATOMIC_POSITIONS stdout.log -A 231 | tail -n 231