%% Compute Measures of Center/Spread for 30Hz Power

%% Initialize matrices/data structures and file searching

files = {'/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/9-9-2022/datafile_corrected_v4.mat',
    '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/02-27-2023/Expt1/datafile_corrected_v4.mat'};

centerSpread = zeros(5,4,6);

ind = 1;
for i = 1:6
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
            rep = 'Expt5';
    end
    if i<5
        fn = strrep(files{1},'9-9-2022',rep);
    else
        fn = strrep(files{2},'Expt1',rep);
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

