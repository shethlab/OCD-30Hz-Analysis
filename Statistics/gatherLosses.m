allLosses = {};
allTimes = {};
directory = '/Users/sameerrajesh/Desktop/30Hz Project Data/';

for i = 1:6
    switch i
        case 1
            fn = strcat(directory,'2022-09-09/AnalysisFiles/amplitude/2022-09-09_amplitude-analysis.mat');
        case 2
            fn = strcat(directory,'2022-09-19/AnalysisFiles/amplitude/2022-09-19_amplitude-analysis.mat');
        case 3
            fn = strcat(directory,'2022-10-04/AnalysisFiles/amplitude/2022-10-04_amplitude-analysis.mat');
        case 4
            fn = strcat(directory,'2022-11-15/AnalysisFiles/amplitude/2022-11-15_amplitude-analysis.mat');
        case 5
            fn = strcat(directory,'2023-02-27/AnalysisFiles/amplitude/Experiment_1/2023-02-27_amplitude-analysis.mat');
        case 6
            fn = strcat(directory,'2023-02-27/AnalysisFiles/amplitude/Experiment_2/2023-02-27_amplitude-analysis.mat');
    end
    load(fn);
    s = findLosses(amp_data.lfp,amp_data.ts1,amp_data.ts2,amp_data.DBS_low_times(1,1),amp_data.DBS_clin_times(end,end),500);
    allLosses{1,i} = s(1).lostPacketLengths;
    allLosses{2,i} = s(2).lostPacketLengths;
    allTimes{i} = amp_data.DBS_clin_times(end,end) - amp_data.DBS_low_times(1,1);
end

%% Loss Info Summary (format nicely)

allLeftLosses = cell2mat([allLosses{1,:}]);
adjAllLeftLosses = allLeftLosses(allLeftLosses<10);
allRightLosses = cell2mat([allLosses{2,:}]);
adjallRightLosses = allRightLosses(allRightLosses<10);
allTime = sum([allTimes{:}]);


lossInfo(1,1) = mean(adjAllLeftLosses);
lossInfo(1,2) = std(adjAllLeftLosses);
lossInfo(2,1) = mean(adjallRightLosses);
lossInfo(2,2) = std(adjallRightLosses);

lossPerc(1) = sum(adjAllLeftLosses)/allTime;
lossPerc(2) = sum(adjallRightLosses)/allTime;

