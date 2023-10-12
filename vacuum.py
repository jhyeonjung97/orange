from ase.io import read, write

for a in ['a', 'b', 'c']:
    for i in range(0,9):
        atoms=read(f'{a}{i}.vasp')
        atoms.cell[2][2]+=5.0
        write(f'{a}{i}.vasp',atoms)