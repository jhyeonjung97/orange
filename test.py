from ase.io import read
from ase.io.vasp import read_vasp_xdatcar
import numpy as np

# Define the cation symbols and their corresponding cutoff distances
cation_cutoffs = {'Li': 2.60087,
                  'Na': 2.95693,
                  'K': 3.25142,
                  'Rb': 3.43945,
                  'Cs': 3.53642}

# Read the XDATCAR file
structures = read_vasp_xdatcar('XDATCAR', index=0)
cell = structures[0].cell

# Find the cation symbol
cation = None
for atom in structures[0]:
    if atom.symbol in cation_cutoffs:
        cation = atom.symbol
        cutoff = cation_cutoffs[cation]
        break
else:
    raise ValueError('Could not find cation in XDATCAR')

min_z_positions = []
i = 7999
atoms = structures[7999]
# for i, atoms in enumerate(structures):
# Get the indices of cation and water oxygen atoms
cation_indices = [j for j, atom in enumerate(atoms) if atom.symbol == cation]
print(cation_indices)
water_oxygen_indices = [j for j, atom in enumerate(atoms) if atom.symbol == 'O']
print(water_oxygen_indices)
min_z_position = None
for cation_index in cation_indices:
    for water_oxygen_index in water_oxygen_indices:
        # Calculate the distance between cation and water oxygen
        dr = atoms[water_oxygen_index].position - atoms[cation_index].position

        # Apply minimum image convention to account for periodic boundary conditions
        for m in range(2):
            if abs(dr[m]) > cell[m,m]/2:
                if dr[m] > 0:
                    dr[m] -= cell[m,m]
                else:
                    dr[m] += cell[m,m]

        distance = np.linalg.norm(dr)

        if distance <= cutoff:
            # Get the indices of hydrogen atoms in the water molecule
            hydrogen_indices = []
            for j, atom in enumerate(atoms):
                if atom.symbol == 'H':
                    for m in range(2):
                        dr = atom.position - atoms[water_oxygen_index].position
                        if abs(dr[m]) > cell[m,m]/2:
                            if dr[m] > 0:
                                dr[m] -= cell[m,m]
                            else:
                                dr[m] += cell[m,m]
                    if np.linalg.norm(dr) <= 1.2:
                        hydrogen_indices.append(j)

            # Get the minimum z-position of hydrogen atoms in the water molecule
            z_positions = [atoms[j].position[2] for j in hydrogen_indices]
            if z_positions:
                min_z = min(z_positions)
                if min_z_position is None or min_z < min_z_position:
                    min_z_position = min_z