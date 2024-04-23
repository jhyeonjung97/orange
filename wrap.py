import os
import glob
import argparse
from ase.io import read, write
from ase.build.tools import sort
from ase.constraints import FixAtoms
from ase.io.vasp import read_vasp_xdatcar, write_vasp_xdatcar

parser = argparse.ArgumentParser(description='Command-line options example')
parser.add_argument('filename', type=str, default='POSCAR', help='input filename (e.g., a for a1~a3.vasp, OR you can type POSCAR, CONTCAR, XDATCAR)')
parser.add_argument('-a', '--add', type=float, default=0)
parser.add_argument('-z', '--height', type=float, default=None)
parser.add_argument('-f', '--fix', action='store_true', default=False)
parser.add_argument('-s', '--sort', action='store_true', default=False)
parser.add_argument('-w', '--wrap', action='store_true', default=False)
parser.add_argument('-c', '--center', action='store_true', default=False)
parser.add_argument('--facet', type=str, default='0,0,1')
parser.add_argument('-r', '--repeat', type=str, default='1,1,1')

args = parser.parse_args()
filename = args.filename
height = args.height
add = args.add

facet = args.facet
repeat = args.repeat
x, y, z = map(int, facet.split(','))
a, b, c = map(int, repeat.split(','))

pattern = os.path.join('./', f'{filename}*.vasp')
matching_files = glob.glob(pattern)
for file in matching_files:
    atoms = read(f'{file}')
    if repeat:
        atoms = atoms.repeat((a,b,c))
    if args.wrap:
        atoms.wrap()
    if args.center:
        atoms.center()
    if args.sort:
        atoms = sort(atoms)
    if add:
        l1 = atoms.cell.lengths()[0]
        l2 = atoms.cell.lengths()[1]
        l3 = atoms.cell.lengths()[2]
        a1 = atoms.cell.angles()[0]
        a2 = atoms.cell.angles()[1]
        a3 = atoms.cell.angles()[2]
        atoms.cell = (l1, l2, l3+add, a1, a2, a3)
    if height:
        l1 = atoms.cell.lengths()[0]
        l2 = atoms.cell.lengths()[1]
        # l3 = atoms.cell.lengths()[2]
        a1 = atoms.cell.angles()[0]
        a2 = atoms.cell.angles()[1]
        a3 = atoms.cell.angles()[2]
        atoms.cell = (l1, l2, height, a1, a2, a3)
    if args.fix:
        min_z = atoms.positions[:,2].min()
        max_z = atoms.positions[:,2].max()
        mid_z = (min_z + max_z) / 2
        fixed = FixAtoms(indices=[atom.index for atom in atoms if atom.position[2] < mid_z])
        atoms.set_constraint(fixed)
    write(f'{file}',atoms)