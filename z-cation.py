from ase.io import read
from ase.io.vasp import read_vasp_xdatcar
import numpy as np

# Define the cation symbols and their corresponding cutoff distances
cation_cutoffs = {'Li': 2.5,
                  'Na': 3.0,
                  'K' : 3.5,
                  'Rb': 3.8,
                  'Cs': 4.1}

# Read the XDATCAR file
structures = read_vasp_xdatcar('XDATCAR', index=0)

# Find the cation symbol
cation = None
for atom in structures[0]:
    if atom.symbol in cation_cutoffs:
        cation = atom.symbol
        # cutoff = cation_cutoffs[cation]
        break
else:
    raise ValueError('Could not find cation in XDATCAR')

min_z_positions = []
for atoms in structures:
    min_z_position = [atom.position[2] for atom in atoms if atom.symbol == cation]
    min_z_positions.append(min_z_position)

# Save the minimum z-positions as a csv file
np.savetxt(f'min_z_positions_{cation}.csv', min_z_positions, delimiter=',')
