close all;
clear all;
%addpath(genpath('C:\Users\Nicole\OneDrive\Documents\GitHub\OCD-phaseII\'))
addpath(genpath('C:\Users\Owner\Documents\GitHub\OCD-phaseII\'))
prompt = 'Enter date string for preprocessing (e.g. "2020-01-08"): ';
date = input(prompt);
if isstring(date)
    date = convertStringsToChars(date);
end

prompt = 'Enter subject ID string: ';
subject_id = input(prompt);
if isstring(subject_id)
    subject_id = convertStringsToChars(subject_id);
end

task = 'entrainment';

loaddir = ['Z:\OCD_Data\preprocessed-new\',subject_id,'\',date,'\',task,'\'];

%find EEG file to load
all_files = dir(loaddir);
all_files(1:2) = [];
for i = 1:length(all_files)
    file_name = all_files(i).name;
    if contains(file_name,'synced_ephys_behav_v3')
        file_EEG = i;
    end
end
load([loaddir,all_files(file_EEG).name])
ekg_ind = find(cellfun(@(x)strcmp(x,'EKG'),data.channel_locs));
ekg = data.EEG_all(ekg_ind,(data.first_sample_ind:data.last_sample_ind));
ts_ekg_pulse = (1/data.fs):(1/data.fs):(length(ekg)/data.fs);
pulse_ind = find(cellfun(@(x)strcmp(x,'PULSE'),data.channel_locs));
pulse = data.EEG_all(pulse_ind,(data.first_sample_ind:data.last_sample_ind));

% find LFP file to load
for i = 1:length(all_files)
    file_name = all_files(i).name;
    if contains(file_name,'synced_ephys_behav_lfp_v3')
        file_LFP = i;
    end
end

% find AV file to load
for i = 1:length(all_files)
    file_name = all_files(i).name;
    if contains(file_name,'synced_ephys_behav_AV_lfp')
        file_AV = i;
    end
end

try load([loaddir,all_files(file_LFP).name])
    AV = load([loaddir,all_files(file_AV).name]);
catch
    AV = [];
end
dat1 = lfpData(1).combinedDataTable;
dat2 = lfpData(2).combinedDataTable;

%% plot time domain
task_start =  data.behavior.behav_start_timestamp_unix;
task_end =  data.behavior.behav_end_timestamp_unix;
ts1 = (dat1.DerivedTime - task_start)/1000;
ts2 = (dat2.DerivedTime - task_start)/1000;

%%
% get stim 
[datc1,ampc1] = plot_stim_settings(lfpData(1).stimLogSettings,lfpData(1).timeDomainSettings.samplingRate(1),dat1,task_start,task_end,lfpData(1).hemisphere);
[datc2,ampc2] = plot_stim_settings(lfpData(2).stimLogSettings,lfpData(2).timeDomainSettings.samplingRate(1),dat2,task_start,task_end,lfpData(2).hemisphere);

% delete toggles

ind_toggle1 = find(sum([ampc1(:,3)~=150.6, ampc1(:,3)~=50, ampc1(:,3)~=200],2)==3);
ind_toggle2 = find(sum([ampc2(:,3)~=150.6, ampc2(:,3)~=50, ampc2(:,3)~=200],2)==3);

ampc1(ind_toggle1,:) = [];
ampc2(ind_toggle2,:) = [];
datc1(ind_toggle1) = [];
datc2(ind_toggle2) = [];


%%
behav_start = (data.behavior.behav_start_timestamp_unix-dat1.DerivedTime(1))/1000;
behav_end = (data.behavior.behav_end_timestamp_unix-dat1.DerivedTime(1))/1000;

sense_start = (lfpData(1).timeDomainSettings.timeStart-dat1.DerivedTime(1))/1000;
sense_end = (lfpData(1).timeDomainSettings.timeStop-dat1.DerivedTime(1))/1000;

if length(sense_start)>1
    sense_i = find(behav_start>sense_start);
    sense_i = sense_i(end);
    %if sense_i > 1
    %   error('need to figure out sensing channel identification bug')
    %else
    %end
else
    sense_i =1;
end
if and(behav_start>sense_start(sense_i),behav_end<sense_end(sense_i))
    channels = ...
        {lfpData(1).timeDomainSettings.chan1{sense_i},lfpData(2).timeDomainSettings.chan1{sense_i};...
        lfpData(1).timeDomainSettings.chan2{sense_i},lfpData(2).timeDomainSettings.chan2{sense_i};...
        lfpData(1).timeDomainSettings.chan3{sense_i},lfpData(2).timeDomainSettings.chan3{sense_i};...
        lfpData(1).timeDomainSettings.chan4{sense_i},lfpData(2).timeDomainSettings.chan4{sense_i}};
else
    error('need to figure out sensing channel identification bug')
end
%channels{1,1} = [stim_settings,' ',channels{1}];
%channels{1,1} = [stim_settings,' ',channels{1}];

stim_i = find(lfpData(1).full_stim_log.("Sense Channels Correct")==1);
stim_channel1 = lfpData(1).full_stim_log.("Stim Settings"){stim_i(1)}(1:4);
stim_channel2 = lfpData(2).full_stim_log.("Stim Settings"){stim_i(1)}(1:4);

%%
fig = figure('units','normalized','outerposition',[0 0 1 1]);
ax0 = subplot(7,2,1);
yyaxis left
plot(datc1,ampc1(:,1))
ylabel('Amplitude (mA)')
hold on
yyaxis right
plot(datc1,ampc1(:,3))
ylabel('Frequency (Hz)')
title({'Left Hemisphere Stimulation Parameters';stim_channel1})

hold on
%legend({'Left';'Right'})
ax0b = subplot(7,2,2);
yyaxis left
plot(datc2,ampc2(:,1))
ylabel('Amplitude (mA)')
hold on
yyaxis right
plot(datc2,ampc2(:,3))
hold on
%plot(ts_temp2,amp2(~temp2))
ylabel('Frequency (Hz)')
title({'Right Hemisphere Stimulation Parameters';stim_channel2})
%legend({'Left';'Right'})

ax1 = subplot(7,2,3);
plot(ts1, dat1.TD_key0)
ylabel('VC/VS Ch1 (mV)')
title(channels{1,1})

ax1b = subplot(7,2,4);
plot(ts2, dat2.TD_key0)
ylabel('VC/VS Ch1 (mV)')
title(channels{1,2})

ax2 = subplot(7,2,5);
plot(ts1, dat1.TD_key1)
ylabel('VC/VS Ch2 (mV)')
title(channels{2,1})

ax2b = subplot(7,2,6);
plot(ts2, dat2.TD_key1)
ylabel('VC/VS Ch2 (mV)')
title(channels{2,2})

ax3 = subplot(7,2,7);
plot(ts1, dat1.TD_key2)
ylabel('OFC Ch3 (mV)')
title(channels{3,1})

ax3b = subplot(7,2,8);
plot(ts2, dat2.TD_key2)
ylabel('OFC Ch3 (mV)')
title(channels{3,2})

ax4 = subplot(7,2,9);
plot(ts1, dat1.TD_key3)

ylabel('OFC Ch4 (mV)')
title(channels{4,1})

ax4b = subplot(7,2,10);
plot(ts2, dat2.TD_key3)

ylabel('OFC Ch4 (mV)')
title(channels{4,2})

%% EKG and Pulse
[ts_ekg,denoised_EKG,ts_pulse,denoised_pulse] = plotEKG(ekg,pulse);
ax6 = subplot(7,2,11);
plot(ts_ekg,denoised_EKG);
xlabel('seconds');
title('HR Estimate');
ylabel('EKG (BPM)');
ax6b = subplot(7,2,12);
plot(ts_pulse,denoised_pulse);
xlabel('seconds');
title('HR Estimate');
ylabel('Pulse Sensor (BPM)');


%% audio

ax5 = subplot(7,2,13);

if ~isempty(AV)
    aud = AV.data.audio;
    aud_ts = (1/AV.data.fs_audio):(1/AV.data.fs_audio):(length(aud)/AV.data.fs_audio);
    plot(aud_ts,aud)
    ylabel('Audio')
    linkaxes([ax0,ax1,ax2,ax3,ax4,ax5,ax6],'x')
else
    linkaxes([ax0,ax1,ax2,ax3,ax4,ax6],'x')

end

ax5b = subplot(7,2,14);
if ~isempty(AV)
    plot(aud_ts,aud)
    ylabel('Audio')
    linkaxes([ax0,ax0b,ax1b,ax2b,ax3b,ax4b,ax5b,ax6b],'x')
    ax_all = [ax0,ax1,ax2,ax3,ax4,ax5,ax6,ax0b,ax1b,ax2b,ax3b,ax4b,ax5b,ax6b];

else
    linkaxes([ax0,ax0b,ax1b,ax2b,ax3b,ax4b,ax6b],'x')
    ax_all = [ax0,ax1,ax2,ax3,ax4,ax6,ax0b,ax1b,ax2b,ax3b,ax4b,ax6b];

end



%% plot PSDs from DBS high and DBS low

linkaxes([ax0,ax1,ax2,ax3,ax4,ax5,ax6],'x')
linkaxes([ax0b,ax1b,ax2b,ax3b,ax4b,ax5b,ax6b],'x')


%% Sameer Code

[stable_periods,stim_params_left,stim_params_right,condition,left_plats,right_plats] =findBilateralStablePeriodsEntrainment(ampc1,ampc2,datc1,datc2);


%% plot PSDs from DBS high and DBS low

DBS_high_times = stable_periods(find(cellfun(@(x) contains(x,'High'),condition)),:);
DBS_medium_times = stable_periods(find(cellfun(@(x) contains(x,'Medium'),condition)),:);
DBS_low_times = stable_periods(find(cellfun(@(x) contains(x,'Low'),condition)),:);
DBS_clin_times = stable_periods(find(cellfun(@(x) contains(x,'Clinical'),condition)),:);
DBS_other_times = stable_periods(find(cellfun(@(x) contains(x,'Other'),condition)),:);

%% Trim Excess data from start of short expts

expt_end_time = DBS_clin_times(end,2);
expt_start_time_estimate = expt_end_time - 60*24;


i = 1;
while i<= height(DBS_high_times)
    if DBS_high_times(i,2)<expt_start_time_estimate
        DBS_high_times(i,:) =[];
        continue
    end
    if DBS_high_times(i,1) <expt_start_time_estimate
        if abs(DBS_high_times(i,1) -expt_start_time_estimate)<2
            i = i+1;
            continue
        else
            DBS_high_times(i,1) = expt_start_time_estimate;
            i= i+1;
            continue
        end
    else
        i = i+1;
    end
end

i = 1;
while i<= height(DBS_medium_times)
    if DBS_medium_times(i,2)<expt_start_time_estimate
        DBS_medium_times(i,:) =[];
        continue
    end
    if DBS_medium_times(i,1) <expt_start_time_estimate
        if abs(DBS_medium_times(i,1) -expt_start_time_estimate)<2
            i = i+1;
            continue
        else
            DBS_medium_times(i,1) = expt_start_time_estimate;
            i= i+1;
            continue
        end
    else
        i = i+1;
    end
end

i = 1;
while i<= height(DBS_low_times)
    if DBS_low_times(i,2)<expt_start_time_estimate
        DBS_low_times(i,:) =[];
        continue
    end
    if DBS_low_times(i,1) <expt_start_time_estimate
        if abs(DBS_low_times(i,1) -expt_start_time_estimate)<2
            i = i+1;
            continue
        else
            DBS_low_times(i,1) = expt_start_time_estimate;
            i= i+1;
            continue
        end
    else
        i = i+1;
    end
end

i = 1;
while i<= height(DBS_clin_times)
    if DBS_clin_times(i,2)<expt_start_time_estimate
        DBS_clin_times(i,:) =[];
        continue
    end
    if DBS_clin_times(i,1) <expt_start_time_estimate
        if abs(DBS_clin_times(i,1) -expt_start_time_estimate)<2
            i = i+1;
            continue
        else
            DBS_clin_times(i,1) = expt_start_time_estimate;
            i= i+1;
            continue
        end
    else
        i = i+1;
    end
end

i = 1;
while i<= height(DBS_other_times)
    if DBS_other_times(i,2)<expt_start_time_estimate
        DBS_other_times(i,:) =[];
        continue
    end
    if DBS_other_times(i,1) <expt_start_time_estimate
        if abs(DBS_other_times(i,1) -expt_start_time_estimate)<2
            i = i+1;
            continue
        else
            DBS_other_times(i,1) = expt_start_time_estimate;
            i= i+1;
            continue
        end
    else
        i = i+1;
    end
end

%% Plot
for i = 1:length(ax_all)
    axes(ax_all(i))
    try
    xline(DBS_low_times(1,:),'k')
    catch
    end
    hold on
    try
    xline(DBS_low_times(2,:),'k')
    catch
    end
    hold on
    try
    xline(DBS_medium_times(1,:),'g')
    catch
    end
    hold on
    try
    xline(DBS_medium_times(2,:),'g')
    catch
    end
    hold on
    try
    xline(DBS_high_times(1,:),'r')
    catch
    end
    hold on
    try
    xline(DBS_high_times(2,:),'r')
    catch
    end
    hold on
    try
        for q = 1:height(DBS_clin_times)
            xline(DBS_clin_times(q,:),'b')
        end
    catch
        warning('Could not Find Clinical Times')
    end
    hold on
    try
        xline(DBS_other_times(1,:),'g')
        hold on
        xline(DBS_other_times(2,:),'g')
    catch
    end
end

ent_data.ts1 = ts1;
ent_data.ts2 = ts2;
ent_data.lfp = lfpData;
if ~isempty(AV)
    ent_data.audio = aud;
    ent_data.ts_audio = aud_ts;
    ent_data.fs_audio = AV.data.fs_audio;
end
ent_data.DBS_clin_times = DBS_clin_times;
ent_data.DBS_high_times = DBS_high_times;
ent_data.DBS_medium_times = DBS_medium_times;
ent_data.DBS_low_times = DBS_low_times;
ent_data.DBS_other_times = DBS_other_times;
ent_data.stim_changes_key = ['amp','pw','freq'];
ent_data.stim_changes1 = stim_params_left;
ent_data.stim_changes2 = stim_params_right;
ent_data.stim_times1 = datc1;
ent_data.stim_times2 = datc2;
ent_data.stim_channel1 = stim_channel1;
ent_data.stim_channel2 = stim_channel2;
ent_data.ekg = ekg;
ent_data.pulse = pulse;
ent_data.ts_ekg_pulse = ts_ekg_pulse;
ent_data.clin_amp_left = left_plats(3);
ent_data.clin_amp_right = right_plats(3);
ent_data.amp_limits_left = left_plats(1:2);
ent_data.amp_limits_right = right_plats(1:2);
ent_data.channels = channels;

ent_data.EKG_HR_Estimate =denoised_EKG;
ent_data.EKG_HR_ts = ts_ekg;
ent_data.EKG_HR_Estimate =denoised_pulse;
ent_data.EKG_HR_ts = ts_pulse;


% create analysis subdirectory
analysis_save_dir = [loaddir,'analysis\'];
if ~exist(analysis_save_dir)
    mkdir(analysis_save_dir)
end
save([analysis_save_dir,subject_id,'_',date,'_entrainment-analysis_v2.mat'],'ent_data')
saveas(fig,[analysis_save_dir,subject_id,'_',date,'_entrainment-analysis_v2.png'])

%%

