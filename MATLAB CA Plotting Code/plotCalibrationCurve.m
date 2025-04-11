function plotCalibrationCurve(concentrations, averages, experimentName)
    % Plots the calibration curve and performs linear regression.

    figure(2); clf; hold on;

    concentrations = concentrations(2:end);
    
    % Plot the averaged data points
    plot(concentrations, averages, 'r.', 'MarkerSize', 15);
    
    % Perform linear regression
    p = polyfit(concentrations, averages, 1);
    fit_line = polyval(p, concentrations);
    
    % Plot the linear fit
    plot(concentrations, fit_line, 'b-', 'LineWidth', 2);
    
    % Calculate R² value
    y_fit = polyval(p, concentrations);
    SS_res = sum((averages - y_fit).^2);
    SS_tot = sum((averages - mean(averages)).^2);
    R2 = 1 - (SS_res / SS_tot);
    
    % Display fitting parameters and R² on the plot
    text(concentrations(end-1), fit_line(end-5), sprintf('y = %.2fx + %.2f\nR^2 = %.2f', p(1), p(2), R2), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 12);

    xlabel('Concentration (mM)');
    ylabel('Averaged Current (uA)');
    title([experimentName ' Calibration Curve']);
end
