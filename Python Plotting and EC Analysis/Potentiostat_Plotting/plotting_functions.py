import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import LogLocator
from matplotlib.gridspec import GridSpec
import easygui as eg

from math import radians, cos, sin, asin, sqrt


def scrub_potentiostat_EIS(data):
    # Get the shape of the data array
    n, d = len(data), len(data[0]) if data is not None else 0
    print(f"Data shape: ({n}, {d})")

    average_list = []
    st_dev_list = []

    for i in range(n):
        IV_data = []
        count = 0
        for j in range(d):
            df = data[i][j]
            if not df.empty:
                # Extract frequency values from the first column
                freq_values = pd.to_numeric(
                    df.iloc[:, 0], errors='coerce').to_numpy()

                # Drop the specified columns
                # Remove logF & current range columns
                data_dropped = df.drop(columns=[df.columns[0], df.columns[11]])

                # Convert remaining data to numpy array
                data_array = data_dropped.apply(
                    pd.to_numeric, errors='coerce').to_numpy()

                # Combine frequency values with the remaining data
                full_data_matrix_one = np.column_stack(
                    (freq_values, data_array))

                if count == 0:
                    IV_data = full_data_matrix_one
                else:
                    IV_data = np.dstack((IV_data, full_data_matrix_one))
                count += 1

        if count > 0:
            average_list.append(np.nanmean(IV_data, axis=2))
            st_dev_list.append(np.nanstd(IV_data, axis=2))

    if average_list:
        average = np.dstack(average_list)
        st_dev = np.dstack(st_dev_list)
    else:
        average = np.array([])
        st_dev = np.array([])

    return average, st_dev


def allEISPlot(average, stds, labels, dict_params):
    # Get all variables to plot
    x = dict_params['freq_Hz']
    impedance_ohm = dict_params["impedance_ohm"]
    phase = dict_params["phase_deg"]
    Zr = dict_params["Zr_Ohm"]
    Zim = dict_params["Zi_Ohm"]

    # Set Nyquist Plot Zoomed in Barrier
    # Prompt user for barrier_x range
    prompt_x = ['Enter barrier_x lower limit (press Cancel for default):',
                'Enter barrier_x upper limit (press Cancel for default):']
    dlgtitle_x = 'Enter Barrier_x Range'
    definput_x = ['0', '2500']
    answer_x = eg.multenterbox(prompt_x, dlgtitle_x, definput_x)

    # Convert input to numeric values or use default
    if answer_x is None or any(val == '' for val in answer_x):
        barrier_x = [0, 2500]  # Default values
    else:
        barrier_x = [float(answer_x[0]), float(answer_x[1])]

    # Prompt user for barrier_y range
    prompt_y = ['Enter barrier_y lower limit (press Cancel for default):',
                'Enter barrier_y upper limit (press Cancel for default):']
    dlgtitle_y = 'Enter Barrier_y Range'
    definput_y = ['0', '1000']
    answer_y = eg.multenterbox(prompt_y, dlgtitle_y, definput_y)

    # Convert input to numeric values or use default
    if answer_y is None or any(val == '' for val in answer_y):
        barrier_y = [0, 1000]  # Default values
    else:
        barrier_y = [float(answer_y[0]), float(answer_y[1])]

    # Set up plot
    _, _, n = average.shape

    # Define the desired aspect ratio
    desired_ratio = 15 / 9

    # Set the width and height of the figure
    width = 1750  # Adjust as needed
    height = width / desired_ratio

    # Create figure and set size
    fig = plt.figure(figsize=(width / 100, height / 100))
    # Increased hspace for larger spacing
    gs = GridSpec(2, 2, figure=fig, height_ratios=[1, 1], hspace=0.4)

    cmap = plt.get_cmap("turbo")
    cmap_colors = [cmap(i) for i in np.linspace(0, 1, n)]

    handles_vals = []

    # Line properties
    lineStyle = '-'
    phase_lineStyle = ':'
    markerStyle = '+'
    fontSize = 16  # Increased font size
    fontWeight = 'bold'
    lineThickness = 2

    # BasicPlot spanning the top two boxes
    ax1 = fig.add_subplot(gs[0, :])
    ax1.set_title('Frequency & Phase Plot',
                  fontsize=fontSize, fontweight=fontWeight)
    ax1.grid(True)  # Enable grid

    ax2 = ax1.twinx()  # Create a second y-axis for the phase plot

    for variable in range(n):
        imp_label = labels[variable]
        current_color = cmap_colors[variable]

        # Left axis plotting
        ax1.plot(average[:, x, variable], average[:, impedance_ohm, variable],
                 label=imp_label, color=current_color, linestyle=lineStyle,
                 linewidth=lineThickness, marker=markerStyle)
        ax1.fill_between(average[:, x, variable],
                         average[:, impedance_ohm, variable] -
                         stds[:, impedance_ohm, variable],
                         average[:, impedance_ohm, variable] +
                         stds[:, impedance_ohm, variable],
                         color=current_color, alpha=0.1)

        # Right axis plotting
        ax2.plot(average[:, x, variable], average[:, phase, variable],
                 color=current_color, linestyle=phase_lineStyle,
                 linewidth=lineThickness)
        ax2.fill_between(average[:, x, variable],
                         average[:, phase, variable] -
                         stds[:, phase, variable],
                         average[:, phase, variable] +
                         stds[:, phase, variable],
                         color=current_color, alpha=0.1)

    ax1.set_xscale('log')
    ax1.set_xlabel('Frequency (Hz)', fontsize=fontSize, fontweight=fontWeight)
    ax1.set_ylabel('|Z| (ohm)', fontsize=fontSize, fontweight=fontWeight)
    ax1.tick_params(axis='both', labelsize=fontSize)

    ax2.set_ylabel(r'$-\phi$ (deg)', fontsize=fontSize, fontweight=fontWeight)
    ax2.tick_params(axis='y', labelsize=fontSize)

    # NyquistPlot in the bottom left box
    ax3 = fig.add_subplot(gs[1, 0])
    ax3.set_title('Nyquist Plot', fontsize=fontSize, fontweight=fontWeight)
    ax3.axis('equal')
    ax3.grid(True)  # Enable grid
    ax3.set_xlabel("Z' (ohm)", fontsize=fontSize, fontweight=fontWeight)
    ax3.set_ylabel('-Z" (ohm)', fontsize=fontSize, fontweight=fontWeight)
    ax3.tick_params(axis='both', labelsize=fontSize)

    # Zoomed in NyquistPlot in the bottom right box
    ax4 = fig.add_subplot(gs[1, 1])
    ax4.set_title('Zoomed-In Nyquist Plot',
                  fontsize=fontSize, fontweight=fontWeight)
    ax4.set_xlim(barrier_x)
    ax4.set_ylim(barrier_y)
    ax4.grid(True)  # Enable grid
    ax4.set_xlabel("Z' (ohm)", fontsize=fontSize, fontweight=fontWeight)
    ax4.tick_params(axis='both', labelsize=fontSize)

    for variable in range(n):
        nyq_label = labels[variable]
        current_color = cmap_colors[variable]

        # Nyquist Plot
        ax3.plot(average[:, Zr, variable], average[:, Zim, variable],
                 label=nyq_label, color=current_color, linestyle=lineStyle,
                 linewidth=lineThickness, marker=markerStyle)

        # Zoomed Nyquist Plot
        h4, = ax4.plot(average[:, Zr, variable], average[:, Zim, variable],
                       label=nyq_label, color=current_color, linestyle=lineStyle,
                       linewidth=lineThickness, marker=markerStyle)
        handles_vals.append(h4)

    # Add the legend for tiles 1, 2, and 3
    fig.legend(handles=handles_vals, loc='lower center',
               ncol=n, fontsize=fontSize, frameon=False)  # , bbox_to_anchor=(0.5, -0.1))

    plt.tight_layout()  # Adjust layout to prevent overlapping


def FormatPlot(folder_file_path, answer_insert=None):
    prompt = ["Enter desired plot title", "Enter file to save plot as"]
    dlgtitle = 'Formatting & Saving Plot'
    dims = [1, 35]
    definput = ['none', 'none']

    if answer_insert:
        answer = answer_insert
    else:
        answer = inputdlg(prompt, dlgtitle, dims, definput)

    # Display the super title
    if answer[0] != "none":
        plt.suptitle(answer[0], fontsize=16, fontweight='bold')

    # Customize axes properties
    for ax in plt.gcf().get_axes():
        ax.tick_params(axis='both', which='major',
                       labelsize=12, width=1, direction='inout')
        ax.tick_params(axis='both', which='minor',
                       width=0.5, direction='inout')
        ax.spines['top'].set_linewidth(1)
        ax.spines['right'].set_linewidth(1)
        ax.spines['bottom'].set_linewidth(1)
        ax.spines['left'].set_linewidth(1)
        ax.xaxis.set_tick_params(labelsize=12)
        ax.yaxis.set_tick_params(labelsize=12)
        ax.grid(True, which='major', linestyle='-', linewidth=1, alpha=0.5)
        ax.grid(True, which='minor', linestyle='-', linewidth=0.5, alpha=0.1)

    # Enable grid on all axes
    plt.minorticks_on()

    # Place legend outside the plot area
    plt.legend(loc='upper right', bbox_to_anchor=(1.25, 1))

    # Save the figure if requested
    if answer[1] != "none":
        filename = os.path.join(folder_file_path, answer[1])
        plt.savefig(filename)
        filename_fig = filename.replace('.png', '.svg')
        plt.savefig(filename_fig)

    # plt.show()
