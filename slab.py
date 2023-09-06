from sys import argv
from os import system
from ase.io import read, write
from ase.build import surface
from ase.constraints import FixAtoms

filename=argv[1]
numb=int(argv[2])
vacuum=15.0
boundary=1.0
i=1

if argv[2]==None:
    print('usage: slab [filename] [numb]')
    break
    
while i <= numb:
    system(f'rmv slab{i}.vasp xc{i}.vasp')
    bulk=read(f'{filename}{i}.vasp')
    slab=surface(bulk, (1,1,1), 4, vacuum/2)
    slab.positions+=(0,0,0.1-vacuum/2)
    # write(f'slab{i}.vasp',slab)
    # slab=read(f'slab{i}.vasp')
    write(f'slab{i}.vasp',slab.repeat((2,2,1)))
    system(f'python ~/bin/pyband/xcell.py -i slab{i}.vasp -o xc{i}.vasp')
    xcell=read(f'xc{i}.vasp')
    min_z=xcell.positions[:,2].min()
    # min_z=min([atom.position[2] for atom in xcell])
    # print(min_z)
    # del xcell.constraints
    xcell.symbols[12]='Pt'
    xcell.symbols[13]='Pt'
    xcell.symbols[14]='Pt'
    xcell.symbols[15]='Pt'
    fixed=FixAtoms(indices=[atom.index for atom in xcell if atom.position[2] <= min_z + boundary])
    # print(fixed)
    xcell.set_constraint(fixed)
    write(f'fix{i}.vasp',xcell)
    i=i+1

system('rm slab*.vasp xc*.vasp')