function start_stop_inds = get_start_stop_inds(ts1,ts2,DBS_times)
    start_stop_inds = cell(size(DBS_times));
    for i = 1:size(DBS_times,1)
        inds1 = find(and(ts1>DBS_times(i,1), ts1<DBS_times(i,2)));
        start_stop_inds{i,1} = [inds1(1),inds1(end)]';
        inds2 = find(and(ts2>DBS_times(i,1), ts2<DBS_times(i,2)));
        start_stop_inds{i,2} = [inds2(1),inds2(end)]';
        
    end
end