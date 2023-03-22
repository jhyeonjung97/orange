import os
import numpy as np
import pandas as pd

# Set the parent directory path where the CSV files are located to the current working directory
parent_dir = './'

# Get a list of all the subdirectories in the parent directory
subdirs = [d for d in os.listdir(parent_dir) if os.path.isdir(os.path.join(parent_dir, d))]

# Create an empty list to store the concatenated data
data = []

# Loop through each subdirectory and append the CSV files to the concatenated data
for subdir in subdirs:
    subdir_path = os.path.join(parent_dir, subdir)
    subdir_csv_files = [f for f in os.listdir(subdir_path) if os.path.isfile(os.path.join(subdir_path, f)) and f.endswith('.csv')]
    print(subdir_csv_files)
    df_csv_concat = pd.concat([pd.read_csv(file) for file in subdir_csv_files ], ignore_index=True)
    df_csv_concat