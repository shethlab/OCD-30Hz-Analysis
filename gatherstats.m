formt = {};
for i = 1:5
    for j = 1:8
        for k = 1:4
            ind1 = 4*(i-1)+k;
            ind2 = j;
            switch k
                case 1
                    formt{ind1,ind2} = num2str(statsmat(i,j), '%.3e');
                case 2
                    formt{ind1,ind2} = num2str(tmat(i,j), '%.3f');
                case 3
                    formt{ind1,ind2} = strcat('[',num2str(cmat(i,1,j), '%.3f'),', ',num2str(cmat(i,2,j), '%.3f'),']');
                case 4
                    formt{ind1,ind2} = strcat('[',num2str(nmat(i,1,j)),', ',num2str(nmat(i,2,j)),']');
            end
        end
    end
end
