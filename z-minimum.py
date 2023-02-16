from ase.io.vasp import read_vasp_xdatcar
import matplotlib.pyplot as plt
from statistics import mean
import numpy as np
import sys

element = input("which element? ")
y1 = float(input("z-position axis from [A]: "))
y2 = float(input("z-position axis to [A]: "))
traj = read_vasp_xdatcar('XDATCAR', index = 0)

i = 0
x = []
y = []

for atoms in traj:
    list = [atom.z for atom in atoms if atom.symbol == element]
    i = i+1
    x.append(i)
    y.append(min(list))

np.savetxt("z-%s-avg.csv" % element, np.transpose[x, y], delimiter =", ", fmt ='% s')
