from ase.io import read, write
from sys import argv, exit
import os

# usage: cell2xyz.py [file] [lattice_a] [format]
file = str(argv[1])
a = float(argv[2])
# format = argv[3]

atoms = read(file)
atoms.positions *= a
# atoms.set_cell([a, a, a])

write('contcar.xyz', atoms, format='xyz')
# if not format == '';
#     write('contcar.%s' %format, atoms, format=format)