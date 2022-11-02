import numpy as np
from ase.io import read, write
from ase.units import Bohr
from ase.visualize import view

def attach_charges(atoms, fileobj='ACF.dat', displacement=1e-4, use_diff=True,
                   use_bohr=True):
    """Attach the charges from the fileobj to the Atoms."""
    if isinstance(fileobj, str):
        fileobj = open(fileobj)

    sep = '---------------'
    i = 0 # Counter for the lines
    k = 0 # Counter of sep
    assume6columns = False
    for line in fileobj:
        print(line) ##
        if line[0] == '\n': # check if there is an empty line in the 
            i -= 1          # head of ACF.dat file
            
        if i == 0:
            headings = line
            print(headings.split())
            if 'BADER' in headings.split():
                j = headings.split().index('BADER')
                print('BADER') ##
            elif 'CHARGE' in headings.split():
                j = headings.split().index('CHARGE')
                print('CHARGE') ##
            else:
                print('Can\'t find keyword "BADER" or "CHARGE".' \
                +' Assuming the ACF.dat file has 6 columns.')
                j = 4
                print(j) ##
                assume6columns = True
        if sep in line: # Stop at last seperator line
            if k == 1:
                break
            k += 1
        if not i > 1:
            pass
        else:
            words = line.split()
            if assume6columns is True:
                if len(words) != 6:
                    raise IOError('Number of columns in ACF file incorrect!\n'
                                  'Check that Bader program version >= 0.25')
                
            atom = atoms[int(words[0]) - 1]
            if use_diff:
                atom.charge = atom.number - float(words[j])
            else:
                atom.charge = float(words[j])
            if displacement is not None: # check if the atom positions match
                if use_bohr:
                    xyz = np.array([float(w) for w in words[1:4]]) * Bohr
                else:
                    xyz = np.array([float(w) for w in words[1:4]])
                assert np.linalg.norm(atom.position - xyz) < displacement
        i+=1

atoms = read('POSCAR')
attach_charges(atoms, 'ACF.dat', use_bohr=False, use_diff=False)