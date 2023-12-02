function signdm = nan_demean(sig)
signdm = sig - mean(sig,'omitnan');
signdm(isnan(signdm)) = 0;
end