function allEISPlot(average, stds, labels, dict)
    %% Set up plot
    [~,~,n] = size(average);
    figure(); 

    % Define the desired aspect ratio
    desired_ratio = 15/9;
    
    % Set the width and height of the figure
    width = 1200;  % Adjust as needed
    height = width / desired_ratio;
    
    % Set the figure's Position property
    set(gcf, 'Position', [100, 100, width, height]);
    
    % Create a tiled layout
    t = tiledlayout(2, 2, 'TileSpacing', 'compact'); 
    colormap turbo;
    cmap = brighten(colormap, -0.5);
    [full,~] = size(cmap); % generate order of colors

    % Get all variables to plot
    x = dict('freq_Hz');
    impedance_ohm = dict("impedance_ohm");
    phase = dict("phase_deg");
    Zr = dict("Zr_Ohm");
    Zim = dict("Zi_Ohm");

    % Set Nyquist Plot Zoomed in Barrier
        % Prompt user for barrier_x range
        prompt_x = {'Enter barrier_x lower limit (press Cancel for default):', 'Enter barrier_x upper limit (press Cancel for default):'};
        dlgtitle_x = 'Enter Barrier_x Range';
        dims = [1 35];
        definput_x = {'0', '2500'};
        answer_x = inputdlg(prompt_x, dlgtitle_x, dims, definput_x);
        
        % Convert input to numeric values
        if ~isempty(answer_x)
            barrier_x = str2double(answer_x);
        else
            barrier_x = [1 2500];  % Default values
        end
        
        % Prompt user for barrier_y range
        prompt_y = {'Enter barrier_y lower limit (press Cancel for default):', 'Enter barrier_y upper limit (press Cancel for default):'};
        dlgtitle_y = 'Enter Barrier_y Range';
        definput_y = {'0', '1000'};
        answer_y = inputdlg(prompt_y, dlgtitle_y, dims, definput_y);

    % Convert input to numeric values
    if ~isempty(answer_y)
        barrier_y = str2double(answer_y);
    else
        barrier_y = [0 1000];  % Default values
    end
    
    % Initialize handles for legend
    handles = [];

    % Line properties
    lineStyle = '-';
    phase_lineStyle = ':';
    markerStyle = '+';
    fontSize = 12;
    fontWeight = 'bold';
    lineThickness = 2;

    % BasicPlot spanning the top two boxes
    nexttile([1 2]);
    ax1 = gca; % Get current axes
    for variable = 1:n
        imp_label = sprintf("%s", labels(variable));
        phase_label = sprintf("%s", labels(variable));
        current_color = cmap(ceil(variable / n * full), :);

        % Left axis plotting
        yyaxis left
        h1 = plot(ax1, average(:,x,variable), average(:,impedance_ohm,variable), ...
                  'DisplayName', imp_label, 'Color', current_color, ...
                  'LineStyle', lineStyle, 'LineWidth', lineThickness, ...
                  'Marker', markerStyle);
        hold on;
        set(ax1, 'YScale', 'linear');
        ylabel(ax1, 'Impedance (ohm)');
        set(gca, 'FontSize', fontSize, 'FontWeight', fontWeight);

        coord_up = average(:,[x,impedance_ohm],variable) + stds(:,[x,impedance_ohm],variable);
        coord_low = average(:,[x,impedance_ohm],variable) - stds(:,[x,impedance_ohm],variable);
        coord_combine = [coord_up; flipud(coord_low)];
        patch(coord_combine(:,1), coord_combine(:,2), 'k', 'FaceColor', current_color, ...
              'FaceAlpha', 0.1, 'EdgeAlpha', 0, 'HandleVisibility', 'off');

        % Right axis plotting
        yyaxis right
        h2 = plot(ax1, average(:,x,variable), average(:,phase,variable), ...
                  'Color', current_color, 'LineStyle', phase_lineStyle, ...
                  'LineWidth', lineThickness);
        set(ax1, 'YScale', 'linear');
        ylabel(ax1, 'Negative Phase (deg)');
        set(gca, 'FontSize', fontSize, 'FontWeight', fontWeight);

        coord_up = average(:,[x,phase],variable) + stds(:,[x,phase],variable);
        coord_low = average(:,[x,phase],variable) - stds(:,[x,phase],variable);
        coord_combine = [coord_up; flipud(coord_low)];
        patch(coord_combine(:,1), coord_combine(:,2), 'k', 'FaceColor', current_color, ...
              'FaceAlpha', 0.1, 'EdgeAlpha', 0, 'HandleVisibility', 'off');
    end
    yyaxis left
    set(ax1, 'YScale', 'log');
    set(ax1, 'XScale', 'log');
    subtitle('Frequency & Phase Plot')
    xlabel(ax1, 'Frequency (Hz)');

    % NyquistPlot in the bottom left box
    nexttile(3);
    ax2 = gca; % Get current axes
    hold on;
    for variable = 1:n
        nyq_label = sprintf("%s", labels(variable));
        current_color = cmap(ceil(variable / n * full), :);
        h3 = plot(ax2, average(:,Zr,variable), average(:,Zim,variable), ...
                  'DisplayName', nyq_label, 'Color', current_color, ...
                  'LineStyle', lineStyle, 'LineWidth', lineThickness, ...
                  'Marker', markerStyle);
    end
    xlabel(ax2, "Z' (ohm)");
    ylabel(ax2, '-Z" (ohm)');
    subtitle(ax2, 'Nyquist Plot');
    set(gca, 'FontSize', fontSize, 'FontWeight', fontWeight);

    % Zoomed in NyquistPlot in the bottom right box
    nexttile(4);
    ax3 = gca; % Get current axes
    hold on;
    for variable = 1:n
        nyq_label = sprintf("%s", labels(variable));
        current_color = cmap(ceil(variable / n * full), :);
        h4 = plot(ax3, average(:,Zr,variable), average(:,Zim,variable), ...
                  'DisplayName', nyq_label, 'Color', current_color, ...
                  'LineStyle', lineStyle, 'LineWidth', lineThickness, ...
                  'Marker', markerStyle);
                % Store handles for legend
        handles = [handles, h4];
    end
    xlabel(ax3, "Z' (ohm)");
    %ylabel(ax3, 'Z" (ohm)');
    subtitle(ax3, 'Zoomed-In');
    xlim(ax3, barrier_x);
    ylim(ax3, barrier_y);
    set(gca, 'FontSize', fontSize, 'FontWeight', fontWeight);

    % Add the legend for tiles 1, 2, and 3
    lgd = legend(handles);
    lgd.Layout.Tile = 'north'; % Position legend at the top of the tiled layout

end
