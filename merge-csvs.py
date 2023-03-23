import os
import numpy as np
from sys import argv

# Set the parent directory path where the CSV files are located to the current working directory
parent_dir = './'

# Get a list of all the subdirectories in the parent directory
subdirs = sorted([d for d in os.listdir(parent_dir) if os.path.isdir(os.path.join(parent_dir, d))])

# Create an empty list to store the concatenated data
data = []

# Loop through each subdirectory and concatenate the CSV files
for subdir in subdirs:
    subdir_path = os.path.join(parent_dir, subdir)
    for f in sorted(os.listdir(subdir_path)):
        if os.path.isfile(os.path.join(subdir_path, f)) and f.endswith('.csv'):
            subdir_data = np.loadtxt(os.path.join(subdir_path, f), dtype=str, delimiter=',')
            data.append(subdir_data)

np.savetxt("merged.csv", np.transpose(data), delimiter =", ", fmt ='% s')
