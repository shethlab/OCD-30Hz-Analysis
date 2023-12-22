files = {'/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/9-9-2022/datafile_corrected_v4.mat',
    '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/02-27-2023/Expt1/datafile_corrected_v4.mat'};

R = zeros(4,8);
P = zeros(4,8);

raws = [1,0];

if raws(1) == 1
    addend1 = ' Power (Raw)';
else
    addend1 = ' Power (EMA, 10 sample window)';
end

if raws(2) == 1
    addend2 = ' Speech (Raw)';
else
    addend2 = ' Speech (EMA, 5 sample window)';
end

tstrR = strcat('R values for Correlation of ',addend1,' and ',addend2);
tstrP = strcat('P values for Correlation of ',addend1,' and ',addend2);
for i = 1:8
    switch i
        case 1
            rep = '9-9-2022';
        case 2
            rep = '9-19-2022';
        case 3
            rep = '10-04-2022';
        case 4
            rep = '11-15-2022';
        case 5
            rep = 'Expt1';
        case 6
            rep = 'Expt2';
        case 7
            rep = 'Expt4';
        case 8
            rep = 'Expt5';

    end
    if i<5
        fn = strrep(files{1},'9-9-2022',rep);
    else
        fn = strrep(files{2},'Expt1',rep);
    end
    load(fn);
    if length(pows) == 4
        pows(5).high_amp = pows(4).high_amp;
        pows(5).times = pows(4).times;
        pows(5).value = zeros(size(pows(4).times));
    end

    [r,p] = computeCorrs(pows,raws);
    R(:,i) = r.*r;
    P(:,i) = p;


end

%%

figure('Renderer', 'painters', 'Position', [10 10 2000 800],'Color','w');

subplot(1,2,1);
heatmap({'9-9-22','9-19-22','10-04-22','11-15-22','Control 1','Control 2','Control 3','Control 4'},{'Left OFC', 'Left vlPFC','Right OFC','Right vlPFC'},R);
title(tstrR);

%%

%figure('Renderer', 'painters', 'Position', [10 10 2000 800],'Color','w');

subplot(1,2,2);

heatmap({'9-9-22','9-19-22','10-04-22','11-15-22','Control 1','Control 2','Control 3','Control 4'},{'Left OFC', 'Left vlPFC','Right OFC','Right vlPFC'},1-P); clim([0.95 1]);

title(tstrP);


