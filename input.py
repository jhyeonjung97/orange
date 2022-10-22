import subprocess
import sys

a = input("POSCARs starts with: ")
b = int(input("directory from: "))
c = int(input("directory to: "))
for i in range(b,c+1):
    j = str(i)
    subprocess.call('cp '+a+''+j+'.vasp '+j+'*/POSCAR', shell=True)
