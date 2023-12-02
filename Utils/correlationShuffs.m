function r2 = correlationShuffs(vec1,vec2,shufflecount)

r2 = zeros(1,shufflecount);

for i = 1:shufflecount
    if i>1
        vec1 = vec1(randperm(length(vec1)));
        vec2 = vec2(randperm(length(vec2)));
    end
    rs = corrcoef(vec1,vec2);
    r2(i) = rs(1,2)^2;
end



end