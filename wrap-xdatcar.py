from sys import argv
from ase.io import read, write
from ase.io.vasp import read_vasp_xdatcar


cell = structures[0].cell



filename=argv[1]
if not filename=='XDATCAR':
    structures = read_vasp_xdatcar('XDATCAR', index=0)
else:
    atoms=read(f'{filename}')
    atoms.wrap()
    if len(argv)==3:
        height=float(argv[2])
        atoms.cell[2][2]=height
    write(f'{filename}',atoms)