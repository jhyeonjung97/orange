import pandas as pd
import glob

# Define the pattern to match the files - adjust the path as necessary
file_pattern = "./*.txt"  # Adjust this to your files' location
file_list = glob.glob(file_pattern)

# List to hold dataframes
dfs = []

# Loop through the files
for file in file_list:
    # Read each file into a DataFrame
    df = pd.read_csv(file, sep=';', engine='python')  # Use sep=';' for semicolon-separated values
    dfs.append(df)

# Combine all DataFrames into a single DataFrame
combined_df = pd.concat(dfs, ignore_index=True)

# Now you can work with the combined_df DataFrame
print(combined_df.head())  # Display the first few rows
