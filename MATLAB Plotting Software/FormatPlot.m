function FormatPlot(folder_file_path, answer_insert)
    prompt = ["Enter desired plot title", "Enter file to save plot as"];
    dlgtitle = 'Formatting & Saving Plot';
    dims = [1 35];
    definput = {'none', 'none'};
    
    if nargin == 2
        answer = answer_insert;
    else
        answer = inputdlg(prompt, dlgtitle, dims, definput);
    end
    
    % Customize axes properties
    set(findobj(gcf,'type','axes'), ...
        'FontName', 'Calibri', ...
        'FontSize', 12, ...
        'FontWeight', 'Bold', ...
        'LineWidth', 1, ...
        'Layer', 'top', ...
        'MinorGridAlpha', 0.1, ...
        'MinorGridColor', [0.4 0.4 0.4], ...
        'MinorGridLineStyle', '-', ...
        'XMinorGrid', 'off', ...
        'XMinorTick', 'on');
    
    % Enable grid on all axes
    arrayfun(@(x) grid(x,'on'), findobj(gcf,'Type','axes'));

    % Place legend outside the plot area
    legend('Location', 'northeastoutside');
    
    % Display the super title
    if answer{1} ~= "none"
        sgtitle(answer{1}, 'FontSize', 16, 'FontWeight', 'bold');
    end
    
    % Save the figure if requested
    if answer{2} ~= "none"
        filename = fullfile(folder_file_path, answer{2});
        saveas(gcf, filename);
        filename_fig = strrep(filename, '.png', '.fig');
        saveas(gcf, filename_fig);
    end
end