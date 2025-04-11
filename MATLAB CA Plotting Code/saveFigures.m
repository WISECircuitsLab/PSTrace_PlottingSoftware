function saveFigures(baseFileName, figNumbers, saveDir)
    % saveFigures saves specified figures as .fig and .png files in the
    % directory of the provided file path.
    %
    % Usage:
    %   saveFigures('FigureName', [1, 2, 3, 4], 'C:\path\to\data\file\');
    %
    % Inputs:
    %   baseFileName - Base name for the saved figure files.
    %   figNumbers   - Vector of figure numbers to save.
    %   saveDir - Path of firectory to be saved


    % Loop through the specified figure numbers
    for i = 1:length(figNumbers)
        % Get the current figure number
        figNumber = figNumbers(i);

        % Set the current figure
        figure(figNumber);

        % Generate the file name with the figure number appended
        figFileName = sprintf('%s_Fig%d', baseFileName, figNumber);

        % Full path to save the files
        fullFilePath = fullfile(saveDir, figFileName);

        % Save as .fig file
        savefig(gcf, [fullFilePath, '.fig']);

        % Save as .png file with high resolution
        print(gcf, [fullFilePath, '.png'], '-dpng', '-r300');
    end
end
