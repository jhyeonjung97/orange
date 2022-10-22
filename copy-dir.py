import subprocess
import sys

print("poscar? incar? run_slurm.sh?")
a = int(input("mother directory: "))
b = int(input("last number of directory: "))
for i in range(a+1,b+1):
    c = str(a)
    d = str(i)
    subprocess.call('cp -r '+c+' '+d+'', shell=True)
