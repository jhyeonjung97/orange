import os
import pandas as pd

# Set the parent directory path where the CSV files are located to the current working directory
parent_dir = './'

# Get a list of all the subdirectories in the parent directory
subdirs = [d for d in os.listdir(parent_dir) if os.path.isdir(os.path.join(parent_dir, d))]

# Create an empty list to store the dataframes
dfs = []

# Loop through each subdirectory and append the CSV files to the list of dataframes
for subdir in subdirs:
    subdir_path = os.path.join(parent_dir, subdir)
    subdir_csv_files = [f for f in os.listdir(subdir_path) if os.path.isfile(os.path.join(subdir_path, f)) and f.endswith('.csv')]
    for csv_file in subdir_csv_files:
        df = pd.read_csv(os.path.join(subdir_path, csv_file))
        dfs.append(df)

# Concatenate all the dataframes into one
result = pd.concat(dfs)

# Set the output file name as "merged.csv"
output_name = "merged.csv"

# Save the concatenated dataframe to a new CSV file
result.to_csv(output_name, index=False)

print("CSV files have been merged and saved to", output_name)