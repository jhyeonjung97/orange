#!/bin/sh

cat incar.in potcar.in $1.in kpoints.in > qe-relax.in
grep nat incar.in
grep nat $1.data
grep ntyp incar.in
grep ntyp $1.data