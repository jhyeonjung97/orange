from ase.io import read, write

for a in ['a', 'b', 'c']:
    for i in range(0,9):
        atoms=read(f'{a}{i}.vasp')
        del atoms[[atom.index for atom in atoms if atom.symbol=='Fe']]
        del atoms[[atom.index for atom in atoms if atom.symbol=='Co']]
        del atoms[[atom.index for atom in atoms if atom.symbol=='Ni']]
        del atoms[[atom.index for atom in atoms if atom.symbol=='C']]
        write(f'{a}{i}.vasp',atoms)
    