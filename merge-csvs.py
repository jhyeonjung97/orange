import os
import pandas as pd

# Set the parent directory path where the CSV files are located to the current working directory
parent_dir = './'

# Get a list of all the subdirectories in the parent directory
subdirs = [d for d in os.listdir(parent_dir) if os.path.isdir(os.path.join(parent_dir, d))]

# Create an empty list to store the concatenated data
data = []

# Loop through each subdirectory and concatenate the CSV files
for subdir in subdirs:
    subdir_path = os.path.join(parent_dir, subdir)
    subdir_csv_files = [f for f in os.listdir(subdir_path) if os.path.isfile(os.path.join(subdir_path, f)) and f.endswith('.csv')]
    print(f"Concatenating CSV files in subdirectory {subdir}...")
    df_csv_concat = pd.concat([pd.read_csv(os.path.join(subdir_path, file)) for file in subdir_csv_files ], ignore_index=True)
    data.append(df_csv_concat)

# Concatenate all the data into a single DataFrame
df_all_data = pd.concat(data, ignore_index=True)

# Save the concatenated data to a single CSV file
output_name = "merged.csv"
print(f"Saving merged data to {output_name}...")
df_all_data.to_csv(output_name, index=False)

# Display the concatenated data for all subdirectories
print("Merged data:")
print(df_all_data)
