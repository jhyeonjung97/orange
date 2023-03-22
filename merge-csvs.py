import os
import numpy as np
import pandas as pd

# Set the parent directory path where the CSV files are located to the current working directory
parent_dir = './'

# Get a list of all the subdirectories in the parent directory
subdirs = [d for d in os.listdir(parent_dir) if os.path.isdir(os.path.join(parent_dir, d))]
print(subdirs)
# Create an empty list to store the concatenated data
data = []

# Loop through each subdirectory and concatenate the CSV files
for subdir in subdirs:
    subdir_path = os.path.join(parent_dir, subdir)
    for f in os.listdir(subdir_path):
        if os.path.isfile(os.path.join(subdir_path, f)) and f.endswith('.csv'):
            print(f)
            subdir_data = np.transpose(np.transpose(np.loadtxt(f, dtype=str, delimiter=','))[0])
            print(subdir_data)
            data.append(subdir_data)
            
# for i in range(1,1+1):
#     path = "./{i}/"
#     for f in os.listdir(path):
#         if os.path.isfile(os.path.join(path, f)) and f.endswith('.csv'):
#             chg = np.loadtxt(f, dtype=str)
#             data.append(subdir_data)

np.savetxt("merged.csv", np.transpose(data), delimiter =", ", fmt ='% s')
print(data)
