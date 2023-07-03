from ase.io import read, write
import os

for files in os.listdir('./'):
    if files.endswith('.vasp'):
        atoms = read(files)
        del atoms[[atom.symbol == 'Pt' for atom in atoms]]
        write(files, atoms)
    else:
        continue