from ase.io.vasp import read_vasp_xdatcar
from statistics import mean
import numpy as np
import sys

#element = input("which element? ")
filename = input("filename? ")
traj = read_vasp_xdatcar('XDATCAR', index = 0)

i = 0
x = []
y = []

for atoms in traj:
    list = [atom.z for atom in atoms if atom.symbol == 'H']
    i = i+1
    x.append(i)
    y.append(min(list))

np.savetxt("%s.csv" % filename, np.transpose([x, y]), delimiter =", ", fmt ='% s')
