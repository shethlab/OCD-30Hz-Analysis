function powersEpoch = gatherInEpoch(powers,times,borders)

inds = find(times>=borders(1)+5 & times<=borders(2)-5);
powersEpoch = powers(inds);

end