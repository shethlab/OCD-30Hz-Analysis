%% Get Indices of High/Low periods
function trial_inds_all = get_trial_inds_keep_nans(ts,DBS_times)
trial_inds_all = cell(size(DBS_times,1),1);
for i = 1:size(DBS_times,1)
    inds1 = find(and(ts>DBS_times(i,1), ts<DBS_times(i,2)));
        start_inds = inds1(1);
        end_inds = inds1(end);
        trial_inds = [start_inds,end_inds];  
        trial_inds_all{i} = trial_inds;
end
end