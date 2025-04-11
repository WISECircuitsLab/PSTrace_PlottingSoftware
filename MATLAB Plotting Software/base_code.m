%defintions & constants
Potentiostat_EIS_Data_Organization = ["freq_Hz","Time_S","Log_f_Hz_","phase_deg","Idc_UA","Iac_UA","impedance_ohm","Zr_Ohm","Zi_Ohm","Log_Z_Ohm_","Cs_F","Edc_V","Eac_V"];%currentRange column removed
Potentiostat_CV_Data_Organization = ["Voltage_V","Current_µA"];

LCR_Meter_Data_Organization = [];

warning('off','MATLAB:questdlg:StringMismatch')
%data_type=questdlg('Select Type of Data','Input Choise','LCR-Meter','Potentiostat','Nothing');
data_type='Potentiostat';
experiment_type=questdlg('Select Type of Experiment','Input Choise','Voltametry','EIS','Nothing');

in_folders = true; 

switch experiment_type
    case "Voltametry"
        voltametry_type=questdlg('Select Type of Experiment','Input Choise','CV','DPV','Nothing');
        choice = questdlg('Is the data organized into subfolders?','Data Organization Prompt','Yes', 'No', 'Yes');
    
        % Handle the response
        switch choice
            case 'No'
                in_folders = false;
        end

        switch voltametry_type
            case "CV"
                plot_type='CV';
            case 'DPV'
                plot_type='DPV';
        end
    case "EIS"
        plot_type='All';
end


[data,names,root_folder_name,root_folder] = scrape_data_from_files(in_folders);

%prompt = ["Enter desired plot title"]; dlgtitle = 'Formatting & Saving Plot'; dims = [1 35]; definput = {'none','none'};
%plt_title_save = inputdlg(prompt,dlgtitle,dims,definput);
%plt_title_save = plt_title_save{1};
plt_title_save = root_folder_name;

fprintf('Plotting a %s for %s data of %s\n',plot_type,data_type,root_folder_name);
[n,d]=size(data);

%data scrubbing & cleaning & setting mapping
switch true
    case data_type=="Potentiostat" && plot_type=="CV"
        [average,stds] = scrub_potentiostat_CV(data);
        organization_dict =  containers.Map(Potentiostat_CV_Data_Organization(1:2),1:length(Potentiostat_CV_Data_Organization(1:2)));
    case data_type=="Potentiostat" && plot_type=="DPV"
        [average,stds] = scrub_potentiostat_DPV(data);
        organization_dict =  containers.Map(Potentiostat_CV_Data_Organization(1:2),1:length(Potentiostat_CV_Data_Organization(1:2)));
    case data_type=="Potentiostat" && plot_type~="CV"
        [average,stds] = scrub_potentiostat_EIS(data);
        organization_dict =  containers.Map(Potentiostat_EIS_Data_Organization,1:length(Potentiostat_EIS_Data_Organization));
end

%call the correct function based on desired plotting type
close all; 
switch plot_type
    case "Nyquist plot"
        %NyquistPlot(average,stds,names,organization_dict);
        %FormatPlot(root_folder,{plt_title_save,sprintf("%s Nyquist Plot.png",plt_title_save)});
        NyquistPlot_Shaded(average,stds,names,organization_dict);
        FormatPlot(root_folder,{plt_title_save,sprintf("%s Nyquist Plot Shaded.png",plt_title_save)});
    case "Bode plot"
        BodePlot(average,stds,names,organization_dict);
        FormatPlot(root_folder,{plt_title_save,sprintf("%s Bode Plot.png",plt_title_save)});
    case "Basic plot"
        BasicPlot(average,stds,names,organization_dict);
        FormatPlot(root_folder,{plt_title_save,sprintf("%s Basic Plot.png",plt_title_save)});
    case 'Current plot'
        CurrentPlot(average,stds,names,organization_dict);
        FormatPlot(root_folder,{plt_title_save,sprintf("%s Current Plot.png",plt_title_save)});
    case 'CV'
        CVPlot(average,stds,names,organization_dict,true);
        FormatPlot(root_folder,{plt_title_save,sprintf("%s CV Plot.png",plt_title_save)});
    case 'DPV'
        DPVPlot(average,stds,names,organization_dict);
        FormatPlot(root_folder,{plt_title_save,sprintf("%s CV Plot.png",plt_title_save)});
    case 'All'
        allEISPlot(average,stds,names,organization_dict);
        FormatPlot(root_folder,{plt_title_save,sprintf("%s Combined Plot.png",plt_title_save)});
        CurrentPlot(average,stds,names,organization_dict);
        FormatPlot(root_folder,{plt_title_save,sprintf("%s Current Plot.png",plt_title_save)});
end