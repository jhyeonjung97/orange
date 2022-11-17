from ase.io import read, write
from sys import argv, exit
import os

filename = argv[1]
atoms = read(filename)

atoms.set_cell([40., 40., 40., 90., 90., 90.])
write(filename.replace('xyz', 'cif'), atoms, format='cif')