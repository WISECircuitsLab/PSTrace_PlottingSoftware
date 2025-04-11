function tb = importData(filepath, filename)
    % Imports data from a CSV file into a table.
    tb = readtable(fullfile(filepath, filename));
end
