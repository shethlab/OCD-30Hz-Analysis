function new_inds = remove_inds(inds)
new_inds = inds;
evens = inds(find(mod(inds,2) ==0));


for i = 1:length(evens)
    if ~(ismember(inds,evens(i)-1) | ismember(inds,evens(i)+1))
        evens(i) = NaN;
    end


    new_inds = setdiff(inds,evens);
end