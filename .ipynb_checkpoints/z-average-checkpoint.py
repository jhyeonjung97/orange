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
    y.append(mean(list))

np.savetxt("z-%s-avg.csv" % element, [x, y], delimiter =", ", fmt ='% s')
    
plt.figure(figsize=(4.5, 3.5))
plt.plot(x, y)
plt.xlabel('iteration (1 fs)')
if len(list) == 1:
    plt.ylabel('average z-position of %s atom (A)' % element)
else:
    plt.ylabel('average z-position of %s atoms (A)' % element)
plt.xlim([0, 8000])
plt.ylim([y1, y2])
plt.tight_layout()
plt.savefig('z-%s-avg.png' % element)
