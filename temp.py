import os
from ase.io import read, write
from ase.constraints import FixAtoms


for file in os.listdir('./'):
    if file.endswith('.vasp'):
        atoms=read(file)
        # del atoms[[atom.index for atom in atoms if atom.z <= 7.0 and atom.symbol == 'H' ]]
        fixed=FixAtoms(indices=[atom.index for atom in atoms if atom.symbol != 'Li' and atom.symbol != 'S'])
        atoms.set_constraint(fixed)
        write(file,atoms)
        
# from ase.io import read, write
# from ase.build import sort

# import os

# a = read('a0.vasp') + read('b0.vasp')
# b = read('a1.vasp') + read('b1.vasp')
# c = read('a2.vasp') + read('b2.vasp')
# d = read('a3.vasp') + read('b3.vasp')
# e = read('a4.vasp') + read('b4.vasp')
# f = read('a5.vasp') + read('b5.vasp')
# g = read('a6.vasp') + read('b6.vasp')
# h = read('a7.vasp') + read('b7.vasp')
# i = read('a8.vasp') + read('b8.vasp')
# j = read('a9.vasp') + read('b9.vasp')

# write('d0.vasp', a)
# write('d1.vasp', b)
# write('d2.vasp', c)
# write('d3.vasp', d)
# write('d4.vasp', e)
# write('d5.vasp', f)
# write('d6.vasp', g)
# write('d7.vasp', h)
# write('d8.vasp', i)
# write('d9.vasp', j)

# # for files in os.listdir('./'):
# #     if files.endswith('.vasp') and files.startswith('b'):
# #         atoms = read(files)
# #         # atoms = sort(atoms)
# #         # atoms.wrap()
# #         del atoms[[atom.z > 10.0 for atom in atoms]]
# #         write(files, atoms)