import argparse
from os import system
from ase.io import read, write

parser = argparse.ArgumentParser(description='Command-line options example')

parser.add_argument('filename', type=str, default='a.vasp', help='input filename (e.g., a for a1~a3.vasp)')
parser.add_argument('-n', '--number', type=int, default=0, help='the number of water molecules')
parser.add_argument('-l', '--layer',type=int, default=4, help='the number of water layers')
# parser.add_argument('-s', '--surface', type=int, default=9, help='the number of surface atoms')
parser.add_argument('-s', '--seed', type=int, default=3, help='the number of seeds')
parser.add_argument('-o', '--output', type=str, default='water-slab', help='output filename')

# args, remaining_args = parser.parse_known_args()
args = parser.parse_args()
        
# Process arguments parsed by argparse
filename = args.filename
number = args.number
layer = args.layer
seed = args.seed
output = args.output

slab=read(filename)
a=slab.cell[0][0]
b=slab.cell[1][1]
c=slab.cell[2][2]
z=slab.positions[:,2].max()

factor=4/8.490373/4.901919 # ase WL.pj
number=int(a*b*factor*layer)+1
while number < 2:
    print("How many water layers do you want?")
    layer=input()
    number=int(a*b*factor*layer)+1

top=z+number/a/b*10**30/997/1000*18.01528/(6.022*10**23)
a=round(a, 3)
b=round(b, 3)
c=round(c, 3)
z=round(z, 3)
top=round(top, 3)
system(f'sh ~/bin/orange/water-slab.sh {a} {b} {c} {z} {top} {number} {seed} {output}')

for i in range(1,seed+1):
    water=read(f'{output}{i}.vasp')
    write(f'hello{i}.vasp',slab+water)