import subprocess
import sys

if len(sys.argv) == 1:
    subprocess.call('sed -i "s/NPAR.*/NPAR   = 4/g" INCAR \n grep NPAR INCAR \n grep Selective POSCAR \n grep MAGMOM INCAR \n sbatch run_slurm.sh \n cd ..', shell=True)
else:
    a = int(sys.argv[1])
    b = int(sys.argv[2])
    for i in range(a,b+1):
        c = str(i)
        subprocess.call('cd '+c+'* \n sed -i "s/NPAR.*/NPAR   = 4/g" INCAR \n grep NPAR INCAR \n grep Selective POSCAR \n grep MAGMOM INCAR \n sbatch run_slurm.sh \n cd ..', shell=True)
