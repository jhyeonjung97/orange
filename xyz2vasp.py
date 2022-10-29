#!/usr/bin/env python
import aselite
import numpy as np
from sys import argv, exit

#if len(argv) < 3 or '-h' in argv:
#    print "usage: xyz2vasp FILENAME a b c\n"
#    exit(0)
    
filename = argv[1]
atoms = aselite.read_xyz(filename)

atoms.positions -= np.min(atoms.positions)
#a = float(argv[2])
#b = float(argv[3])
#c = float(argv[4])
atoms.set_cell((20,20,20))


aselite.write_con(filename.replace('xyz', 'vasp'), atoms)
