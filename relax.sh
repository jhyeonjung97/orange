#!/bin/sh

cat incar.in $1.in kpoints.in > qe-relax.in
grep nat $1.data
grep nat incar.in
grep ntyp $1.data
grep ntyp incar.in