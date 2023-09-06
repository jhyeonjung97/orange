from sys import argv
from ase.io import read, write
from ase.build import surface
from ase.constraints import FixAtoms

bulk=read(f'a{argv[1]}.vasp',format='vasp')
slab=surface(bulk, (1,1,1), 4, vacuum=15)
write('b1.vasp',slab,format='vasp')
# slab=read('b1.vasp',format='vasp')
write('c1.vasp',slab.repeat((2,2,1)),format='vasp')

os.system(f"~/bin/pyband/xcell.py -i a1.vasp -o o2.vasp")

os.system(f"~/bin/pyband/xcell.py -i {filename.replace('xyz', 'vasp')}")


c = FixAtoms(indices=[atom.index for atom in atoms if atom.symbol == 'Cu'])
atoms.set_constraint(c)

month = 1
while month <= 12:
    print(f'2020년 {month}월')
    month = month + 1