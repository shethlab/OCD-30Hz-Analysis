%% Compute Statistics for High vs Low Amplitude

%% Initialize matrices/data structures and file searching

centerFreqs = zeros(2,6);
filesLeft = {'/Users/sameerrajesh/Desktop/30Hz Project Data/2022-09-09/AnalysisFiles/amplitude/2022-09-09_PSD-data_Left.mat','/Users/sameerrajesh/Desktop/30Hz Project Data/2023-02-27/AnalysisFiles/amplitude/Experiment_1/2023-02-27_PSD-data_Left.mat'};
filesRight = {'/Users/sameerrajesh/Desktop/30Hz Project Data/2022-09-09/AnalysisFiles/amplitude/2022-09-09_PSD-data_Right.mat','/Users/sameerrajesh/Desktop/30Hz Project Data/2023-02-27/AnalysisFiles/amplitude/Experiment_1/2023-02-27_PSD-data_Right.mat'};

for i = 1:6
    switch i
        case 1
            rep = '2022-09-09';        
        case 2
            rep = '2022-09-19';
        case 3
            rep = '2022-10-04';
        case 4
            rep = '2022-11-15';
        case 5
            rep = 'Experiment_1';
        case 6
            rep = 'Experiment_2';

    end
    if i<5
        fn = {strrep(filesLeft{1},'2022-09-09',rep),strrep(filesRight{1},'2022-09-09',rep)};
    else
        fn = {strrep(filesLeft{2},'Experiment_1',rep),strrep(filesRight{2},'Experiment_1',rep)};
    end
    %% Load file
    for f=1:2
        load(fn{f});
        inds = find(f1>=28 & f1<=34);
        if i == 4 && f == 1
            [~,val2] = max(high2(inds,4));
            centerFreqs(f,i) = f1(inds(val2));
        else
            [~,val1] = max(high1(inds,4));
            [~,val2] = max(high2(inds,4));
            centerFreqs(f,i) = mean([f1(inds(val1)),f1(inds(val2))]);    
        end
    end
end

%% Heatmap statisics
