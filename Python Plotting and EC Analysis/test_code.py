import chardet  # for determining chartectar encoding for csv files
import pandas as pd
import numpy as np

import Potentiostat_Plotting
from Potentiostat_Plotting import plotting_functions as plotter
from Potentiostat_Plotting import io_functions as io

filepath = "/Users/yashpatel/Desktop/DAMP/Experimental Data Folders/Coated Electrode"
[data, IV_names, folder_name,
    directory_path] = io.scrape_data_from_files(filepath)

# Example usage:
# Create a sample 2D list of DataFrames
data_MOCK = [
    [pd.DataFrame(np.random.rand(21, 13)) for _ in range(3)],
    [pd.DataFrame(np.random.rand(21, 13)) for _ in range(3)]
]
average, st_dev = plotter.scrub_potentiostat_EIS(data)
print(f"Returned average shape: {average.shape}", "object type", type(average))
print(f"Returned st_dev shape: {st_dev.shape}")

Potentiostat_EIS_Data_Organization = ["freq_Hz", "Time_S", "Log_f_Hz_", "phase_deg", "Idc_UA",
                                      "Iac_UA", "impedance_ohm", "Zr_Ohm", "Zi_Ohm", "Log_Z_Ohm_", "Cs_F", "Edc_V", "Eac_V"]
Potentiostat_CV_Data_Organization = ["Voltage_V", "Current_µA"]

organization_dict = dict(zip(Potentiostat_EIS_Data_Organization, range(
    len(Potentiostat_EIS_Data_Organization))))


plotter.allEISPlot(average, st_dev, IV_names, organization_dict)
