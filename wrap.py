from ase.io import read, write
from sys import argv

filename=argv[1]
atoms=read(f'{filename}')
atoms.wrap()

# for a in ['a', 'b', 'c']:
#     for i in range(0,9):
#         atoms=read(f'{a}{i}.vasp')
#         atoms.cell[2][2]=vac
#         write(f'{a}{i}.vasp',atoms)

if len(argv)==3:
    height=float(argv[2])
    atoms.cell[2][2]=height

write(f'{filename}',atoms)