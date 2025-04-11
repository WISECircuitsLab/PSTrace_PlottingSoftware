import Potentiostat_Plotting
from Potentiostat_Plotting import plotting_functions as WISE


import Potentiostat_Plotting
from Potentiostat_Plotting import plotting_functions as plotter
from Potentiostat_Plotting import io_functions as io

import easygui
import numpy as np

# Definitions & constants
Potentiostat_EIS_Data_Organization = ["freq_Hz", "Time_S", "Log_f_Hz_", "phase_deg", "Idc_UA",
                                      "Iac_UA", "impedance_ohm", "Zr_Ohm", "Zi_Ohm", "Log_Z_Ohm_", "Cs_F", "Edc_V", "Eac_V"]
Potentiostat_CV_Data_Organization = ["Voltage_V", "Current_µA"]

LCR_Meter_Data_Organization = []

data_type = easygui.buttonbox('Select Type of Data', 'Input Choice', [
                              'LCR-Meter', 'Potentiostat', 'Nothing'])
experiment_type = easygui.buttonbox(
    'Select Type of Experiment', 'Input Choice', ['Voltametry', 'EIS', 'Nothing'])

if experiment_type == "Voltametry":
    voltametry_type = easygui.buttonbox(
        'Select Type of Experiment', 'Input Choice', ['CV', 'DPV', 'Nothing'])
    if voltametry_type == "CV":
        plot_type = 'CV'
    elif voltametry_type == 'DPV':
        plot_type = 'DPV'
elif experiment_type == "EIS":
    plot_type = 'All'

# The scrape_data_from_files function needs to be defined
filepath = "/Users/yashpatel/Desktop/DAMP/Experimental Data Folders/Coated Electrode"
data, names, root_folder_name, root_folder = io.scrape_data_from_files(
    filepath)

plt_title_save = easygui.enterbox(
    'Enter desired plot title', 'Formatting & Saving Plot')

print(f'Plotting a {plot_type} for {data_type} data of {root_folder_name}')
n, d = np.shape(data)

# The scrub_potentiostat_CV, scrub_potentiostat_DPV, and scrub_potentiostat_EIS functions need to be defined
if data_type == "Potentiostat" and plot_type == "CV":
    average, stds = plotter.scrub_potentiostat_CV(data)
    organization_dict = dict(zip(Potentiostat_CV_Data_Organization[:2], range(
        len(Potentiostat_CV_Data_Organization[:2]))))
elif data_type == "Potentiostat" and plot_type == "DPV":
    average, stds = plotter.scrub_potentiostat_DPV(data)
    organization_dict = dict(zip(Potentiostat_CV_Data_Organization[:2], range(
        len(Potentiostat_CV_Data_Organization[:2]))))
elif data_type == "Potentiostat" and plot_type != "CV":
    average, stds = plotter.scrub_potentiostat_EIS(data)
    organization_dict = dict(zip(Potentiostat_EIS_Data_Organization, range(
        len(Potentiostat_EIS_Data_Organization))))

# The NyquistPlot, FormatPlot, NyquistPlot_Shaded, BodePlot, BasicPlot, CVPlot, DPVPlot, and allEISPlot functions need to be defined
if plot_type == 'CV':
    plotter.CVPlot(average, stds, names, organization_dict)
    plotter.FormatPlot(root_folder, [plt_title_save,
                                     f"{plt_title_save} CV Plot.png"])
elif plot_type == 'DPV':
    plotter.DPVPlot(average, stds, names, organization_dict)
    plotter.FormatPlot(root_folder, [plt_title_save,
                                     f"{plt_title_save} CV Plot.png"])
elif plot_type == 'All':
    plotter.allEISPlot(average, stds, names, organization_dict)
    plotter.FormatPlot(root_folder, [plt_title_save,
                                     f"{plt_title_save} Combined Plot.png"])
