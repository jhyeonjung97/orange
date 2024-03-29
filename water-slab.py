import argparse
from os import system
from ase.io import read, write

parser = argparse.ArgumentParser(description='Command-line options example')

parser.add_argument('filename', type=str, default='CONTCAR', help='input slab filename (e.g., a1.vasp)')
# parser.add_argument('-n', '--filenumb', type=int, default=3, help='the number of files (e.g., 3 for a1~a3.vasp)')
parser.add_argument('-w', '--waternumb', type=int, default=0, help='the number of water molecules')
parser.add_argument('-l', '--layer',type=int, default=4, help='the number of water layers')
# parser.add_argument('-s', '--surface', type=int, default=9, help='the number of surface atoms')
parser.add_argument('-s', '--seed', type=int, default=3, help='the number of seeds')
parser.add_argument('-o', '--output', type=str, default='water-slab', help='output filename')

# args, remaining_args = parser.parse_known_args()
args = parser.parse_args()
        
# Process arguments parsed by argparse
filename = args.filename
# filenumb = args.filenumb
waternumb = args.waternumb
layer = args.layer
seed = args.seed
output = args.output

print(filename)
slab=read(f'{filename}')
a=slab.cell[0][0]
b=slab.cell[1][1]
# c=slab.cell[2][2]
z=slab.positions[:,2].max()

factor=4/8.490373/4.901919 # ase WL.pj
waternumb=int(a*b*factor*layer)+1
while waternumb < 2:
    print("How many water layers do you want?")
    layer=input()
    waternumb=int(a*b*factor*layer)+1

top=waternumb/a/b*10**30/997/1000*18.01528/(6.022*10**23)*1.2

for i in range(1,seed+1):
    system(f'sh ~/bin/orange/water-slab.sh {a} {b} {top} {waternumb} {seed} {output}')
    water=read(f'{output}{i}_w.vasp')
    water.positions+=(0, 0, z+2.2)
    slab_water=slab+water
    slab_water.wrap()
    write(f'{output}{i}.vasp',slab_water)
        
system(f'~/bin/rm_mv *_w.vasp *_w.xyz')