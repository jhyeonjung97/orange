from sys import argv
from ase.io import read

#usage: charge (-tot) (-all) [elements]

def charges(atoms, fileobj='ACF.dat', element='O'):
    """Attach the charges from the fileobj to the Atoms."""
    if isinstance(fileobj, str):
        fileobj = open(fileobj)

    sep = '---------------'
    i = 0 # Counter for the lines
    k = 0 # Counter of sep
    sum0 = 0
    assume6columns = False
    for line in fileobj:
        if line[0] == '\n': # check if there is an empty line in the 
            i -= 1          # head of ACF.dat file   
        if i == 0:
            headings = line
            if 'BADER' in headings.split():
                j = headings.split().index('BADER')
            elif 'CHARGE' in headings.split():
                j = headings.split().index('CHARGE')
            else:
                print('Can\'t find keyword "BADER" or "CHARGE".' \
                +' Assuming the ACF.dat file has 6 columns.')
                j = 4
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
            atom.charge = float(words[j])
        i+=1
    for atom in atoms:
        if atom.symbol == element:
            print(f"{element}{atom.index}\t {atom.charge:.2f}")
            sum0+=atom.charge
    if show_total:
        print('\033[1m' + f"{element}_sum\t {sum0:.2f}" + '\033[0m')
    return sum0

atoms = read('POSCAR')
fileobj = 'ACF.dat'

if '-tot' in argv:
    elements = argv[1:] - '-tot'
    show_total = True
else:
    elements = argv[1:]
    show_total = False

if len(elements) == 0 or '-all' in argv:
    print('subjects are all elements..')
    elements = [*set(atoms.symbols)]
    
total=0
for element in elements:
    total+=charges(atoms, 'ACF.dat', element)
if show_total:
    print('------------------')
    print(f"total\t {total:.2f}")
    