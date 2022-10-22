import subprocess
import sys

a = int(input("how many: "))
b = str(a+1)
c = input("files starts with: ")
for i in range(0,a+2):
    j = str(i)
    subprocess.call('cp 0'+j+'/POSCAR '+c+'-p'+j+'.vasp \n cp 0'+j+'/CONTCAR '+c+'-c'+j+'.vasp', shell=True)
subprocess.call('cp 00/POSCAR '+c+'-c0.vasp \n cp 0'+b+'/POSCAR '+c+'-c'+b+'.vasp', shell=True)
