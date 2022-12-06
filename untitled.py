from ase.io import read, write
import os

for file in os.listdir('./'):
    if file.endswith('.vasp'):
        name, ext = os.path.splitext(file)
        atoms=read(file)
        atoms.rotate(-90, 'x', center=(0, 0, 0))
        write(file, atoms, format='vasp')