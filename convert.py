from ase.io import read, write
from ase.build import sort
from sys import argv
import os

if not argv[2]:
    print('wrong usage: convert (type1) (type2) [lattice]')
    exit()

if len(argv) == 6:
    a = float(argv[3])
    b = float(argv[4])
    c = float(argv[5])
elif len(argv) == 5:
    a = float(argv[3])
    b = a
    c = float(argv[4])
elif len(argv) == 4:
    a = float(argv[3])
    b = a
    c = a
else:
    print('use default lattice parameter (30 A) for cubic cell...')
    a = 30.
    b = a
    c = a

# iterating over all files
for file in os.listdir('./'):
    if file.endswith('.%s' %argv[1]):
        atoms = read(file)
        # del atoms[[atom.symbol == 'Li' for atom in atoms]]
        atoms = sort(atoms)
        atoms.set_cell([a, b, c])
        # atoms.set_cell([30., 30., 30., 90., 90., 90.])
        atoms.center()
        write(file.replace('%s' %argv[1], '%s' %argv[2]), atoms, format='%s' %argv[2])
        # obabel -
    else:
        continue