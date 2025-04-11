import os
import pandas as pd
import numpy as np
from tkinter import filedialog
from tkinter import Tk


def scrape_data_from_files(directory_path=None):
    # specify the number of header rows to skip
    header_rows = 5
    if directory_path is None:
        root = Tk()
        root.withdraw()  # Hide the main window.
        # Show the directory selection dialog.
        directory_path = filedialog.askdirectory()

    # Get the folder name
    folder_name = os.path.basename(directory_path)
    print(folder_name)

    # Get the list of subfolders
    subfolders = [f.path for f in os.scandir(directory_path) if f.is_dir()]

    # Initialize a 2D list to store the paths to the CSV files
    csvfiles = []

    # Loop over the subfolders
    for subfolder in subfolders:
        # Get the list of CSV files in the current subfolder
        current_csvfiles = [os.path.join(subfolder, file) for file in os.listdir(
            subfolder) if file.endswith('.csv')]
        # Append the list of CSV files to the 2D list
        csvfiles.append(current_csvfiles)

    # Initialize complete_data as a list of empty lists
    complete_data = [[None]*len(csvfiles[0]) for _ in range(len(csvfiles))]

    # Convert complete_data to a NumPy array with dtype=object to avoid the VisibleDeprecationWarning
    complete_data = np.array(complete_data, dtype=object)

    # Initialize IV_names as an empty list
    IV_names = []


# Loop over subfolders (outer loop)
    for i in range(len(subfolders)):
        # Loop over csvfiles in each subfolder (inner loop)
        for j in range(len(csvfiles[i])):
            # Get the current csv_file
            csv_file = csvfiles[i][j]

            # Get the folder and IV from the csv_file
            folder = os.path.dirname(csv_file)
            IV = os.path.basename(folder)

            # Read the CSV file and remove rows with NaN values
            current_data = pd.read_csv(
                csv_file, skiprows=header_rows, encoding='UTF-16')

            # Append IV to IV_names
            IV_names.append(IV)

            # Add current_data to complete_data
            complete_data[i][j] = current_data

            # Give input to user about what files are being imported
            print('Importing', csv_file, 'to', complete_data[i][j].shape)

    # Convert complete_data to a NumPy array with dtype=object to avoid the VisibleDeprecationWarning
    complete_data = np.array(complete_data, dtype=object)

    # Remove duplicates from IV_names
    IV_names = list(set(IV_names))

    return complete_data, IV_names, folder_name, directory_path
