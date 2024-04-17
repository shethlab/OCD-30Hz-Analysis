%% Compute Correlation for Power and speech

%% Initialize matrices/data structures and file searching

datafoldername = '/Users/sameerrajesh/Desktop/30Hz Project Data'; %Replace with your foldername

files = {[datafoldername,'/2022-09-09/AnalysisFiles/amplitude/datafile_corrected_v4.mat'],
    [datafoldername,'/2023-02-27/AnalysisFiles/amplitude/Experiment_1/datafile_corrected_v4.mat']};


R = zeros(4,6);
P = zeros(4,6);
CI = zeros(4,2,6);

raws = [1,0]; %[raw power, raw speech] as a binary; 0 == use EMA trace

%% Title Strings
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

%% File Searching
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
        fn = strrep(files{1},'2022-09-09',rep);
    else
        fn = strrep(files{2},'Experiment_1',rep);
    end
    load(fn);
    % In fill blank speech for exps where speech was not detected, if
    % necessary
    if length(pows) == 4
        pows(5).high_amp = pows(4).high_amp;
        pows(5).times = pows(4).times;
        pows(5).value = zeros(size(pows(4).times));
    end
    %% Compute and Record Correlations
    [r,p,ci] = computeCorrs(pows,raws);
    R(:,i) = r.*r;
    P(:,i) = p;
    CI(:,:,i) = ci.*ci;


end

%% Heatmap R^2 and p value

figure('Renderer', 'painters', 'Position', [10 10 2000 800],'Color','w');

subplot(1,2,1);
heatmap({'9-9-22','9-19-22','10-04-22','11-15-22','Control 1','Control 2'},{'Left OFC', 'Left vlPFC','Right OFC','Right vlPFC'},R);
title(tstrR);

subplot(1,2,2);

heatmap({'9-9-22','9-19-22','10-04-22','11-15-22','Control 1','Control 2'},{'Left OFC', 'Left vlPFC','Right OFC','Right vlPFC'},1-P); clim([0.95 1]);

title(tstrP);

%% Gather Statistics in "formt" for ease of table reporting
 
formt = {};
for i = 1:4
    for j = 1:6
        for k = 1:3
            ind1 = 3*(i-1)+k;
            ind2 = j;
            switch k
                case 1
                    formt{ind1,ind2} = num2str(R(i,j), '%.3e');
                case 2
                    formt{ind1,ind2} = num2str(P(i,j), '%.3e');
                case 3
                    formt{ind1,ind2} = strcat('[',num2str(CI(i,1,j), '%.3e'),', ',num2str(CI(i,2,j), '%.3e'),']');
            end
        end
    end
end
save([datafoldername,'/Quantification/correlations.mat'],"formt");

