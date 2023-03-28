#!/bin/bash

sed -i "/walltime/c\#PBS -l walltime=$1:00:00" run_slurm.sh
grep 'walltime' run_slurm.sh