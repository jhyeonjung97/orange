import sys
import argparse
from os import system
from ase.io import read, write
from ase.build import surface
from ase.constraints import FixAtoms

parser = argparse.ArgumentParser(description='Command-line options example')

parser.add_argument('filename', type=str, default='a.vasp', help='input filename (e.g., a for a1~a3.vasp)')
parser.add_argument('-n', '--number', type=int, default=0, help='the number of files (e.g., 3 for a1~a3.vasp)')
parser.add_argument('-o', '--output',type=str, default='slab.vasp', help='output filename')
parser.add_argument('-v', '--vacuum', type=float, default=20.0, help='Vaccum layer thickness (A)')
parser.add_argument('-z', '--boundary', type=float, default=1.0, help='Boundary for fixed atoms (A)')
parser.add_argument('-f', '--facet', type=str, default='1,1,1', help='Surface facet vector (e.g., "x,y,z")')
parser.add_argument('-r', '--repeat', type=str, default='2,2', help='Repeat unit cell (e.g., "a,b")')
parser.add_argument('-l', '--layer', type=int, default=3, help='the number of layers')

# args, remaining_args = parser.parse_known_args()
args = parser.parse_args()
        
# Process arguments parsed by argparse
filename = args.filename
numb = args.number
vacuum = args.vacuum
boundary = args.boundary
layer = args.layer

# Process the 'output', 'facet' and 'repeat' option
if args.output:
    output = args.output
else:
    output = filename

if args.facet:
    x, y, z = map(int, args.facet.split(','))
    
if args.repeat:
    a, b = map(int, args.repeat.split(','))
# else:
#     print('Repeat not provided.')

# Process remaining arguments using sys.argv
# for arg in remaining_args:
#     if arg.startswith('-'):
#         print(f"Unrecognized option: {arg}")
#         sys.exit()

# if len(remaining_args) < 2:
#     parser.print_help()
#     sys.exit()
# else:
#     filename=str(remaining_args[0])
#     numb=int(remaining_args[1])

if numb == 0:
    i=0
else:
    i=1

while i <= numb:
    if numb == 0:
        i=None
    # system(f'sh ~/bin/orange/rmv.sh slab{i}.vasp xc{i}.vasp')
    bulk=read(f'{filename}{i}.vasp')
    bulk.positions+=(0,0,bulk.cell[2,2]/2)
    slab=surface(bulk, (x,y,z), layer, vacuum/2).repeat((a,b,1))
    slab.positions+=(0,0,0.1-vacuum/2)
    # write(f'slab{i}.vasp',slab)
    # slab=read(f'slab{i}.vasp')
    
    # # custom1
    # for atom in slab:
    #     if atom.position[2] > 5 and atom.symbol != 'S':
    #         atom.symbol='Pt'
            
    # custom2
    for atom in slab:
        if atom.position[2] > 5:
            atom.symbol='Ir'
            
    write(f'slab{i}.vasp',slab)
    system(f'python ~/bin/pyband/xcell.py -i slab{i}.vasp -o xc{i}.vasp')
    xcell=read(f'xc{i}.vasp')
    min_z=xcell.positions[:,2].min()
    # min_z=min([atom.position[2] for atom in xcell])
    # print(min_z)
    # del xcell.constraints
    
    fixed=FixAtoms(indices=[atom.index for atom in xcell if atom.position[2] <= min_z + boundary])
    # print(fixed)
    xcell.set_constraint(fixed)
    write(f'fix{i}.vasp',xcell)
    if numb > 0:
        i=i+1

system('rm slab*.vasp xc*.vasp')
system(f'sh ~/bin/orange/rename.sh fix.vasp {output}.vasp')
