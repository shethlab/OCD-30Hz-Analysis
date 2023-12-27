function cS = computeCentSpread(pows,version)
cS = zeros(5,4);
if version == 1
    for i = 1:5

        hamp = pows(i).high_amp;
        val = pows(i).value;
        hvals = val(hamp==1);
        lvals = val(hamp==0);
        cS(i,1) = mean(hvals);
        cS(i,2) = std(hvals);
        cS(i,3) = mean(lvals);
        cS(i,4) = std(lvals);
    end

end

end