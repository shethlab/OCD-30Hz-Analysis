function statsmat = computeStats(pows,version)
statsmat = zeros(5,1);
if version == 1
    for i = 1:5

        hamp = pows(i).high_amp;
        val = pows(i).value;
        hvals = val(hamp==1);
        lvals = val(hamp==0);
        [h,p] = ttest2(hvals,lvals);
        statsmat(i) = p;
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
        [h,p] = ttest2(hvals,lvals);
        statsmat(i) = p;
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
        [h,p] = ttest2(hvals,lvals);
        statsmat(i) = p;






    end









end