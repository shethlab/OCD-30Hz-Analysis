close all;
clear all;

%% Init datafolder
datafoldername = '/Users/sameerrajesh/Desktop/30Hz Project Data/'; % replace with your folder name

prompt = 'Enter date string for preprocessing (e.g. "2020-01-08"): ';
date = input(prompt);
if isstring(date)
    date = convertStringsToChars(date);
end


prompt = 'Enter experiment number (0 if none): ';
exp = input(prompt);
if exp==0
    exp_str = '';
else
    exp_str = ['Experiment_',num2str(exp)];
end

task = 'amplitude';

loaddir = [datafoldername,date,'/AnalysisFiles/',task,'/',exp_str,'/'];

%% Find Analysis file to load
loadfile = [date,'_amplitude-analysis.mat'];
load([loaddir,loadfile])
analysis_save_dir = loaddir;

%%
dat1 = amp_data.lfp(1).combinedDataTable;
dat2 = amp_data.lfp(2).combinedDataTable;

% get trial inds
%1 and 2 refer to L/R Hem
trial_inds_low1 = get_trial_inds_keep_nans(amp_data.ts1,amp_data.DBS_low_times);
trial_inds_low2 = get_trial_inds_keep_nans(amp_data.ts2,amp_data.DBS_low_times);
trial_inds_high1 = get_trial_inds_keep_nans(amp_data.ts1,amp_data.DBS_high_times);
trial_inds_high2 = get_trial_inds_keep_nans(amp_data.ts2,amp_data.DBS_high_times);
trial_inds_clin1 = get_trial_inds_keep_nans(amp_data.ts1,amp_data.DBS_clin_times);
trial_inds_clin2 = get_trial_inds_keep_nans(amp_data.ts2,amp_data.DBS_clin_times); 

close all;
psd_win_size = 1024;
psd_overlap = 512;
upper_freq_lim = 55;

log_bool = 1;

%% Find Stim Info
low_amp1 = min(amp_data.stim_changes1(:,1)); 
low_amp2 = min(amp_data.stim_changes2(:,1)); 
high_amp1 = max(amp_data.stim_changes1(:,1)); 
high_amp2 = max(amp_data.stim_changes2(:,1));
clin_amp1 = amp_data.clin_amp_left; 
clin_amp2 = amp_data.clin_amp_right;

pw1 = [num2str(amp_data.stim_changes1(1,2)),' us'];
freq1 = [sprintf('%05.1f', amp_data.stim_changes1(1,3)),' Hz'];
pw2 = [num2str(amp_data.stim_changes2(1,2)),' us'];
freq2 = [sprintf('%05.1f', amp_data.stim_changes2(1,3)),' Hz'];

stimc1 = amp_data.lfp(1).simple_stim_log.Contact{1};  
i=1;
while strcmp(stimc1,'None')
    stimc1 = amp_data.lfp(1).simple_stim_log.Contact{i+1};
    i = i+1;
end

stimc2 = amp_data.lfp(2).simple_stim_log.Contact{1};  
i=1;
while strcmp(stimc2,'None')
    stimc2 = amp_data.lfp(2).simple_stim_log.Contact{i+1};
    i = i+1;
end


%% Initial Plots of PSD
c = [31 195 255;...
    251 86 59;...
    0 108 255;...
    237 28 36;...
    %0 38 255;...
    57 181 74]/255;
leg_position = [.5 .48 .05 .03];

% In this code long segments of packetloss are not excluded as indicated in
% paper. Exclusion occurs downstream and is hardcoded into the fi.
%% Left Hemisphere
hold_on = 0;
[ax1,f1,mean_psdMat1_low1,mean_psdMat2_low1,mean_psdMat3_low1,mean_psdMat4_low1] = plot_PSD_nans(dat1,'Left',trial_inds_low1{1},hold_on,amp_data.channels(:,1),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(1,:));
hold_on = 1;
[ax1,f1,mean_psdMat1_high1,mean_psdMat2_high1,mean_psdMat3_high1,mean_psdMat4_high1] = plot_PSD_nans(dat1,'Left',trial_inds_high1{1},hold_on,amp_data.channels(:,1),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(2,:));
[ax1,f1,mean_psdMat1_low2,mean_psdMat2_low2,mean_psdMat3_low2,mean_psdMat4_low2] = plot_PSD_nans(dat1,'Left',trial_inds_low1{2},hold_on,amp_data.channels(:,1),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(3,:));
[ax1,f1,mean_psdMat1_high2,mean_psdMat2_high2,mean_psdMat3_high2,mean_psdMat4_high2] = plot_PSD_nans(dat1,'Left',trial_inds_high1{2},hold_on,amp_data.channels(:,1),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(4,:));
[ax1,f1,mean_psdMat1_clin1,mean_psdMat2_clin1,mean_psdMat3_clin1,mean_psdMat4_clin1] = plot_PSD_nans(dat1,'Left',trial_inds_clin1{1},hold_on,amp_data.channels(:,1),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(5,:));

leg1 = legend({['A: ',num2str(low_amp1),' mA'];['B: ',num2str(high_amp1),' mA'];['C: ',num2str(low_amp1),' mA'];['D: ',num2str(high_amp1),' mA'];['E: ',num2str(clin_amp1),' mA']},'Location','eastoutside','Orientation','horizontal','NumColumns',5,'FontSize',11);
set(leg1,'Position',leg_position);
temp= ax1(1).Title.String;
ax1(1).Title.String = [temp,': ',stimc1,', ',pw1,', ',freq1];
low1 = [mean_psdMat1_low1,mean_psdMat2_low1,mean_psdMat3_low1,mean_psdMat4_low1];
low2 = [mean_psdMat1_low2,mean_psdMat2_low2,mean_psdMat3_low2,mean_psdMat4_low2];
high1 = [mean_psdMat1_high1,mean_psdMat2_high1,mean_psdMat3_high1,mean_psdMat4_high1];
high2 = [mean_psdMat1_high2,mean_psdMat2_high2,mean_psdMat3_high2,mean_psdMat4_high2];
clin1 = [mean_psdMat1_clin1,mean_psdMat2_clin1,mean_psdMat3_clin1,mean_psdMat4_clin1];
save([analysis_save_dir,date,'_PSD-data_Left.mat'],'f1','low1','low2','high1','high2','clin1')


%% Right Hemisphere
hold_on = 0;    
[ax1,f1,mean_psdMat1_low1,mean_psdMat2_low1,mean_psdMat3_low1,mean_psdMat4_low1] = plot_PSD_nans(dat2,'Right',trial_inds_low2{1},hold_on,amp_data.channels(:,2),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(1,:));
hold_on = 1;
[ax1,f1,mean_psdMat1_high1,mean_psdMat2_high1,mean_psdMat3_high1,mean_psdMat4_high1] = plot_PSD_nans(dat2,'Right',trial_inds_high2{1},hold_on,amp_data.channels(:,2),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(2,:));
[ax1,f1,mean_psdMat1_low2,mean_psdMat2_low2,mean_psdMat3_low2,mean_psdMat4_low2] = plot_PSD_nans(dat2,'Right',trial_inds_low2{2},hold_on,amp_data.channels(:,2),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(3,:));
[ax1,f1,mean_psdMat1_high2,mean_psdMat2_high2,mean_psdMat3_high2,mean_psdMat4_high2] = plot_PSD_nans(dat2,'Right',trial_inds_high2{2},hold_on,amp_data.channels(:,2),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(4,:));
[ax1,f1,mean_psdMat1_clin1,mean_psdMat2_clin1,mean_psdMat3_clin1,mean_psdMat4_clin1] = plot_PSD_nans(dat2,'Right',trial_inds_clin2{1},hold_on,amp_data.channels(:,2),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(5,:));

leg1 = legend({['A: ',num2str(low_amp2),' mA'];['B: ',num2str(high_amp2),' mA'];['C: ',num2str(low_amp2),' mA'];['D: ',num2str(high_amp2),' mA'];['E: ',num2str(clin_amp2),' mA']},'Location','eastoutside','Orientation','horizontal','NumColumns',5,'FontSize',11);
set(leg1,'Position',leg_position);
temp= ax1(1).Title.String;
ax1(1).Title.String = [temp,': ',stimc2,', ',pw2,', ',freq2];
low1 = [mean_psdMat1_low1,mean_psdMat2_low1,mean_psdMat3_low1,mean_psdMat4_low1];
low2 = [mean_psdMat1_low2,mean_psdMat2_low2,mean_psdMat3_low2,mean_psdMat4_low2];
high1 = [mean_psdMat1_high1,mean_psdMat2_high1,mean_psdMat3_high1,mean_psdMat4_high1];
high2 = [mean_psdMat1_high2,mean_psdMat2_high2,mean_psdMat3_high2,mean_psdMat4_high2];
clin1 = [mean_psdMat1_clin1,mean_psdMat2_clin1,mean_psdMat3_clin1,mean_psdMat4_clin1];
save([analysis_save_dir,date,'_PSD-data_Right.mat'],'f1','low1','low2','high1','high2','clin1')


