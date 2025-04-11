function DPVPlot(average,stds,labels,dict)
    [~,~,n] = size(average);
    figure(); hold on; ax = gca; 
    colormap jet; cmap=brighten(colormap,-0.9); [full,~]=size (cmap);%generate order of colors
    
    %set in constants/known columns to plot
    x=dict("Voltage_V");y1=dict("Current_µA");
    
    for variable = 1:n
        y1_label = sprintf("%s",labels(variable));
        current_color = cmap(ceil(variable/n*full),:);
        %stds = squeeze(stds);

        plot(average(1,:,variable),average(2,:,variable),'DisplayName',y1_label,'Color',current_color,'LineStyle','-','LineWidth',2);
        ylabel('Current (µA)');

        %coord_up = average(x,:,variable)+stds(1,:,variable);
        %coord_low = average(x,:,variable)-stds(1,:,variable);
        %coord_combine = [coord_up;flipud(coord_low)];
        %patch(coord_combine(:,1),coord_combine(:,2),'k','FaceColor',current_color,'FaceAlpha',0.1,'EdgeAlpha',0,'HandleVisibility','off')

    end
    legend()
    xlabel('Voltage (V)');
    subtitle('CV-Curve Plot')
end