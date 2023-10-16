# from sys import argv
from ase.io import read, write
from ase.io.vasp import read_vasp_xdatcar, write_vasp_xdatcar

parser = argparse.ArgumentParser(description='Command-line options example')

parser.add_argument('filename', type=str, default='POSCAR', help='input filename (e.g., a for a1~a3.vasp, OR you can type POSCAR, CONTCAR, XDATCAR)')
parser.add_argument('-n', '--number', type=int, default=0, help='the number of files (e.g., 3 for a1~a3.vasp)')
parser.add_argument('-z', '--height', type=float, default=None, help='z-axis length (A)')

# args, remaining_args = parser.parse_known_args()
args = parser.parse_args()
        
# Process arguments parsed by argparse
filename = args.filename
number = args.number
height = args.height
    
# filename=argv[1]
if filename=='XDATCAR':
    structures = read_vasp_xdatcar('XDATCAR', index=0)
    # for atoms in structures:
    #     atoms.cell[2][2]=50
    # write_vasp_xdatcar('test_XDATCAR', structures)
elif number==0:
    atoms=read(f'{filename}')
    atoms.wrap()
    if height:
        atoms.cell[2][2]=height
    write(f'{filename}',atoms)
else:
    i=1
    while i <= number:
        atoms=read(f'{filename}{i}.vasp')
        atoms.wrap()
        if height:
            atoms.cell[2][2]=height
        write(f'{filename}{i}.vasp',atoms)
        i+=1