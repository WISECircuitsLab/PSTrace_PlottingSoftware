function [complete_data,IV_names,folder_name,directory_path] = scrape_data_from_files(in_folders, directory_path)
    if (nargin==1)
        directory_path = uigetdir; % open gui to select main path
    end
    
    % move all csv files into their own folder if not already
    if in_folders == false
        move_to_folders(directory_path);
    end


    folder_name = strsplit(directory_path,'/');
    folder_name = folder_name{end};

    mainfileandfolders = dir(directory_path);
    subfolders = mainfileandfolders([mainfileandfolders.isdir]); % find the subfolders
    csvfiles = {};
    for i = 1:length(subfolders)
        subpath = fullfile(directory_path,subfolders(i).name); % path to subfolder
        csvfiles{i} = dir(fullfile(subpath,'*.csv')); % list the csvfile in subfolder
    end
    
    csvfiles = csvfiles(~cellfun('isempty',csvfiles)); %remove all empty contents

    complete_data = cell(length(csvfiles),length(csvfiles{1}));
    IV_names = strings(length(csvfiles)*length(csvfiles{1}),1);
    IV_counter = 1;
    warning('off','MATLAB:table:ModifiedAndSavedVarnames')
    for i = 1:length(csvfiles)
        for j = 1:length(csvfiles{i})
            folder = csvfiles{1,i}(j).folder;
            IV = strsplit(folder,'/');
            file = csvfiles{1,i}(j).name;
            csv_absolute_path = strcat(strcat(folder,'/'),file); %generate singular csv path
            IV_names(IV_counter,1) = string(IV{end});%save experiment IV name
            IV_counter = IV_counter+1;
            current_data = readtable(csv_absolute_path); %get data from path 
            current_data = rmmissing(current_data);%remove rows with nan values
            fprintf('Collecting Data From: (IV #%d, Trial #%d)\t%s\n',i,j,csv_absolute_path); % provide usefull debugging info to user
            complete_data{i,j} = current_data;%add current dataset to rest
        end
    end
    warning('on','MATLAB:table:ModifiedAndSavedVarnames')
    IV_names = unique(IV_names,'stable'); %remove duplicates
    IV_names(IV_names=='') = [];%remove blank entries
end