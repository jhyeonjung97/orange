from ase.io import read, write
import os
from sys import argv

# for file in os.listdir('./'):
#     if file.endswith('.vasp'):
file = argv[1]
# name, ext = os.path.splitext(file)
atoms = read(file)
a = atoms.cell[0][0]
b = atoms.cell[1][1]
c = atoms.cell[2][2]
#temp = atoms.positions
atoms.positions *= (-1, -1, 1)
atoms.positions += (a, b, 0)
write(file, atoms, format='vasp')