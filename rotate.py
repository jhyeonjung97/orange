from ase.io import read, write
import os
from sys import argv

# for file in os.listdir('./'):
#     if file.endswith('.vasp'):
file = argv[1]
# name, ext = os.path.splitext(file)
atoms = read(file)
# angle=input('angle? ')
# axis=input('axis? (x, y, z) ')
atoms.rotate(180, 'z', center=(0, 0, 0))
# atoms.rotate(180, 'y', center=(0, 0, 0))
write(file, atoms, format='vasp')