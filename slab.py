from sys import argv
from ase.io import read, write
from ase.build import surface
from ase.constraints import FixAtoms

filename=argv[1]
numb=int(argv[2])
i=1

while i <= numb:
    bulk=read(f'{filename}{i}.vasp')
    slab=surface(bulk, (1,1,1), 4, vacuum=15)
    # write(f'slab{i}.vasp',slab)
    # slab=read(f'slab{i}.vasp')
    write(f'slab{i}.vasp',slab.repeat((2,2,1)))
    os.system(f'~/bin/pyband/xcell.py -i slab{i}.vasp -o xc{i}.vasp')
    xcell=read(f'xc{i}.vasp')
    min_z=min(xcell.position[2])
    fixed=FixAtoms(indices=[atom.index for atom in xcell if atom.position[2] <= min_z + 1])
    xcell.set_constraint(fixed)
    write(f'fix{i}.vasp',fixed)
    i=i+1

# os.system('rm slab*.vasp xc*.vasp')