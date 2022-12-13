from ase.io import read, write
from ase.build import sort
from sys import argv
import os

if len(argv) == 2:
    a = argv[1]
else:
    print('use default lattice parameter, 30 A ...')
    a = 30.

# iterating over all files
for files in os.listdir('./'):
    if files.endswith('.xyz'):
        atoms = read(files)
        atoms = sort(atoms)
        atoms.set_cell([a, a, a])
        atoms.center()
        write(files.replace('xyz', 'cif'), atoms, format='cif')
    else:
        continue