from ase.io import read, write
import os
import sys.argv

a = sys.argv[1]
if a == '':
    print('use default lattice parameter, 30 A ...')
    a = 30.

# iterating over all files
for files in os.listdir('./'):
    if files.endswith('.xyz'):
        atoms = read(files)
        atoms.set_cell([a, a, a])
        atoms.center()
        write(files.replace('xyz', 'cif'), atoms, format='cif')
    else:
        continue