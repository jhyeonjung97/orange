from ase.io import read, write

for a in ['a', 'b', 'c']:
    for i in range(0,9):
        atoms=read(f'{a}{i}.vasp')
        del taoms[[atom.index for atom in atoms if atom.symbol=='Fe']]
        del taoms[[atom.index for atom in atoms if atom.symbol=='Co']]
        del taoms[[atom.index for atom in atoms if atom.symbol=='Ni']]
        del taoms[[atom.index for atom in atoms if atom.symbol=='C']]
        write(f'{a}{i}.vasp',atoms)
    