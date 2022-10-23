from ase.io import read, write
from os import listdir
import subprocess
#import sys
import os

directory = '/Users/hailey/figure/'
select = input("which files?: ")
here = os.getcwd()
subprocess.call('cp '+select+' '+directory+' \n cd '+directory+'', shell=True)
x, y, z = input("rotation anple (x, y, z): ").split()
x = int(x)
y = int(y)
z = int(z)
for file in listdir(directory):
    if file.endswith(".vasp"):
        filename = file.split('.')[0]
        atoms = read(file)
        write("%s/%s.png" % (directory, filename), atoms, rotation='%dx, %dy, %dz' % (x, y, z))
subprocess.call('mv '+directory+'/*.png '+here+' \n cd '+here+' \n rm '+directory+'/*', shell=True)
