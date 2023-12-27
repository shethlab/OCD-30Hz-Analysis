formt = {};
for i = 1:4
    for j = 1:6
        for k = 1:4
            ind1 = 4*(i-1)+k;
            ind2 = j;
            formt{ind1,ind2} = centerSpread(i,k,j);%num2str(centerSpread(i,k,j), '%.3f');
        end
    end
end
