files = {'/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/9-9-2022/datafile_corrected_v1.mat',
         '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/9-9-2022/datafile_corrected_v2.mat',
         '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/9-9-2022/datafile_corrected_v3.mat'};

statsmat = {};
statsmat(1).sm = zeros(5,4);
statsmat(2).sm = zeros(5,4);
statsmat(3).sm = zeros(5,4);

for i = 1:4
    switch i
        case 1
            rep = '9-9-2022';
        case 2
            rep = '9-19-2022';
        case 3
            rep = '10-04-2022';
        case 4
            rep = '11-15-2022';
    end
    for j = 1:3
        fn = strrep(files{j},'9-9-2022',rep);
        load(fn);
        sm = computeStats(pows,j);
        statsmat(j).sm(:,i) = sm;
    end
end

%%
figure('Renderer', 'painters', 'Position', [10 10 2000 800],'Color','w');
t = tiledlayout(2,2);
for i = 1:3
    nexttile

    heatmap({'9-9-22','9-19-22','10-04-22','11-15-22'},{'Left mOFC', 'Left lOFC','Right mOFC','Right lOFC','Speech'},1-statsmat(i).sm); clim([0.95 1]);
    title(strcat('Version: ',string(i)));
end

