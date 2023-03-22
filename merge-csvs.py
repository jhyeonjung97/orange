import os
import pandas as pd

# Get the input file name (excluding file extension) from the user
input_name = input("Enter the name of the input CSV file (excluding file extension): ")

# Set the parent directory path where the CSV files are located
parent_dir = './'

# Get a list of all the subdirectories in the parent directory
subdirs = [d for d in os.listdir(parent_dir) if os.path.isdir(os.path.join(parent_dir, d))]

# Create an empty list to store the dataframes
dfs = []

# Loop through each subdirectory and read in the CSV file as a dataframe, then append it to the list of dataframes
for subdir in subdirs:
    file_path = os.path.join(parent_dir, subdir, input_name + ".csv")
    df = pd.read_csv(file_path)
    dfs.append(df)

# Concatenate all the dataframes into one
result = pd.concat(dfs)

# Get the output file name (including file extension) from the user
output_name = input_name + ".csv"

# Save the concatenated dataframe to a new CSV file
result.to_csv(output_name, index=False)

print("CSV files have been concatenated and saved to", output_name)
