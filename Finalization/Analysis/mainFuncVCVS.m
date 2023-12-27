%% Main Analysis Function
% Load Directory: include 4 folders labeled by date (see below file
% organization) and include analysis_v2 file and TextGrid in the folder.
directory = '/Users/sameerrajesh/Desktop/30Hz Project Data/';
correct = 1; %correct 30Hz Powers (toggle to 0 for raw power)
version = '_v4';
vers = 1;
centerf = 31;
window = 3;
frange = centerf+[-window/2,window/2];
%% Only Made VCVS Info for First Experiment
i = 1;
fn = strcat(directory,'2022-09-09/AnalysisFiles/amplitude/2022-09-09_amplitude-analysis.mat');
tg = strcat(directory,'2022-09-09/AudioData/2022-09-09_audio_amplitude.TextGrid');
svn = strcat(directory,'2022-09-09/AnalysisFiles/amplitude/vcvsdatafile.mat');

load(fn);
pows = {};

%% Rotate Through Contacts
for j = 1:2
    figpos = 2*(j-1)+i;
    datelabel = extractBetween(fn,'amplitude/','_amplitude');
    switch j
        case 1
            tlabel = strcat(datelabel,' ; Contact Left VC/VS');
            tdsig = amp_data.lfp(1).combinedDataTable.TD_key0;
            t0 = amp_data.ts1(1);
            tstamps = amp_data.ts1;
            svnspr = strrep(svn,'datafile','SPRiNT_Lvcvs');
        case 2
            tlabel = strcat(datelabel,' ; Contact Right VC/VS');
            tdsig = amp_data.lfp(2).combinedDataTable.TD_key0;
            t0 = amp_data.ts2(1);
            tstamps = amp_data.ts2;
            svnspr = strrep(svn,'datafile','SPRiNT_Rvcvs');
    end
    %% Main Body
    try
        %% Nan Demean + Power Correction
        tdsig = nan_demean(tdsig); %Demean signal
        tmin = 0;
        tdsig = tdsig(tstamps>=tmin); % Chop pre-0 signal
        [pwrs,times,tf,s_data] = correctedPowers(tdsig,tmin,frange,correct,vers);
        save(svnspr,'s_data');
        %% Include low/high amp binary
        amps = NaN(1,length(times));
        hiinds = find((times>=amp_data.DBS_high_times(1,1) & times<=amp_data.DBS_high_times(1,2)) | (times>=amp_data.DBS_high_times(2,1) & times<=amp_data.DBS_high_times(2,2)));
        loinds = find((times>=amp_data.DBS_low_times(1,1) & times<=amp_data.DBS_low_times(1,2)) | (times>=amp_data.DBS_low_times(2,1) & times<=amp_data.DBS_low_times(2,2)));
        clininds = find((times>=amp_data.DBS_clin_times(1,1) & times<=amp_data.DBS_clin_times(1,2)) );
        if amp_data.clin_amp_left == 0 && amp_data.clin_amp_right == 0
            amps(clininds) = 0;
        else
            amps(clininds) = 3;
        end
        amps(hiinds) = 1;
        amps(loinds) = 0; % times with amp = -1 should be excluded from analysis

    catch
        error; % Throw Error For Now
    end
    pows(j).value = pwrs;
    pows(j).times = times;
    pows(j).high_amp = amps;
end
try
    [wps,tms] = dbsSpeechAnalysis(tg,amp_data);
    if isempty(wps)
        wps;
    end
    spHigh = [gatherInEpoch(wps,tms,amp_data.DBS_high_times(1,:)) gatherInEpoch(wps,tms,amp_data.DBS_high_times(2,:))];
    spLow = [gatherInEpoch(wps,tms,amp_data.DBS_low_times(1,:)) gatherInEpoch(wps,tms,amp_data.DBS_low_times(2,:))];

    pows(5).value = wps;
    pows(5).times = tms;
    amps = NaN(1,length(tms));
    hiinds = find((tms>=amp_data.DBS_high_times(1,1) & tms<=amp_data.DBS_high_times(1,2)) | (tms>=amp_data.DBS_high_times(2,1) & tms<=amp_data.DBS_high_times(2,2)));
    loinds = find((tms>=amp_data.DBS_low_times(1,1) & tms<=amp_data.DBS_low_times(1,2)) | (tms>=amp_data.DBS_low_times(2,1) & tms<=amp_data.DBS_low_times(2,2)));
    clininds = find((tms>=amp_data.DBS_clin_times(end,1) & tms<=amp_data.DBS_clin_times(end,2)) );
    if amp_data.clin_amp_left == 0 && amp_data.clin_amp_right == 0
        amps(clininds) = 0;
    else
        amps(clininds) = 3;
    end
    amps(hiinds) = 1;
    amps(loinds) = 0; % times with amp = -1 should be excluded from analysis
    pows(5).high_amp = amps;


catch
    error; %Throw Error For Now;
end
%% Save Data in A Struct
stimdata.lowTimes = amp_data.DBS_low_times;
stimdata.highTimes = amp_data.DBS_high_times;
stimdata.clinTimes = amp_data.DBS_clin_times;
stimdata.leftAmps = amp_data.amp_limits_left;
stimdata.rightAmps = amp_data.amp_limits_right;
stimdata.clinLeft = amp_data.clin_amp_left;
stim_data.clinRight = amp_data.clin_amp_right;
if correct
    svn = strrep(svn,'datafile','datafile_corrected');
end
svnfin = strrep(svn,'.mat',strcat(version,'.mat'));
save(svnfin,'pows','stimdata');
close all








