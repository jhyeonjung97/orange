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
for i, atoms in enumerate(structures):
    # Get the indices of cation and water oxygen atoms
    cation_indices = [j for j, atom in enumerate(atoms) if atom.symbol == cation]
    water_oxygen_indices = [j for j, atom in enumerate(atoms) if atom.symbol == 'O']

    min_z_position = None
    for cation_index in cation_indices:
        for water_oxygen_index in water_oxygen_indices:
            # Calculate the distance between cation and water oxygen
            dr = atoms[water_oxygen_index].position - atoms[cation_index].position

            # Apply minimum image convention to account for periodic boundary conditions
            for m in range(2):
                if abs(dr[m]) > cell[m,m]/2:
                    if dr[m] > 0:
                        dr -= cell[m]
                    else:
                        dr += cell[m]

            distance = np.linalg.norm(dr)

            if distance <= cutoff:
                # Get the indices of hydrogen atoms in the water molecule
                hydrogen_indices = []
                for j, atom in enumerate(atoms):
                    if atom.symbol == 'H':
                        dr = atom.position - atoms[water_oxygen_index].position
                        for m in range(2):
                            if abs(dr[m]) > cell[m,m]/2:
                                if dr[m] > 0:
                                    dr -= cell[m]
                                else:
                                    dr += cell[m]
                        if np.linalg.norm(dr) <= 1.2:
                            hydrogen_indices.append(j)

                # Get the minimum z-position of hydrogen atoms in the water molecule
                z_positions = [atoms[j].position[2] for j in hydrogen_indices]
                if z_positions:
                    min_z = min(z_positions)
                    if min_z_position is None or min_z < min_z_position:
                        min_z_position = min_z

    min_z_positions.append(min_z_position)
    # print(f"Iteration {i}: {min_z_position}")

# Save the minimum z-positions as a csv file
np.savetxt(f'min_z_positions_{cation}.csv', min_z_positions, delimiter=',')
