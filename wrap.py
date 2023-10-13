from sys import argv
from ase.io import read, write
from ase.io.vasp import read_vasp_xdatcar, write_vasp_xdatcar

filename=argv[1]
if filename=='XDATCAR':
    structures = read_vasp_xdatcar('XDATCAR', index=0)
    for atoms in structures:
        atoms.wrap()
    write_vasp_xdatcar('test_XDATCAR', structures)
else:
    atoms=read(f'{filename}')
    atoms.wrap()
    if len(argv)==3:
        height=float(argv[2])
        atoms.cell[2][2]=height
    write(f'{filename}',atoms)