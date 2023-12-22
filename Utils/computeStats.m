function statsmat = computeStats(pows,version)
statsmat.p = zeros(5,1);
statsmat.ci = zeros(5,2);
statsmat.tstat = zeros(5,1);
statsmat.sampsz = zeros(5,2);
if version == 1
    for i = 1:5

        hamp = pows(i).high_amp;
        val = pows(i).value;
        hvals = val(hamp==1);
        lvals = val(hamp==0);
        [h,p,ci,stats] = ttest2(hvals,lvals);
        statsmat.p(i) = p;
        statsmat.ci(i,:) = ci;
        statsmat.tstat(i) = stats.tstat;
        statsmat.sampsz(i,:) = [length(lvals),length(hvals)];
    end
elseif version == 2
    for i = 1:5
        if i<5
            keep = ones(1,length(pows(i).high_amp));
            for j = 4:length(keep)-3
                if (pows(i).high_amp(j) ~= pows(i).high_amp(j-3)) | pows(i).high_amp(j) ~= pows(i).high_amp(j+3)
                    keep(j) = 0;
                end
            end
            keep = find(keep);
            hamp = pows(i).high_amp(keep);
            val = pows(i).value(keep);
        else
            hamp = pows(i).high_amp;
            val = pows(i).value;
        end
        hvals = val(hamp==1);
        lvals = val(hamp==0);
        [h,p,ci,stats] = ttest2(hvals,lvals);
        statsmat.p(i) = p;
        statsmat.ci(i,:) = ci;
        statsmat.tstat(i) = stats.tstat;
        statsmat.sampsz(i,:) = [length(lvals),length(hvals)];

    end






elseif version == 3
    for i = 1:5
        if i<5
            keep = ones(1,length(pows(i).high_amp));

            for j = 9:length(keep)-8
                if (pows(i).high_amp(j) ~= pows(i).high_amp(j-8)) | pows(i).high_amp(j) ~= pows(i).high_amp(j+8)
                    keep(j) = 0;
                end
            end
            keep = find(keep);
            hamp = pows(i).high_amp(keep);
            val = pows(i).value(keep);
        else
            hamp = pows(i).high_amp;
            val = pows(i).value;
        end
        hvals = val(hamp==1);
        lvals = val(hamp==0);
        [h,p,ci,stats] = ttest2(hvals,lvals);
        statsmat.p(i) = p;
        statsmat.ci(i,:) = ci;
        statsmat.tstat(i) = stats.tstat;
        statsmat.sampsz(i,:) = [length(lvals),length(hvals)];







    end









end