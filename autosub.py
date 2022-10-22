import subprocess
import sys

print("poscar? incar? run_slurm.sh?")
a = int(input("directory from: "))
b = int(input("directory to: "))
p = input("POSCARs starts with: ")
n = input("job name: ")
for i in range(a+1,b+1):
    c = str(a)
    j = str(i)
    subprocess.call('cp -r '+c+' '+j+'', shell=True)
for i in range(a,b+1):
    j = str(i)
    subprocess.call('cp '+p+''+j+'.vasp '+j+'/POSCAR \n cd '+j+' \n xcell.py \n mv out*.vasp POSCAR \n python ~/bin/orange/magmom.py \n vaspkit \n sed -i -e \'/job-name/c\#SBATCH --job-name="'+n+''+j+'"\' run_slurm.sh \n sbatch run_slurm.sh \n cd ..', shell=True)
