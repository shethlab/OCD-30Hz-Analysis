date = '2023-05-04';
subject_id = 'aDBS012';
exp = 0;
check = input('Check')
if check
    
else
    error()
end
plot_coherence = 0;
plot_spectrograms = 0;
plot_psd = 1;

if exp == 0 
    exp_str = '';
else
    exp_str = ['Experiment_',num2str(exp),'\'];
end
loaddir = ['Z:\OCD_Data\preprocessed-new\',subject_id,'\',date,'\amplitude\',exp_str,'analysis\'];
loadfile = [subject_id,'_',date,'_amplitude-analysis_v2.mat'];
load([loaddir,loadfile])
analysis_save_dir = loaddir;
analysis_save_dir_all = 'D:\Amplitude-analysis-results\all_patients\';
if ~isfolder(analysis_save_dir_all)
    mkdir(analysis_save_dir_all);
end
addpath(genpath(analysis_save_dir_all))





%%
dat1 = amp_data.lfp(1).combinedDataTable;
dat2 = amp_data.lfp(2).combinedDataTable;

% get trial inds
trial_inds_low1 = get_trial_inds_keep_nans(amp_data.ts1,amp_data.DBS_low_times);
trial_inds_low2 = get_trial_inds_keep_nans(amp_data.ts2,amp_data.DBS_low_times);
trial_inds_high1 = get_trial_inds_keep_nans(amp_data.ts1,amp_data.DBS_high_times);
trial_inds_high2 = get_trial_inds_keep_nans(amp_data.ts2,amp_data.DBS_high_times);
trial_inds_clin1 = get_trial_inds_keep_nans(amp_data.ts1,amp_data.DBS_clin_times);
trial_inds_clin2 = get_trial_inds_keep_nans(amp_data.ts2,amp_data.DBS_clin_times); 

if plot_psd ==1
PSD_figures;
end

%% chop time domain data to experiment time 
start_ind1 = find(round(amp_data.ts1,3) == round(amp_data.DBS_low_times(1,1),2));
if isempty(start_ind1)
    start_ind1 = find(round(amp_data.ts1-0.001,3) == round(amp_data.DBS_low_times(1,1),2));
end
end_ind1 = find(round(amp_data.ts1,3) == round(amp_data.DBS_clin_times(1,2),2));
if isempty(end_ind1)
    end_ind1 = find(round(amp_data.ts1-0.001,3) == round(amp_data.DBS_clin_times(1,2),2));
end
start_ind2 = find(round(amp_data.ts2,3) == round(amp_data.DBS_low_times(1,1),2));
if isempty(start_ind2)
    start_ind2 = find(round(amp_data.ts2-0.001,3) == round(amp_data.DBS_low_times(1,1),2));
end
end_ind2 = find(round(amp_data.ts2,3) == round(amp_data.DBS_clin_times(1,2),2));
if isempty(end_ind2)
    end_ind2 = find(round(amp_data.ts2-0.001,3) == round(amp_data.DBS_clin_times(1,2),2));
end

psd_win_size = 1024;
psd_overlap = 512;
upper_freq_lim = 50;
hold_on = 0;   
%%

%ch1_input = 4;
%ch2_input = 4;
%ax = talking_triggered_beta(dat1,dat2,ch1_input,ch2_input,start_ind1,end_ind1,start_ind2,end_ind2,hold_on,amp_data.channels,psd_win_size,psd_overlap,upper_freq_lim);

% ch1_input = 3;
% ch2_input = 3;
% plot_spectrogram_nans(dat1,dat2,ch1_input,ch2_input,start_ind1,end_ind1,start_ind2,end_ind2,hold_on,amp_data.channels,psd_win_size,psd_overlap,upper_freq_lim);
% ch_inputs = ['L-',num2str(ch1_input),'_R-',num2str(ch2_input)];
% saveas(gcf,[analysis_save_dir,subject_id,'_',date,'_amplitude-analysis_spectrogram_',ch_inputs,'.png'])
if plot_spectrograms ==1

ch1_input = 4;
ch2_input = 4;
upper_freq_lim = 60;
plot_spectrogram_nans(dat1,dat2,ch1_input,ch2_input,start_ind1,end_ind1,start_ind2,end_ind2,hold_on,amp_data.channels,psd_win_size,psd_overlap,upper_freq_lim);
ch_inputs = ['L-',num2str(ch1_input),'_R-',num2str(ch2_input)];
saveas(gcf,[analysis_save_dir,subject_id,'_',date,'_amplitude-analysis_spectrogram4_',ch_inputs,'.png'])
saveas(gcf,[analysis_save_dir,subject_id,'_',date,'_amplitude-analysis_spectrogram4_',ch_inputs,'.svg'])

ch1_input = 1;
ch2_input = 1;
plot_spectrogram_nans(dat1,dat2,ch1_input,ch2_input,start_ind1,end_ind1,start_ind2,end_ind2,hold_on,amp_data.channels,psd_win_size,psd_overlap,upper_freq_lim);
ch_inputs = ['L-',num2str(ch1_input),'_R-',num2str(ch2_input)];
saveas(gcf,[analysis_save_dir,subject_id,'_',date,'_amplitude-analysis_spectrogram_',ch_inputs,'.png'])
end
%%
if plot_coherence==1
plot_coherence_nans(dat1,dat2,amp_data.channels,amp_data,subject_id,date,loaddir)
end
