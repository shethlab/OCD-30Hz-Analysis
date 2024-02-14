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
    exp_str = ['Experiment_',num2str(exp),'/'];
end

task = 'amplitude';

loaddir = [datafoldername,date,'/PreProcessedData/',task,'/',exp_str];

%% find EEG file to load
all_files = dir(loaddir);
all_files(startsWith({all_files.name},'.')) = [];
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

%% find LFP file to load
for i = 1:length(all_files)
    file_name = all_files(i).name;
    if contains(file_name,'synced_ephys_behav_lfp_v3')
        file_LFP = i;
    end
end

%% find AV file to load
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



%% find toggle file to load
for i = 1:length(all_files)
    file_name = all_files(i).name;
    if contains(file_name,'toggle')
        file_toggle = i;
    end
end

try 
    toggle = load([loaddir,all_files(file_toggle).name]);
    if ~strcmp(date,'2022-09-09') && ~strcmp(exp,2)
    offsetRH = mean(toggle.lfpData(2).unifiedDerivedTimes-lfpData(2).unifiedDerivedTimes,'omitnan');
    lfpData = toggle.lfpData;
    lfpData(2).full_stim_log.("Unified Derived Time") = lfpData(2).full_stim_log.("Unified Derived Time")+offsetRH;
    end
catch
    toggle = [];
end
dat1 = lfpData(1).combinedDataTable;
dat2 = lfpData(2).combinedDataTable;
%% plot time domain
try
    timetable = toggle.toggle_sync.UDT_harmonized_events;
    startev = find(cellfun(@(x)strcmp(x,'S  1'),[timetable.Event]));
    task_start =  timetable{startev,2};
catch
    task_start =  data.behavior.behav_start_timestamp_unix;
end
task_end =  data.behavior.behav_end_timestamp_unix;
ts1 = (dat1.DerivedTime - task_start)/1000;
ts2 = (dat2.DerivedTime - task_start)/1000;

%% Visualize Stimulation Parameters
% get stim
[datc1,ampc1] = plot_stim_settings(lfpData(1).full_stim_log,lfpData(1).timeDomainSettings.samplingRate(1),dat1,task_start,task_end,lfpData(1).hemisphere);
[datc2,ampc2] = plot_stim_settings(lfpData(2).full_stim_log,lfpData(2).timeDomainSettings.samplingRate(1),dat2,task_start,task_end,lfpData(2).hemisphere);

% delete toggles

ind_toggle1 = find(ampc1(:,3)~=150.6 & ampc1(:,3)~=140.8);
ind_toggle2 = find(ampc2(:,3)~=150.6 & ampc2(:,3)~=140.8);

ampc1(ind_toggle1,:) = [];
ampc2(ind_toggle2,:) = [];
datc1(ind_toggle1) = [];
datc2(ind_toggle2) = [];

ampc1(isnan(ampc1(:,1))) = 0;
ampc2(isnan(ampc2(:,1))) = 0;

%% Verification of sensing setup
behav_start = (data.behavior.behav_start_timestamp_unix-dat1.DerivedTime(1))/1000;
behav_end = (data.behavior.behav_end_timestamp_unix-dat1.DerivedTime(1))/1000;

sense_start = (lfpData(1).timeDomainSettings.timeStart-dat1.DerivedTime(1))/1000;
sense_end = (lfpData(1).timeDomainSettings.timeStop-dat1.DerivedTime(1))/1000;

if length(sense_start)>1
    sense_i = find(behav_start>sense_start);
    sense_i = sense_i(end);

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

stim_i = find(lfpData(1).full_stim_log.("Sense Channels Correct")==1);
stim_channel1 = lfpData(1).full_stim_log.("Stim Settings"){stim_i(1)}(1:4);
stim_channel2 = lfpData(2).full_stim_log.("Stim Settings"){stim_i(1)}(1:4);

%% Visualize all the data streams
fig = figure('units','normalized','outerposition',[0 0 1 1]);
ax0 = subplot(7,2,1);
yyaxis left
plot(datc1,ampc1(:,1))
ylabel('Amplitude (mA)')
hold on
yyaxis right
plot(datc1,ampc1(:,2))
ylabel('Pulse Width (us)')
title({'Left Hemisphere Stimulation Parameters';stim_channel1})

hold on
%legend({'Left';'Right'})
ax0b = subplot(7,2,2);
yyaxis left
plot(datc2,ampc2(:,1))
ylabel('Amplitude (mA)')
hold on
yyaxis right
plot(datc2,ampc2(:,2))

hold on
%plot(ts_temp2,amp2(~temp2))
ylabel('Pulse Width (us)')
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

linkaxes([ax0,ax1,ax2,ax3,ax4,ax5,ax6],'x');
linkaxes([ax0b,ax1b,ax2b,ax3b,ax4b,ax5b,ax6b],'x');


%% Segmentation Code: 
% For Dates 1-4 and Control Expt 2, enter 1
% For Control Expt 1, enter 3
method = input('Segmentation Method: Enter 1 for Amplitude, 2 for Frequency, 3 for Experiment Time: ');
if method ==1
    [stable_periods,stim_params_left,stim_params_right,condition,left_plats,right_plats] =findBilateralStablePeriods(ampc1,ampc2,datc1,datc2);
elseif method ==2
    [stable_periods,stim_params_left,stim_params_right,condition,left_plats,right_plats] =findBilateralStablePeriodsFrequency(ampc1,ampc2,datc1,datc2);
elseif method==3
    [stable_periods,stim_params_left,stim_params_right,~,left_plats,right_plats] =findBilateralStablePeriods(ampc1,ampc2,datc1,datc2);
    delta = -4.5;
    temp = [[stable_periods(end,2)-360,stable_periods(end,2)-280];[stable_periods(end,2)-280,stable_periods(end,2)-220];[stable_periods(end,2)-220,stable_periods(end,2)-140];[stable_periods(end,2)-140,stable_periods(end,2)-80];[stable_periods(end,2)-80,stable_periods(end,2)-0]];
    temp = temp + delta;
    stable_periods = temp;
    condition = {'Clin (Low) Amplitude','Clin (High) Amplitude','Clin (Low) Amplitude','Clin (High) Amplitude','Clinical Amplitude'};
end

%% plot PSDs from DBS high and DBS low

DBS_high_times = stable_periods(find(cellfun(@(x) contains(x,'High'),condition)),:);
DBS_low_times = stable_periods(find(cellfun(@(x) contains(x,'Low'),condition)),:);
DBS_clin_times = stable_periods(find(cellfun(@(x) contains(x,'Clinical'),condition)),:);
DBS_other_times = stable_periods(find(cellfun(@(x) contains(x,'Other'),condition)),:);

%% Trim Excess data from start of short expts

expt_end_time = DBS_clin_times(end,2);
if exp>0
    expt_start_time_estimate = expt_end_time - 60*6;
else
    expt_start_time_estimate = 0; %Start the first experiment at time 0 (legacy preprocessing)
end

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
    if DBS_clin_times(i,2)<DBS_low_times(1,1)
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

%% Struct Construction
amp_data.ts1 = ts1;
amp_data.ts2 = ts2;
amp_data.lfp = lfpData;
if ~isempty(AV)
    amp_data.audio = aud;
    amp_data.ts_audio = aud_ts;
    amp_data.fs_audio = AV.data.fs_audio;
end
amp_data.DBS_clin_times = DBS_clin_times;
amp_data.DBS_high_times = DBS_high_times;
amp_data.DBS_low_times = DBS_low_times;
amp_data.DBS_other_times = DBS_other_times;
amp_data.stim_changes_key = ['amp','pw','freq'];
amp_data.stim_changes1 = ampc1;
amp_data.stim_changes2 = ampc2;
amp_data.stim_times1 = datc1;
amp_data.stim_times2 = datc2;
amp_data.stim_channel1 = stim_channel1;
amp_data.stim_channel2 = stim_channel2;
amp_data.ekg = ekg;
amp_data.pulse = pulse;
amp_data.ts_ekg_pulse = ts_ekg_pulse;
amp_data.clin_amp_left = left_plats(3);
amp_data.clin_amp_right = right_plats(3);
amp_data.amp_limits_left = left_plats(1:2);
amp_data.amp_limits_right = right_plats(1:2);
amp_data.channels = channels;

amp_data.EKG_HR_Estimate =denoised_EKG;
amp_data.EKG_HR_ts = ts_ekg;
amp_data.EKG_HR_Estimate =denoised_pulse;
amp_data.EKG_HR_ts = ts_pulse;


%% create analysis subdirectory
analysis_save_dir = strrep(loaddir,'PreProcessedData','AnalysisFiles');
if ~exist(analysis_save_dir)
    mkdir(analysis_save_dir)
end
save([analysis_save_dir,date,'_amplitude-analysis.mat'],'amp_data');

