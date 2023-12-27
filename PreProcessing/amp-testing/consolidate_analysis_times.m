function DBS_times = consolidate_analysis_times(start_times1,start_times2,end_times1,end_times2)
    DBS_times = zeros(length(start_times1),2);
    for i = 1:length(start_times1)
        if start_times1(i) > start_times2(i)
            DBS_times(i,1) = start_times1(i);
        else
            DBS_times(i,1) = start_times2(i);
        end
        if end_times1(i) < end_times2(i)
            DBS_times(i,2) = end_times1(i);
        else
            DBS_times(i,2) = end_times2(i);
        end
    end
end