from ase.io import read, write
from ase.build import sort
from sys import argv
import os

# iterating over all files
for files in os.listdir('./'):
    if files.endswith('.xyz'):
        atoms = read(files)
        del atoms[[atom.symbol == 'Li' for atom in atoms]]
        write(files, atoms, format='xyz')
    else:
        continue
        
