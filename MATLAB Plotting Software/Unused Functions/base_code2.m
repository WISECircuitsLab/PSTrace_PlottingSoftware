% base_code 2 will require you to put in all of needed values and then it
% will auto plot ALL plot types availible for that data type

%defintions & constants
Potentiostat_EIS_Data_Organization = ["freq_Hz","Time_S","Log_f_Hz_","phase_deg","Idc_UA","Iac_UA","impedance_ohm","Zr_Ohm","Zi_Ohm","Log_Z_Ohm_","Cs_F","Edc_V","Eac_V"];%currentRange column removed
Potentiostat_CV_Data_Organization = repmat(["Voltage_V","Current_µA"],1,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EDIT HERE!!!!
%ask what type of data & plotting required 
data_type="Potentiostat";
experiment_type="EIS";
plot_type="All";
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




file_path = '/Users/yashpatel/Library/CloudStorage/GoogleDrive-pately@bu.edu/.shortcut-targets-by-id/1dUGSgK4dNlhT0Kda84YXM4_VSST3Isvi/BU_BioMADE/BioMADE Experiment Data Results/Salt Solution Impedance Experiments/EXP14 4_22_24 Conductivitty Experiments/CV Measurements';

prompt = ["Enter desired plot title"]; dlgtitle = 'Formatting & Saving Plot'; dims = [1 35]; definput = {'none','none'};
plt_title_save = inputdlg(prompt,dlgtitle,dims,definput);
plt_title_save = plt_title_save{1};
%plt_title_save = 'none';


[data,names,root_folder_name,root_folder] = scrape_data_from_files();

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
        NyquistPlot(average,stds,names,organization_dict);
        FormatPlot(root_folder,{plt_title_save,sprintf("%s Nyquist Plot.png",plt_title_save)});
        NyquistPlot_Shaded(average,stds,names,organization_dict);
        FormatPlot(root_folder,{plt_title_save,sprintf("%s Nyquist Plot Shaded.png",plt_title_save)});
    case "Nichols plot" %not completed still in progress
        NicholsPlot(average,stds);
        FormatPlot(root_folder,{plt_title_save,sprintf("%s Nichols Plot.png",plt_title_save)});
    case "Bode plot"
        BodePlot(average,stds,names,organization_dict);
        FormatPlot(root_folder,{plt_title_save,sprintf("%s Bode Plot.png",plt_title_save)});
    case "Basic plot"
        BasicPlot(average,stds,names,organization_dict);
        FormatPlot(root_folder,{plt_title_save,sprintf("%s Basic Plot.png",plt_title_save)});
    case 'CV'
        CVPlot(average,stds,names,organization_dict);
        FormatPlot(root_folder,{plt_title_save,sprintf("%s CV Plot.png",plt_title_save)});
    case 'DPV'
        DPVPlot(average,stds,names,organization_dict);
        FormatPlot(root_folder,{plt_title_save,sprintf("%s CV Plot.png",plt_title_save)});
    case 'All'
        NyquistPlot(average,stds,names,organization_dict);
        FormatPlot(root_folder,{plt_title_save,sprintf("%s Nyquist Plot.png",plt_title_save)});
        NyquistPlot_Shaded(average,stds,names,organization_dict);
        FormatPlot(root_folder,{plt_title_save,sprintf("%s Nyquist Plot Shaded.png",plt_title_save)});
        BodePlot(average,stds,names,organization_dict);
        FormatPlot(root_folder,{plt_title_save,sprintf("%s Bode Plot.png",plt_title_save)});
        BasicPlot(average,stds,names,organization_dict);
        FormatPlot(root_folder,{plt_title_save,sprintf("%s Basic Plot.png",plt_title_save)});
end

%clear; close all; clc;