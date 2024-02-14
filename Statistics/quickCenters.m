%% Compute Measures of Center/Spread for 30Hz Power

%% Initialize matrices/data structures and file searching
datafoldername = '/Users/sameerrajesh/Desktop/30Hz Project Data'; %Replace with your foldername

files = {[datafoldername,'/2022-09-09/AnalysisFiles/amplitude/datafile_corrected_v4.mat'],
    [datafoldername,'/2023-02-27/AnalysisFiles/amplitude/Experiment_1/datafile_corrected_v4.mat']};

centerSpread = zeros(5,4,6);

ind = 1;
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
    cS = computeCentSpread(pows);
    centerSpread(:,:,i) = cS;
end

%% Gather Values in "formt" for ease of table reporting

formt = {};
for i = 1:4
    for j = 1:6
        for k = 1:4
            ind1 = 4*(i-1)+k;
            ind2 = j;
            formt{ind1,ind2} = centerSpread(i,k,j);
        end
    end
end

save([datafoldername,'/Quantification/measuresOfCenter.mat'],"formt");