import sys
import os

print("poscar? incar? run_slurm.sh?")
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
    os.system(f"cp {p}{j}.vasp {j}/POSCAR")
    os.system(f"cd {j}")
    os.system(f"xcell.py")
    os.system(f"mv out*.vasp POSCAR")
    os.system(f"python ~/bin/orange/magmom.py")
    os.system(f"vaspkit")
    os.system(\n sed -i -e \'/job-name/c\#SBATCH --job-name="'+n+''+j+'"\' run_slurm.sh \n sbatch run_slurm.sh \n cd ..")
