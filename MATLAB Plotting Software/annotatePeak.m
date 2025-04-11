function annotatePeak(xData, yData, color, variableIndex)
    % Define the range within which to search for peaks
    rangeMin = min(xData) + 0.1;
    rangeMax = max(xData) - 0.1;

    % Compute the derivative of yData
    dy = diff(yData);

    % Find the indices where the derivative changes from positive to negative
    peakIndices = find(dy(1:end-1) > 0 & dy(2:end) <= 0) + 1;

    % Filter the peaks to those within the specified range
    validPeakIndices = peakIndices(xData(peakIndices) > rangeMin & xData(peakIndices) < rangeMax);

    % If validPeakIndices is not empty, annotate the first peak
    if ~isempty(validPeakIndices)
        [~, maxIndex] = max(yData(validPeakIndices));
        peakIndex = validPeakIndices(maxIndex);

        % Offset for annotations to avoid overlap
        xOffset = -0.05 * (variableIndex - 1); % Adjust based on variable index
        yOffset = 1 + 0.9 * (variableIndex - 1);  % Adjust based on variable index

        % Darken the color for better visibility
        darkerColor = brighten(color, -0.5); % Adjust the factor as needed
        
        % Annotate the peak
        %text(xData(peakIndex) + xOffset, yData(peakIndex) + yOffset, sprintf('(%0.2f, %0.2f)', xData(peakIndex), yData(peakIndex)), ...
        %    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Color', darkerColor, 'FontSize', 13, 'FontWeight', 'bold');
        
        % Plot a marker at the peak with 'HandleVisibility' set to 'off'
        plot(xData(peakIndex), yData(peakIndex), 'o', 'Color', darkerColor, 'MarkerFaceColor', darkerColor, 'HandleVisibility', 'off');
    end
end