files = {'/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/9-9-2022/datafile_corrected_v1.mat',
          '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/02-27-2023/Expt1/datafile_corrected_v1.mat'};

statsmat = zeros(5,8);


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
        sm = computeStats(pows,1);
        statsmat(:,i) = sm;
    
end

%%
figure('Renderer', 'painters', 'Position', [10 10 2000 800],'Color','w');


    heatmap({'9-9-22','9-19-22','10-04-22','11-15-22','Control 1','Control 2','Control 3','Control 4'},{'Left mOFC', 'Left lOFC','Right mOFC','Right lOFC','Speech'},1-statsmat); clim([0.95 1]);
    title(strcat('Version: ',string(i)));


