from ase.io.vasp import read_vasp_xdatcar
from ase.io import read, write
from statistics import mean
import numpy as np
import sys

# element = input("which element? ")
# filename = input("filename? ")
# traj = read_vasp_xdatcar('XDATCAR', index = 0)

i = 0
x = []
y = []

# for atoms in traj:
#     list = [atom.z for atom in atoms if atom.symbol == 'H' and atom.z < 8]
#     # i = i+1
#     # x.append(i)
#     # y.append(min(list))
#     print(mean(list))

atoms = read('CONTCAR')
#list = [atom.z for atom in atoms if atom.symbol == 'H' and atom.z > 7]
list = [atoms[0].z, atoms[1].z]
print(min(list))
    
# np.savetxt("%s.csv" % filename, np.transpose([x, y]), delimiter =", ", fmt ='% s')
