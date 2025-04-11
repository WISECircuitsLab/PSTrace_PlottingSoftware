function NyquistPlot_Shaded(average,stds,labels,dict)
    [~,~,n] = size(average);
    figure(); hold on; ax = gca; 
    colormap turbo; cmap=brighten(colormap,-0.5); [full,~]=size (cmap);%generate order of colors

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
    
    
    %set in constants/known columns to plot
    x=dict("Zr_Ohm");y1=dict("Zi_Ohm");
    
    for variable = 1:n
        y1_label = sprintf("%s",labels(variable));
        current_color = cmap(ceil(variable/n*full),:);

        plot(average(1:end-6,x,variable),average(1:end-6,y1,variable),'DisplayName',y1_label,'Color',current_color,'LineStyle','-');
        ylabel("Z'' (ohm)");

        coord_up = average(:,[x,y1],variable)+stds(:,[x,y1],variable);
        coord_low = average(:,[x,y1],variable)-stds(:,[x,y1],variable);
        coord_combine = [coord_up;flipud(coord_low)];
        patch(coord_combine(:,1),coord_combine(:,2),'k','FaceColor',current_color,'FaceAlpha',0.1,'EdgeAlpha',0,'HandleVisibility','off')
    end
    legend()
    xlabel("Z' (ohm)");
    subtitle('Nyquist Plot')
    axis equal

    subtitle('Zoomed-In');
    xlim(barrier_x);
    ylim(barrier_y);
    grid on;
end