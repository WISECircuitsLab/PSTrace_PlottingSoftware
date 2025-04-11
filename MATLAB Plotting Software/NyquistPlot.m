function NyquistPlot(average,stds,labels,dict)
    [~,~,n] = size(average);
    figure(); hold on; ax = gca; 
    colormap hsv; cmap=brighten(colormap,-0.5); [full,~]=size (cmap);%generate order of colors
    
    %set in constants/known columns to plot
    x=dict("Zr_Ohm");y1=dict("Zi_Ohm");
    
    for variable = 1:n
        y1_label = sprintf("%s",labels(variable));
        current_color = cmap(ceil(variable/n*full),:);

        plot(average(:,x,variable),average(:,y1,variable),'DisplayName',y1_label,'Color',current_color,'LineStyle','-');
        ylabel('Z" (ohm)');
    end
    legend()
    xlabel("Z' (ohm)");
    subtitle('Nyquist Plot')
    axis equal
end 