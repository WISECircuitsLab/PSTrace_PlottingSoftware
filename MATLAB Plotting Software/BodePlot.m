function BodePlot(average,stds,labels,dict)
    [~,~,n] = size(average);
    figure();
    colormap hsv; cmap=brighten(colormap,-0.5); [full,~]=size (cmap);%generate order of colors
    
    %set in constants/known columns to plot
    x=dict('freq_Hz');y1=dict("impedance_ohm");y2=dict("phase_deg");
    
    for variable = 1:n
        y1_label = sprintf("%s Impedance",labels(variable));
        y2_label = sprintf("%s Phase",labels(variable));
        current_color = cmap(ceil(variable/n*full),:);

        subplot(2,1,1); % top subplot impedance plotting
        hold on
        plot(average(:,x,variable),db(average(:,y1,variable)),'DisplayName',y1_label,'Color',current_color,'LineStyle','-');
        set(gca, 'YScale', 'linear');
        ylabel('Impedance (dB)');

        coord_up =  db(average(:,y1,variable)+stds(:,y1,variable));
        coord_low = db(average(:,y1,variable)-stds(:,y1,variable));
        Y_combined = [coord_up;flipud(coord_low)];
        X_combined = [average(:,x,variable); flipud(average(:,x,variable))];
        patch(X_combined,Y_combined,'k','FaceColor',current_color,'FaceAlpha',0.1,'EdgeAlpha',0,'HandleVisibility','off')

        subplot(2,1,2); % bottom subplot impedance plotting
        hold on
        plot(average(:,x,variable),average(:,y2,variable),'DisplayName',y2_label,'Color',current_color,'LineStyle','--');
        set(gca, 'YScale', 'linear')
        ylabel('Phase (deg)');

        coord_up = average(:,[x,y2],variable)+stds(:,[x,y2],variable);
        coord_low = average(:,[x,y2],variable)-stds(:,[x,y2],variable);
        coord_combine = [coord_up;flipud(coord_low)];
        patch(coord_combine(:,1),coord_combine(:,2),'k','FaceColor',current_color,'FaceAlpha',0.1,'EdgeAlpha',0,'HandleVisibility','off')
    end
    legend('Location','northeastoutside')
    set(gca, 'XScale', 'log');
    xlabel('Frequency (Hz)');
    subplot(2,1,1)
    legend();
    set(gca, 'XScale', 'log');
    subtitle('Bode Plot')
end