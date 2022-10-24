import subprocess
import sys

a = input("job name: ")
b = input("how many: ")
if not b:
    subprocess.call('sed -i -e \'/job-name/c\#SBATCH --job-name="'+a+'"\' run_slurm.sh', shell=True)
else:
    b = int(b)
    for i in range(0,b+1):
        c = str(i)
        subprocess.call('sed -i -e \'/job-name/c\#SBATCH --job-name="'+a+''+c+'"\' '+c+'*/run_slurm.sh', shell=True)
