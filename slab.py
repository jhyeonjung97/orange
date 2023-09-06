from sys import argv
from os import system
from ase.io import read, write
from ase.build import surface
from ase.constraints import FixAtoms

filename=argv[1]
numb=int(argv[2])
vacuum=15.0
i=1

while i <= numb:
    bulk=read(f'{filename}{i}.vasp')
    slab=surface(bulk, (1,1,1), 4, vacuum/2)
    
    # write(f'slab{i}.vasp',slab)
    # slab=read(f'slab{i}.vasp')
    write(f'slab{i}.vasp',slab.repeat((2,2,1)))
    system(f'~/bin/pyband/xcell.py -i slab{i}.vasp -o xc{i}.vasp')
    xcell=read(f'xc{i}.vasp')
    min_z=min(xcell.positions[2])
    # del xcell.constraints
    print(atom.index for atom in xcell if atom.position[2] <= min_z)
    fixed=FixAtoms(indices=[atom.index for atom in xcell if atom.position[2] <= min_z])
    print(fixed)
    xcell.set_constraint(fixed)
    write(f'fix{i}.vasp',xcell)
    i=i+1

# os.system('rm slab*.vasp xc*.vasp')