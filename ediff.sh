#!/bin/bash
j=1
while [[ -n $(grep EDIFF stdout.log) ]] && [[ j -lt 3 ]]; then
do
    sh mpiexe.sh
done