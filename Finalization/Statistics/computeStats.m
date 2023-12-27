function statsmat = computeStats(pows,version)
statsmat.p = zeros(5,1);
statsmat.ci = zeros(5,2);
statsmat.tstat = zeros(5,1);
statsmat.sampsz = zeros(5,2);

%% Only Version 1 is Available Publically
if version == 1
    for i = 1:5

        hamp = pows(i).high_amp;
        val = pows(i).value;
        hvals = val(hamp==1);
        lvals = val(hamp==0);
        [~,p,ci,stats] = ttest2(hvals,lvals);
        statsmat.p(i) = p;
        statsmat.ci(i,:) = ci;
        statsmat.tstat(i) = stats.tstat;
        statsmat.sampsz(i,:) = [length(lvals),length(hvals)];
    end

end

end