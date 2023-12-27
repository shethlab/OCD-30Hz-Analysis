function missingPackets = findLosses(lfp,ts1,ts2,start,stop,fs)

missingPackets = {};
for i = 1:2
    if i == 1
        ts = ts1;
    else
        ts = ts2;
    end
    inds = find(ts>=start & ts<=stop);
    ind1 = inds(1);
    ind2 = inds(end);
    packetLossInfo = lfp(i).packetloss.indiv_times_idx_perc;
    pls = {};
    count = 1;
    for j = 1:height(packetLossInfo)
        indscurr = packetLossInfo.index{j};
        indscurr = indscurr(indscurr>=ind1 & indscurr<=ind2);
        if length(indscurr)>0
            pls{count} = length(indscurr)/fs;
                    count = count+1;

        end
    end
    missingPackets(i).lostPacketLengths = pls;
end



