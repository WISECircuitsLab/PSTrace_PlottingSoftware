function [averagesBefore, averagesAfter] = calculateAverages(tb, times, concentrations, experimentName, yLimits, n, offset)
    % Calculates the average current before and after each perturbation and plots the data.
    % Optionally takes yLimits, n, and offset as inputs to set the y-axis limits,
    % the number of points for averaging, and how many points to skip from the time point.

    % Set default value for n and offset if not provided
    if ~exist('n', 'var') || isempty(n)
        n = 300; % Default number of points for averaging
    end
    if ~exist('offset', 'var') || isempty(offset)
        offset = 100; % Default offset to skip data points
    end
    
    averagesBefore = [];
    averagesAfter = [];

    figure(1); clf; hold on;
    
    xlabel('time (s)');
    ylabel('current (uA)');
    title(experimentName);

    % Plot the current versus time data
    plot(tb.s, tb.x_A, 'b-', 'LineWidth', 2);

    % Loop through each perturbation time point
    for i = 2:length(times)
        conc = sprintf('%.3fmM', concentrations(i));
        
        % Plot a vertical line at each perturbation time point
        xline(times(i), 'r', {conc});
        
        % Calculate averages before the perturbation
        idx_start_before = find(tb.s < times(i), 1, 'last') - offset; % Last index before the current perturbation, with offset
        idx_end_before = max(idx_start_before - n + 1, 1); % Ensure we have n points or start from the first point
        
        % Calculate the average of the n data points before the current perturbation
        avg_current_before = mean(tb.x_A(idx_end_before:idx_start_before));
        averagesBefore(end + 1) = avg_current_before; % Store the average in the vector
        
        % Plot the data points that are being averaged in black (before)
        plot(tb.s(idx_end_before:idx_start_before), tb.x_A(idx_end_before:idx_start_before), 'k.', 'MarkerSize', 10);
        
        % Plot a horizontal line at the average current value (before)
        yline(avg_current_before, 'g--', 'LineWidth', 1.5);

        % Calculate averages after the perturbation
        idx_start_after = find(tb.s > times(i), 1, 'first') + offset; % First index after the current perturbation, with offset
        idx_end_after = min(idx_start_after + n - 1, length(tb.s)); % Ensure we have n points or stop at the last point
        
        % Calculate the average of the n data points after the current perturbation
        avg_current_after = mean(tb.x_A(idx_start_after:idx_end_after));
        averagesAfter(end + 1) = avg_current_after; % Store the average in the vector
        
        % Plot the data points that are being averaged in black (after)
        plot(tb.s(idx_start_after:idx_end_after), tb.x_A(idx_start_after:idx_end_after), 'k.', 'MarkerSize', 10);
        
        % Plot a horizontal line at the average current value (after)
        yline(avg_current_after, 'm--', 'LineWidth', 1.5);
    end

    % Handle the last segment (last concentration) - after the final time point
    idx_start = length(tb.s); % End of the trial
    idx_end = max(idx_start - n + 1, 1); % Last n data points

    % Ensure there are enough data points for averaging
    if idx_start >= idx_end
        avg_current_before = nanmean(tb.x_A(idx_end:idx_start));
        averagesBefore(end + 1) = avg_current_before; % Store the average in the vector

        % Plot the data points for the last segment
        plot(tb.s(idx_end:idx_start), tb.x_A(idx_end:idx_start), 'k.', 'MarkerSize', 10);

        % Plot a horizontal line at the last average current value
        yline(avg_current_before, 'g--', 'LineWidth', 1.5);
    else
        warning('Not enough data points to calculate the last average.');
    end

    % Set y-axis limits if provided, otherwise autoscale
    if exist('yLimits', 'var') && ~isempty(yLimits)
        ylim(yLimits);
    else
        ylim('auto');
    end
end
