#!/bin/bash

sed -i "/walltime/c\#PBS -l walltime=$2:00:00" run_slurm.sh