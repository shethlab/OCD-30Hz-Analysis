function trial_inds_all = get_trial_inds(ts,DBS_times,dat,trial_length_samples)
trial_inds_all = cell(size(DBS_times,1),1);
for i = 1:size(DBS_times,1)
    inds1 = find(and(ts>DBS_times(i,1), ts<DBS_times(i,2)));
    start_inds = [inds1(1):trial_length_samples:inds1(end)]';
    end_inds = [start_inds(2)-1:trial_length_samples:inds1(end)]';
    start_inds(end) = [];
    trial_inds = [start_inds,end_inds];
    drop_trials = [];
    for j = 1:size(trial_inds,1)
        dat_temp = dat.TD_key0(trial_inds(j,1):trial_inds(j,2));
        contains_nans = any(isnan(dat_temp));
        if contains_nans
            drop_trials = [drop_trials;j];
        end
    end
    trial_inds(drop_trials,:) = [];
    trial_inds_all{i} = trial_inds;

end
end