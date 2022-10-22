import subprocess
import sys

a = input("which files?: ")
if a == 'p':
    a = 'POSCAR'
if a == 'c':
    a = 'CONTCAR'
b = input("to where?: ")
subprocess.call('scp '+a+' jiuy97@cori.nersc.gov:'+b+'', shell=True)
