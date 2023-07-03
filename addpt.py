from ase.io import read, write
import os

pt = read('pt.vasp')
for files in os.listdir('./'):
    if files.endswith('.vasp') and not files.startswith('pt'):
        water = read(files)
        water.positions += (4.23734, 2.44643, 0)
        interface = water + pt
        write(files, interface)