function CVPlot(average, stds, labels, dict, annotate)
    [~,~,n] = size(average);
    figure(); hold on; ax = gca; 
    colormap turbo; cmap=brighten(colormap,-0.9); [full,~]=size(cmap); %generate order of colors

    % Define the desired aspect ratio
    desired_ratio = 15/9;
    
    % Set the width and height of the figure
    width = 1200;  % Adjust as needed
    height = width / desired_ratio;
    
    % Set the figure's Position property
    set(gcf, 'Position', [100, 100, width, height]);
    
    %set in constants/known columns to plot
    x=dict("Voltage_V"); y1=dict("Current_µA");
    
    for variable = 1:n
        y1_label = sprintf("%s", labels(variable));
        current_color = cmap(ceil(variable/n*full), :);

        % Plot the data
        plot(average(x,:,variable), average(y1,:,variable), 'DisplayName', y1_label, 'Color', current_color, 'LineStyle', '-', 'LineWidth', 2);
        ylabel('Current (µA)');

        % If annotate is true, find and annotate the peak value
        if annotate
            annotatePeak(average(x,:,variable), average(y1,:,variable), current_color, variable);
        end
    end

    legend()
    xlabel('Voltage (V)');
    %subtitle('CV-Curve Plot')
end