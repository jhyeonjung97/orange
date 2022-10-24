#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --partition=gpu
##
#SBATCH --job-name="lobster"
#SBATCH --time=05-00:00          # Runtime limit: Day-HH:MM
#SBATCH -o stdout.cohp.%j.out         # STDOUT, %N : nodename, %j : JobID
#SBATCH -e STDERR.cohp.%j.err         # STDERR, %N : nodename, %j : JobID

## HPC ENVIRONMENT DON'T REMOVE THIS PART
. /etc/profile.d/TMI.sh
##

#OpenMP settings:
export OMP_NUM_THREADS=32
export OMP_PLACES=threads
export OMP_PROC_BIND=spread

~/bin/lobster
