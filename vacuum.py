from ase.io import read, write
from sys import argv

vac=float(argv[1])
# for a in ['a', 'b', 'c']:
#     for i in range(0,9):
#         atoms=read(f'{a}{i}.vasp')
#         atoms.cell[2][2]=vac
#         write(f'{a}{i}.vasp',atoms)

atoms=read('POSCAR')
atoms.cell[2][2]=vac
write('POSCAR',atoms)