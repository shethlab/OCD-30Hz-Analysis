%% Compute Statistics for High vs Low Amplitude

%% Initialize matrices/data structures and file searching

datafoldername = '/Users/sameerrajesh/Desktop/30Hz Project Data'; %Replace with your foldername

files = {[datafoldername,'/2022-09-09/AnalysisFiles/amplitude/datafile_corrected_v4.mat'],
    [datafoldername,'/2023-02-27/AnalysisFiles/amplitude/Experiment_1/datafile_corrected_v4.mat']};

statsmat = zeros(5,6);
tmat = zeros(5,6);
cmat = zeros(5,2,6);
nmat = zeros(5,2,6);
effmat = zeros(5,6);
dofmat = zeros(5,6);

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
    %% Load file
    load(fn);
    % In fill blank speech for exps where speech was not detected, if
    % necessary
    if length(pows) == 4
        pows(5).high_amp = pows(4).high_amp;
        pows(5).times = pows(4).times;
        pows(5).value = zeros(size(pows(4).times));
    end

    %% Compute and record statistics
    sm = computeStats(pows,1);
    statsmat(:,i) = sm.p;
    tmat(:,i) = sm.tstat;
    cmat(:,:,i) = sm.ci;
    nmat(:,:,i) = sm.sampsz;
    effmat(:,i) = sm.effectSize;
    dofmat(:,i) = sm.dof;

end

%% Heatmap statisics
figure('Renderer', 'painters', 'Position', [10 10 2000 800],'Color','w');
heatmap({'9-9-22','9-19-22','10-04-22','11-15-22','Control 1','Control 2'},{'Left OFC', 'Left vlPFC','Right OFC','Right vlPFC','Speech'},1-statsmat); clim([0.95 1]);
title(strcat('Version: ',string(i)));

%% Gather Statistics in "formt" for ease of table reporting
formt = {};
order = {'p-value','t-stat','CI','DF','Cohen','SampSz'};
for i = 1:5
    for j = 1:6
        for k = 1:6
            ind1 = 6*(i-1)+k;
            ind2 = j;
            switch k
                case 1
                    if statsmat(i,j) < 0.01
                        pwr10 = ceil(log10(statsmat(i,j)));
                        formt{ind1,ind2} = ['<10^',num2str(pwr10)];
                    else
                        formt{ind1,ind2} = num2str(statsmat(i,j), '%.3f');
                    end
                case 2
                    formt{ind1,ind2} = num2str(tmat(i,j), '%.3f');
                case 3
                    formt{ind1,ind2} = strcat('[',num2str(cmat(i,1,j), '%.3f'),', ',num2str(cmat(i,2,j), '%.3f'),']');
                case 6 %SS last
                    formt{ind1,ind2} = strcat('[',num2str(nmat(i,1,j)),', ',num2str(nmat(i,2,j)),']');
                case 5
                    formt{ind1,ind2} = num2str(effmat(i,j), '%.3f');
                case 4
                    formt{ind1,ind2} = num2str(dofmat(i,j), '%.3f');
            end
        end
    end
end

save([datafoldername,'/Quantification/statistics.mat'],"formt");




