import sys
import argparse
from os import system
from ase.io import read, write
from ase.build import surface
from ase.constraints import FixAtoms

parser = argparse.ArgumentParser(description='Command-line options example')

parser.add_argument('-v', '--vacuum', type=float, default=20.0, help='Vaccum layer thickness (A)')
parser.add_argument('-z', '--boundary', type=float, default=1.0, help='Boundary for fixed atoms (A)')
parser.add_argument('-l', '--vector', type=str, default='1,1,1', help='vector of surface index (e.g., "a,b,c")')
parser.add_argument('-r', '--repeat', type=str, default='2,2,1', help='repeat (e.g., "a,b,c")')

args, remaining_args = parser.parse_known_args()

# Process the 'coordinates' option
if args.vector:
    x, y, z = args.vector.split(',')
    x=int(x); y=int(y); z=int(z)
else:
    print('Vector not provided.')
    
if args.repeat:
    a, b, c = args.repeat.split(',')
    a=int(a); b=int(b); c=int(c)
else:
    print('Repeat not provided.')
        
# Process arguments parsed by argparse
vacuum = args.vacuum
boundary = args.boundary

# Process remaining arguments using sys.argv
for arg in remaining_args:
    if arg.startswith('-'):
        print(f"Unrecognized option: {arg}")
        sys.exit()

if len(remaining_args) < 2:
    parser.print_help()
    sys.exit()
else:
    filename=str(remaining_args[0])
    numb=float(remaining_args[1])

i=1
while i <= numb:
    # system(f'sh ~/bin/orange/rmv.sh slab{i}.vasp xc{i}.vasp')
    bulk=read(f'{filename}{i}.vasp')
    bulk.positions+=(0,0,bulk.cell[2,2])
    slab=surface(bulk, (x,y,z), 4, vacuum/2)
    slab.positions+=(0,0,0.1-vacuum/2)
    # write(f'slab{i}.vasp',slab)
    # slab=read(f'slab{i}.vasp')
    write(f'slab{i}.vasp',slab.repeat((a,b,c)))
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

#system('rm slab*.vasp xc*.vasp')
#system(f'sh ~/bin/orange/rename.sh fix.vasp {filename}.vasp')
