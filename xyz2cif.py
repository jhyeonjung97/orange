from ase.io import read, write
import os
 
# iterating over all files
for files in os.listdir('./'):
    if files.endswith('.xyz'):
        atoms = read(files)
        atoms.set_cell([40., 40., 40., 90., 90., 90.])
        atoms.translate([20., 20., 20.])
        write(files.replace('xyz', 'cif'), atoms, format='cif')
    else:
        continue