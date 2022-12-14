from ase.io import read, write
from sys import argv, exit
import os

# if len(argv) < 8 or '-h' in argv:
#     print("usage: xyz2hex.py *.xyz a b c alpha beta gamma\n")
#     exit(0)

filename = argv[1]
atoms = read(filename)

# a = float(argv[2])
# b = float(argv[3])
# c = float(argv[4])

# alpha = float(argv[5])
# beta  = float(argv[6])
# gamma = float(argv[7])

#atoms.set_cell([a, b, c, alpha, beta, gamma])
#atoms.set_cell([8.92652, 8.92652, 30.00000, 90., 90., 120.])
atoms.set_cell([30., 30., 30., 90., 90., 90.])

write(filename.replace('xyz', 'vasp'), atoms, format='vasp')
#write('mixture.xyz'.replace('xyz', 'vasp'), atoms, format='vasp')

os.system(f"~/bin/pyband/xcell.py -i {filename.replace('xyz', 'vasp')}")
os.system(f"mv out*.vasp {filename.replace('xyz', 'vasp')}")

