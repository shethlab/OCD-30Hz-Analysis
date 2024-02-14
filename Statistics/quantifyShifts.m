allshifts = [];

datafoldername = '/Users/sameerrajesh/Desktop/30Hz Project Data'; %Replace with your foldername
for i = [1,3:6]
    switch i
        case 1
            fns = {[datafoldername,'/2022-09-09/PreProcessedData/amplitude/aDBS012_amplitude_20220909172125316129_synced_ephys_behav_lfp_v3.mat'],
                [datafoldername,'/2022-09-09/PreProcessedData/amplitude/aDBS012_amplitude_20220909172125316129_toggle_harmonized_behav_ephys_LFP_v2.mat']};
        case 3
            fns = {[datafoldername,'/2022-10-04/PreProcessedData/amplitude/aDBS012_amplitude_20221004135333673973_synced_ephys_behav_lfp_v3.mat'],
                [datafoldername,'/2022-10-04/PreProcessedData/amplitude/aDBS012_amplitude_20221004135333673973_toggle_harmonized_behav_ephys_LFP_v2.mat']};
        case 4
            fns = {[datafoldername,'/2022-11-15/PreProcessedData/amplitude/aDBS012_amplitude_20221115141549597100_synced_ephys_behav_lfp_v3.mat'],
                [datafoldername,'/2022-11-15/PreProcessedData/amplitude/aDBS012_amplitude_20221115141549597100_toggle_harmonized_behav_ephys_LFP_v2.mat']};
        case 5
            fns = {[datafoldername,'/2023-02-27/PreProcessedData/amplitude/Experiment_1/aDBS012_amplitude_20230227153204931786_synced_ephys_behav_lfp_v3.mat'],
               [datafoldername,'/2023-02-27/PreProcessedData/amplitude/Experiment_1/aDBS012_amplitude_20230227153204931786_toggle_harmonized_behav_ephys_LFP_v2.mat']};
        case 6
            fns = {[datafoldername,'/2023-02-27/PreProcessedData/amplitude/Experiment_2/aDBS012_amplitude_20230227162649255911_synced_ephys_behav_lfp_v3.mat'],
                [datafoldername,'/2023-02-27/PreProcessedData/amplitude/Experiment_2/aDBS012_amplitude_20230227162649255911_toggle_harmonized_behav_ephys_LFP_v2.mat']};
    end

    load(fns{1});
    old = lfpData;
    load(fns{2});
    indS1 = find(cellfun(@(x)strcmp(x,'S  1'),[toggle_sync.UDT_harmonized_events.Event]));
    eegshift = data.behavior.behav_start_timestamp_unix-toggle_sync.UDT_harmonized_events{indS1,2};
    allshifts = [allshifts eegshift];

    if i ~= 1 && i ~=6
        rhshift = old(2).unifiedDerivedTimes(1)-lfpData(2).unifiedDerivedTimes(1);
        allshifts = [allshifts rhshift];

    end
end





