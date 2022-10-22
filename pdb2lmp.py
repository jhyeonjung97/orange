from  ase.io import read, write
import ase.io.vasp

atoms = read('data.pdb')
#pos   = atoms.get_positions()
#print(pos) 
#ase.io.vasp.write_vasp('POSCAR',atoms,label='KShim',direct=False,sort=False)
write('mixture.data', atoms, format='lammps-data', units='real', atom_style='charge', cube=60.)
