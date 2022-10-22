import subprocess
import sys

a = input("which files?: ")
if a == 'p':
    a = 'POSCAR'
if a == 'c':
    a = 'CONTCAR'
b = input("files starts with: ")
for i in range(0,10):
    j = str(i)
    subprocess.call('cp '+j+'*/'+a+' '+b+''+j+'.vasp', shell=True)
