from ase.io import read, write
from sys import argv
import os

# if len(argv) == 2:
#     a = argv[1]
# else:
#     print('use default lattice parameter, 30 A ...')
#     a = 30.

# iterating over all files
for file in os.listdir('./'):
    if file.endswith('.cif'):
        # atoms = read(files)
        # # atoms.set_cell([a, a, a])
        # # atoms.center()
        # write(file.replace('cif', 'vasp'), atoms, format='vasp')
        python ~/bin/vaspkit/utilities/cif2pos.py file # file.replace('cif', 'vasp')
    else:
        continue