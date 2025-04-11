% Using automated using functions rather than manual analysis
% Main Script
% clear; clf; 
%% Import the data
filepath = '/Users/yashpatel/Desktop/Exports:Downloads';
filename = 'ChronoAmp,GOxCalibration,Run3.csv';
tb = importData(filepath, filename);

%% ----------------------------------------------------------------------------------
% Set trial information
%times = [0 1385 2317 2917 4076 5281]; % in seconds
% concentrations = [0.00 0.89 2.26 4.04 5.88 7.41]; % in mM

times = [0 270 663 1050 1500 1973 2656];
concentrations = [0 1.363636364 2.5 3.461538462 5.506329114 9.402985075 12.88135593];
experimentName = '240819 Chip GOx Glu ChronoamperometryExperiment';
additionName = '+ Glucose';

% Define your ylim vector if needed
ylimVector = [0.5 3];
n=300;

% ----------------------------------------------------------------------------------
%%
tb = chronoH2O2Fix;
tb = chronoGLUCFix;
%tb.x_A = tb.x_A - 1.2795;
%%

% Initial plot and calculate averages
[averagesBefore, averagesAfter] = calculateAverages(tb, times, concentrations, experimentName, ylimVector,n);
averagesBefore = averagesBefore(1:end-1);

averages = averagesBefore - averagesAfter;
concentrations = concentrations (2:end)
% Plot the calibration curve
plotCalibrationCurve(concentrations, averages, experimentName);

% Call the function with the ylim vector
[integratedCurrent, normalizedCurrent, differentiatedCurrent] = processAndPlotData(tb.s, tb.x_A, times, concentrations, experimentName, additionName, ylimVector);

% Save the figures into same directory as data file
saveFigures(experimentName, [1, 2, 3, 4], filepath);


