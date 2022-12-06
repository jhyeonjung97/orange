from ase.io import read, write
import os

for file in os.listdir('./'):
    if file.endswith('.vasp'):
        name, ext = os.path.splitext(file)
        atoms=read(file)
        a = atoms.cell[0][0]
        b = atoms.cell[1][1]
        c = atoms.cell[2][2]
        # print(atoms.cell[0][0])
        for atom in atoms:
            if atom.symbol == 'Fe':
                center = atom.position
                # print(atom.position)
        atoms.positions -= center
        atoms.positions += (a/2, b/2, c/2)
        write(file, atoms, format='vasp')