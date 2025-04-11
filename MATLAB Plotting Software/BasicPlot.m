function BasicPlot(average,stds,labels,dict)
    [~,~,n] = size(average);
    figure(); hold on; ax = gca; 
    colormap hsv; cmap=brighten(colormap,-0.5); [full,~]=size (cmap);%generate order of colors
    
    %set in constants/known columns to plot
    x=dict('freq_Hz');y1=dict("impedance_ohm");y2=dict("phase_deg");
    
    for variable = 1:n
        y1_label = sprintf("%s Impedance",labels(variable));
        y2_label = sprintf("%s Phase",labels(variable));
        current_color = cmap(ceil(variable/n*full),:);

        yyaxis left%lefft axis plotting
        plot(average(:,x,variable),average(:,y1,variable),'DisplayName',y1_label,'Color',current_color,'LineStyle','-');
        set(ax, 'YScale', 'linear');
        ylabel('Impedance (ohm)');

        coord_up = average(:,[x,y1],variable)+stds(:,[x,y1],variable);
        coord_low = average(:,[x,y1],variable)-stds(:,[x,y1],variable);
        coord_combine = [coord_up;flipud(coord_low)];
        patch(coord_combine(:,1),coord_combine(:,2),'k','FaceColor',current_color,'FaceAlpha',0.1,'EdgeAlpha',0,'HandleVisibility','off')

        yyaxis right%right axis plotting
        plot(average(:,x,variable),average(:,y2,variable),'DisplayName',y2_label,'Color',current_color,'LineStyle','--');
        set(ax, 'YScale', 'linear')
        ylabel('Phase (deg)');

        coord_up = average(:,[x,y2],variable)+stds(:,[x,y2],variable);
        coord_low = average(:,[x,y2],variable)-stds(:,[x,y2],variable);
        coord_combine = [coord_up;flipud(coord_low)];
        patch(coord_combine(:,1),coord_combine(:,2),'k','FaceColor',current_color,'FaceAlpha',0.1,'EdgeAlpha',0,'HandleVisibility','off')
    end
    legend()
    set(ax, 'XScale', 'log');
    xlabel('Frequency (Hz)');
end

