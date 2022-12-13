from ase.io import read, write
from ase.build import sort
from sys import argv
import os

if not argv[2]:
    print('wrong usage...')
    exit()

name, ext = os.path.splitext(argv[2])
ext = ext.replace('.','')
# print(ext)

if not argv[3]:
    print('use default lattice parameter, 30 A ...')
    a = 30.
else:
    a = float(argv[3])

# iterating over all files
atoms = read(argv[1])
atoms = sort(atoms)
atoms.set_cell([a, a, a])
atoms.center()
write(argv[2], atoms, ext)