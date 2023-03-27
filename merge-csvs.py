import os
import numpy as np

# Set the parent directory path where the CSV files are located to the current working directory
parent_dir = './'

# Get a list of all the subdirectories in the parent directory that start with a number
subdirs = sorted([d for d in os.listdir(parent_dir) if os.path.isdir(os.path.join(parent_dir, d)) and d[0].isdigit()])

# Loop through each subdirectory and show the list of CSV files
for subdir in subdirs:
    subdir_path = os.path.join(parent_dir, subdir)
    csv_files = sorted([f for f in sorted(os.listdir(subdir_path)) if os.path.isfile(os.path.join(subdir_path, f)) and f.endswith('.csv')])
    if csv_files:
        print(f"CSV files in {subdir_path}:")
        for csv_file in csv_files:
            print(f"\t{csv_file}")
    else:
        print(f"No CSV files found in {subdir_path}")

# Get the name of the CSV files to merge from the user
csv_name = input("Enter the name of the CSV files to merge: ")

# Create an empty list to store the concatenated data
data = []

# Loop through each subdirectory and concatenate the CSV files
for subdir in subdirs:
    subdir_path = os.path.join(parent_dir, subdir)
    for f in sorted(os.listdir(subdir_path)):
        if os.path.isfile(os.path.join(subdir_path, f)) and f.startswith(csv_name) and f.endswith('.csv'):
            subdir_data = np.loadtxt(os.path.join(subdir_path, f), dtype=str, delimiter=',')
            data.append(subdir_data)

np.savetxt("merged.csv", np.transpose(data), delimiter =", ", fmt ='% s')
