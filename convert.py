from ase.io import read, write
from ase.build import sort
from sys import argv
import os

if not argv[2]:
    print('wrong usage: convert (type1) (type2) [lattice]')
    exit()

if len(argv) == 4:
    a = float(argv[4])
else:
    print('use default lattice parameter, 30 A ...')
    a = 30.

# iterating over all files
for file in os.listdir('./'):
    if file.endswith('.%s' %argv[1]):
        atoms = read(file)
        # del atoms[[atom.symbol == 'Li' for atom in atoms]]
        atoms = sort(atoms)
        atoms.set_cell([a, a, a])
        # atoms.set_cell([30., 30., 30., 90., 90., 90.])
        atoms.center()
        write(file.replace('%s', '%s') %(argv[1], argv[2]), atoms, format='%s' %argv[2])
        # obabel -
    else:
        continue