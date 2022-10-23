import sys
import os

print("POSCAR? INCAR? run_slurm.sh?")
a = int(input("directory from: "))
b = int(input("directory to: "))
p = input("POSCARs starts with: ")
n = input("job name: ")
for i in range(a+1,b+1):
    c = str(a)
    j = str(i)
    os.system(f"cp -r {c} {j}")
for i in range(a,b+1):
    j = str(i)
    os.system(f"cp {p}{j}.vasp {j}/POSCAR \n
              cd {j} \n
              xc \n
              magmom \n
              potcar \n
              sed -i -e '/job-name/c\#SBATCH --job-name="{n}{j}"' run_slurm.sh \n
              sbatch run_slurm.sh \n cd ..")