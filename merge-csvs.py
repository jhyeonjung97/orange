import os
import pandas as pd

# Set the parent directory path where the CSV files are located to the current working directory
parent_dir = './'

# Get a list of all the subdirectories in the parent directory
subdirs = [d for d in os.listdir(parent_dir) if os.path.isdir(os.path.join(parent_dir, d))]

# Loop through each subdirectory and print its CSV files
for subdir in subdirs:
    print(f"CSV files in {subdir}:")
    files = os.listdir(os.path.join(parent_dir, subdir))
    for file in files:
        if file.endswith('.csv'):
            print(f"  {file}")
    print()

# Get the input file name (excluding file extension) from the user
input_name = input("Enter the name of the input CSV file (excluding file extension): ")

# Get a list of all the CSV files in the subdirectories that start with the input name
csv_files = []
for subdir in subdirs:
    subdir_path = os.path.join(parent_dir, subdir)
    subdir_csv_files = [f for f in os.listdir(subdir_path) if os.path.isfile(os.path.join(subdir_path, f)) and f.endswith('.csv') and f.startswith(input_name)]
    csv_files.extend([os.path.join(subdir_path, f) for f in subdir_csv_files])

# Create an empty list to store the dataframes
dfs = []

# Loop through each CSV file and read it into a dataframe, then append it to the list of dataframes
for csv_file in csv_files:
    df = pd.read_csv(csv_file)
    dfs.append(df)

# Concatenate all the dataframes into one
result = pd.concat(dfs)

# Set the output file name as the input name with ".csv" added to the end
output_name = input_name + ".csv"

# Save the concatenated dataframe to a new CSV file
result.to_csv(output_name, index=False)

print("CSV files have been concatenated and saved to", output_name)

