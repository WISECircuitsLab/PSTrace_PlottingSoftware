function [integratedCurrent, normalizedCurrent, differentiatedCurrent] = processAndPlotData(timeData, currentData, times, concentrations, experimentName, additionName, varargin)
    % Function to integrate the current over time, normalize it, and compute the difference.
    % The function will also plot the original, integrated, normalized, and differentiated data.
    %
    % Inputs:
    %   - timeData: Vector of time points
    %   - currentData: Vector of current measurements corresponding to timeData
    %   - times: Vector of perturbation times
    %   - concentrations: Vector of concentrations corresponding to the perturbation times
    %   - experimentName: String containing the name of the experiment
    %   - varargin: Optional parameter for ylim vector
    %
    % Outputs:
    %   - integratedCurrent: Vector of integrated current over each time segment
    %   - normalizedCurrent: Vector of normalized integrated current
    %   - differentiatedCurrent: Vector of differences in the normalized current

    % Initialize vectors
    integratedCurrent = zeros(length(concentrations), 1);
    normalizedCurrent = zeros(length(concentrations), 1);
    differentiatedCurrent = zeros(length(concentrations)-1, 1);

    % Optional ylim vector
    if ~isempty(varargin)
        ylimVector = varargin{1};
    else
        ylimVector = [];
    end

    % Plot the current versus time data with highlighted integration areas
    figure(3); clf; hold on;

    % Set the figure size and aspect ratio
    aspectRatio = 5/2;
    width = 800;  % Width in pixels
    height = width / aspectRatio; % Height in pixels
    set(gcf, 'Position', [100, 100, width, height]);
    
    plot(timeData, currentData, 'b-', 'LineWidth', 2);
    xlabel('Time (s)');
    ylabel('Current (uA)');
    title(sprintf('%s - Current vs. Time with Integration Areas', experimentName));
    
    % Loop through each segment defined by times
    for i = 2:length(times)
        % Find indices corresponding to the current time segment
        idx_start = find(timeData >= times(i-1), 1, 'first');
        idx_end = find(timeData < times(i), 1, 'last');
        
        % Highlight the area being integrated
        area(timeData(idx_start:idx_end), currentData(idx_start:idx_end), 'FaceAlpha', 0.2, 'EdgeColor', 'none');
        
        % Integrate current over the time interval (using the trapezoidal method)
        integratedCurrent(i-1) = trapz(timeData(idx_start:idx_end), currentData(idx_start:idx_end));
        
        % Plot vertical line to indicate concentration
        conc_label = sprintf('%.4fmM', concentrations(i-1));
        x1 = xline(times(i), 'r--', {conc_label}, 'LineWidth', 1.5);
        x1.LabelHorizontalAlignment = 'left';
        x1.LabelOrientation = 'horizontal';


        x2 = xline(times(i), 'r--', {additionName}, 'LineWidth', 1.5);
        x2.LabelHorizontalAlignment = 'right';
        x2.LabelVerticalAlignment = 'bottom';
    end
    
    % Handle the last segment after the final time point
    idx_start = find(timeData >= times(end), 1, 'first');
    idx_end = length(timeData);
    
    % Highlight the area being integrated for the last segment
    area(timeData(idx_start:idx_end), currentData(idx_start:idx_end), 'FaceAlpha', 0.2, 'EdgeColor', 'none');
    
    % Integrate the current over the last time segment
    integratedCurrent(end) = trapz(timeData(idx_start:idx_end), currentData(idx_start:idx_end));
    
    % Add a vertical line for the last concentration
    conc_label = sprintf('%.3fmM', concentrations(end));
    x1 = xline(times(end), 'r--', {conc_label}, 'LineWidth', 1.5);
    x1.LabelHorizontalAlignment = 'right';
    x1.LabelOrientation = 'horizontal';    

    % Normalize the integrated current by subtracting the first value
    normalizedCurrent = integratedCurrent - integratedCurrent(1);
    
    % Compute the difference across the normalized current
    differentiatedCurrent = diff(normalizedCurrent);

    % Apply optional ylim if provided
    if ~isempty(ylimVector)
        ylim(ylimVector);
    end
    
    % Plotting the integrated, normalized, and differentiated data
    figure(4); clf;

    % Set the figure size and aspect ratio
    aspectRatio = 2/5;
    width = 300;  % Width in pixels
    height = width / aspectRatio; % Height in pixels
    set(gcf, 'Position', [100, 100, width, height]);

    subplot(3,1,1); % First subplot for integrated current
    plot(concentrations, integratedCurrent, 'b-o');
    title('Integrated Current over Time -- Total Charge');
    ylabel('uC');
    grid on;
    
    subplot(3,1,2); % Second subplot for normalized current
    plot(concentrations, normalizedCurrent, 'r-o');
    title('Normalized to Zero Concentration');
    ylabel('Normalized (uC)');
    grid on;
    
    subplot(3,1,3); % Third subplot for differentiated current
    plot(concentrations(2:end), differentiatedCurrent, 'g-o');
    title('Relative Charge Increase');
    ylabel('Relative Charge (uC)');
    xlabel('Concentration (uM)');
    grid on;
   
end
