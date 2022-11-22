from ase.io import read, write
from sys import argv, exit
import os

# usage: cell2xyz.py [file_in] [file_out] [lattice_a] [format]
file_in = str(argv[1])
file_out = str(argv[2])
a = float(argv[3])
# format = argv[4]

atoms = read(file_in)
atoms.positions *= a
# atoms.set_cell([a, a, a])

write(file_out, atoms, format='xyz')
# if not format == '';
#     write('contcar.%s' %format, atoms, format=format)