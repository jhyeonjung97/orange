from ase.io import read, write
import os

pt = read('pt.vasp')
for files in os.listdir('./'):
    if files.endswith('.vasp') and not files.startswith('pt'):
        atoms = read(files) + pt
        write(files, atoms)