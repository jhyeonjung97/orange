from ase.io.vasp import read_vasp_xdatcar
from ase.io import read, write
from statistics import mean
import numpy as np
import sys

# element = input("which element? ")
filename = input("filename? ")
traj = read_vasp_xdatcar('XDATCAR', index = 0)

i = 0
x = []
y = []

for atoms in traj:
    # list = [atoms[63].z,atoms[64].z,atoms[65].z,atoms[67].z,atoms[69].z,atoms[70].z,atoms[71].z,atoms[76].z]
    list = [atoms[67].z,atoms[72].z,atoms[75].z,atoms[76].z,atoms[78].z,atoms[80].z,atoms[83].z,atoms[84].z]
    
    # list = [atom.z for atom in atoms if atom.symbol == 'H' and atom.z < 8]
    i = i+1
    x.append(i)
    y.append(min(list))
    # print(mean(list))

# atoms = read('CONTCAR')
# #list = [atom.z for atom in atoms if atom.symbol == 'H' and atom.z > 7]
# list = [atoms[0].z, atoms[1].z]
print(mean(y))
    
np.savetxt("%s.csv" % filename, np.transpose([x, y]), delimiter =", ", fmt ='% s')
