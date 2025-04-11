function move_to_folders(directory_path)
    disp("moving all csv files into their own folder . . . . ")
    % Get the list of all CSV files in the main directory
    csv_files = dir(fullfile(directory_path, '*.csv'));
    
    % Loop through each CSV file and move it to a new subfolder
    for i = 1:length(csv_files)
        % Get the name of the CSV file (without extension)
        [~, name, ~] = fileparts(csv_files(i).name);
        
        % Create a new subfolder with the name of the CSV file
        new_folder_path = fullfile(directory_path, name);
        if ~exist(new_folder_path, 'dir')
            mkdir(new_folder_path);
        end
        
        % Move the CSV file into the new subfolder
        old_file_path = fullfile(directory_path, csv_files(i).name);
        new_file_path = fullfile(new_folder_path, csv_files(i).name);
        movefile(old_file_path, new_file_path);
    end
end
