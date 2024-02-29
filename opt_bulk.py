import json
import subprocess
import numpy as np
from os import path
from mendeleev import element
from ase.io import read, write
from ase.visualize import view
from ase.constraints import FixAtoms
from ase.calculators.vasp import Vasp
from ase.io.trajectory import Trajectory
import ase.calculators.vasp as vasp_calculator

name = 'vasp_run1'

spin_states_plus_4={'Sc': 0, 'Ti': 0, 'V': 1, 'Cr': 2, 'Mn': 3, 'Fe': 4, 
                    'Co': 1, 'Ni': 0, 'Cu': 3, 'Zn': 2, 'Ga': 1, 'Ge': 0,
                    'Y': 0, 'Zr': 0, 'Nb': 1, 'Mo': 2, 'Tc': 3, 'Ru': 0, 
                    'Pd': 0, 'Rh': 0, 'Ag': 0, 'Cd': 0, 'In': 0, 'Sn': 0,
                    'Hf': 0, 'Ta': 1, 'W': 2, 'Re': 1, 'Os': 0, 'Ir': 0, 
                    'Pt': 0, 'Au': 0, 'Hg': 0, 'Tl': 0, 'Pb': 0, 'La': 0,
                   }

"""
setups= {'Sn':'_d',
         'Bi':'_d',
         'Ge':'_d',
         'Tl':'_d',
         'At':'_d',
         'Pb':'_d',
         'Po':'_d',
         'Ga':'_d',
         'In':'_d',
         'As':'_d' }
"""

if path.exists('restart.json'):
    atoms=read('restart.json')
else:
    atoms=read('start.traj')
    for a in atoms:
        if not a.symbol=='O':
            a.magmom = spin_states_plus_4.get(a.symbol)

#cons = FixAtoms([a.index for a in atoms])

subprocess.call('cp -rf OUTCAR OUTCAR_$(date +%s)', shell=True)
subprocess.call('cp -rf moments.traj moments.traj_$(date +%s)', shell=True)

atoms.write(name+'_init'+'.traj')
atoms.write(name+'_init'+'.cif')

def get_bands(atoms):
    """
    returns the extact number of bands desired by lobster for the pCOHP calculations
    """
    nbands = 0
    for sym in atoms.get_chemical_symbols():
        if sym == 'H': # H is bugged
            nbands += 1
            continue
        config = element(sym).ec.get_valence().to_str()
        config = config.split()
        #if sym == 'Zr':
        #    nbands += 15
        for c in config:
            if 's' in c:
                nbands += 1
            elif 'p' in c:
                nbands += 3
            elif 'd' in c:
                nbands += 5
            elif 'f' in c:
                nbands += 7
    return nbands

def get_kpoints(atoms, effective_length=25, bulk=False):
    """
    Return a tuple of k-points derived from the unit cell.
    
    Parameters
    ----------
    atoms : object
    effective_length : k-point*unit-cell-parameter
    bulk : Whether it is a bulk system.
    """
    l = effective_length
    cell = atoms.get_cell()
    nkx = int(round(l/np.linalg.norm(cell[0]),0))
    nky = int(round(l/np.linalg.norm(cell[1]),0))
    if bulk == True:
        nkz = int(round(l/np.linalg.norm(cell[2]),0))
    else:
        nkz = 1
    return((nkx, nky, nkz))

bands = get_bands(atoms)
kpoints = get_kpoints(atoms, effective_length=25, bulk=True)

calc = vasp_calculator.Vasp(istart=1,
                            encut=600,
                            xc='PBE',
                            gga='PE',
                            kpts=(7,7,10),
                            kpar=8,
                            npar=1,
                            gamma=True,
                            ismear=0,
                            inimix=0,
                            amix= 0.05,
                            bmix= 0.0001,
                            amix_mag=0.05,
                            bmix_mag=0.0001,
                            nelm=250,
                            sigma=0.05,
                            algo='normal',
                            ibrion=2, 
                            isif=2,
                            ediffg=-0.02,
                            ediff=1e-6,
                            prec='Normal',
                            nsw=99,
                            lvtot=False,
                            nbands=100,
                            ispin=2,
                            setups='recommended',
                            ldau=True,
                            ldautype=2,
                            laechg=True,
                            lreal='False',
                            lasph=True, 
                            ldau_luj={'Ti':{'L':2,  'U':3.00, 'J':0.0},
                                      'V': {'L':2,  'U':3.25, 'J':0.0},
                                      'Cr':{'L':2,  'U':3.5,  'J':0.0},
                                      'Mn':{'L':2,  'U':3.75, 'J':0.0},
                                      'Fe':{'L':2,  'U':4.3,  'J':0.0},
                                      'Co':{'L':2,  'U':3.32, 'J':0.0},
                                      'Ni':{'L':2,  'U':6.45, 'J':0.0},
                                      'Cu':{'L':2, 'U':3.0,  'J':0.0},
                                      'Mo':{'L':2,  'U':4.38,  'J':0.0},
                                      'W':{'L':2,  'U':3.0,  'J':0.0},
                                      'Ce':{'L':3,  'U':4.50, 'J':0.0},
                                      'O':{'L':-1,  'U':0.0,  'J':0.0},
                                      'C':{'L':-1,  'U':0.0,  'J':0.0},
                                      'Au':{'L':-1, 'U':0.0,  'J':0.0},
                                      'Ir':{'L':-1, 'U':0.0,  'J':0.0},
                                      'H':{'L':-1,  'U':0.0,  'J':0.0},
                                     },
                            ldauprint=2,
                            lmaxmix=6,
                            # icharg=11,
                            isym=0, 
                            nedos=3000,
                            # lmaxmix=4,
                            lorbit=11,
                            # idipol=3,
                            # dipol=(0, 0, 0.5),
                            # ldipol=True
                            txt='out.vasp'
                           )

cell = atoms.cell.copy()

engs = []
vols = []

atoms.set_calculator(calc)
eng = atoms.get_potential_energy()

print ('Calculation Complete, storing the run + calculator to traj file')

traj2=Trajectory('final_with_calculator.traj',  'w') 	
traj2.write(atoms)

subprocess.call('ase convert -f final_with_calculator.traj  final_with_calculator.json', shell=True)
subprocess.call('ase convert -f OUTCAR full_relax.json', shell=True)