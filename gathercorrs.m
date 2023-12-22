formt = {};
for i = 1:4
    for j = 1:8
        for k = 1:2
            ind1 = 2*(i-1)+k;
            ind2 = j;
            switch k
                case 1
                    formt{ind1,ind2} = num2str(R(i,j), '%.3e');
                case 2
                    formt{ind1,ind2} = num2str(P(i,j), '%.3e');
            end
        end
    end
end
