tvec = [0,10,25,67];
locs = {'Left OFC','Left vlPFC','Right OFC','Right vlPFC'};
t = tiledlayout(2,2);
cols = [31 195 255;251 86 59]/255;
for i = 1:4
    h = 4*(i-1)+1;
    l = h+2;
    nexttile;
    hold on;
    for j = 1:2
        switch j
            case 1
                ind = l;
            case 2
                ind = h;
        end
        col = cols(j,:);
        x = [tvec,fliplr(tvec)];
        y = [formt{ind,1:4}];
        curve1 = y+[formt{ind+1,1:4}];
        curve2 = y-[formt{ind+1,1:4}];
        inB = [curve1 fliplr(curve2)];
        fill(x,inB,col,'FaceAlpha',0.2);
        plot(tvec,y,"Color",col);
    end
    title(locs{i});
end


