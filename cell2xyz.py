from ase.io import read, write
from sys import argv, exit
import os

# usage: cell2xyz.py [lattice_a] [format]
a = argv[1]
f = argv[2]

atoms = read('.contcar.xyz')
atoms.positions *= a
# atoms.set_cell([a, a, a])

write('contcar.xyz', atoms, format='xyz')
# if not f == '';
#     write('contcar.%s' %f, atoms, format=f)