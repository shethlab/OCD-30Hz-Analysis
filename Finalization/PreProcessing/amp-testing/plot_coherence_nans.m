function ax = plot_coherence_nans(td1,td2,channels,amp_data,subject_id,date,loaddir)

chL = demean_removeNaNs(td1,1,0);
tsL = (1/500):(1/500):(length(chL{1})/500);
chR = demean_removeNaNs(td2,1,0);
tsR = (1/500):(1/500):(length(chR{1})/500);

% L1, H1, L2, H2, C1
% channel_pairs = [chL(:,1),chR(:,1);... 1 5
%                  chL(:,1),chL(:,3);... 1 3
%                  chR(:,1),chR(:,3);... 5 7
%                  chL(:,1),chL(:,4);... 1 4
%                  chR(:,1),chR(:,4);... 5 8
%                  chL(:,3),chL(:,4);... 3 4
%                  chR(:,3),chR(:,4)];   7 8

ts1 = amp_data.ts1;
ts2 = amp_data.ts2;
start_stop_inds_low = get_start_stop_inds(ts1,ts2,amp_data.DBS_low_times);
start_stop_inds_high = get_start_stop_inds(ts1,ts2,amp_data.DBS_high_times);
start_stop_inds_clin = get_start_stop_inds(ts1,ts2,amp_data.DBS_clin_times);

% put all td data into 4x2 cell 
ch = [chL,chR];
% inputs: all td data, channel combos, channels, 
combo_all = [1 5; 1 3; 1 4; 5 7; 5 8; 3 4; 7 8];
for i = 1:length(combo_all)
    combo = combo_all(i,:);
    fn = coherence_plots(ch,channels,combo,start_stop_inds_low,start_stop_inds_high,start_stop_inds_clin);
    saveas(gcf,[loaddir,subject_id,'_',date,'_',fn,'.png']);
    close all
end





end

