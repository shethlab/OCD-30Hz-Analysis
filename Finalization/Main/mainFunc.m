%% Main Analysis Function
% Load Directory: include 4 folders labeled by date (see below file
% organization) and include analysis_v2 file and TextGrid in the folder.
close all
directory = '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/';

%% User Inputs
correct = 1; %correct 30Hz Powers (toggle to 0 for raw power)
version = '_v4';
centerf = 31;
window = 3;
frange = centerf+[-window/2,window/2];

%% Rotate Through Dates
for i = 1:6
    switch i
        case 1
            fn = strcat(directory,'9-9-2022/aDBS012_2022-09-09_amplitude-analysis_v2.mat');
            tg = strcat(directory,'9-9-2022/aDBS012_2022-09-09_audio_amplitude.TextGrid');
            svn = strcat(directory,'9-9-2022/datafile.mat');
        case 2
            fn = strcat(directory,'9-19-2022/aDBS012_2022-09-19_amplitude-analysis_v2.mat');
            tg = strcat(directory,'9-19-2022/aDBS012_2022-09-19_audio_amplitude.TextGrid');
            svn = strcat(directory,'9-19-2022/datafile.mat');
        case 3
            fn = strcat(directory,'10-04-2022/aDBS012_2022-10-04_amplitude-analysis_v2.mat');
            tg = strcat(directory,'10-04-2022/aDBS012_2022_10_04_audio_amplitude.TextGrid');
            svn = strcat(directory,'10-04-2022/datafile.mat');
        case 4
            fn = strcat(directory,'11-15-2022/aDBS012_2022-11-15_amplitude-analysis_v2.mat');
            tg = strcat(directory,'11-15-2022/aDBS012_2022-11-15_audio_amplitude.TextGrid');
            svn = strcat(directory,'11-15-2022/datafile.mat');
        case 5
            fn = strcat(directory,'02-27-2023/Expt1/aDBS012_2023-02-27_amplitude-analysis_v2.mat');
            tg = strcat(directory,'02-27-2023/Expt1/Experiment1.TextGrid');
            svn = strcat(directory,'02-27-2023/Expt1/datafile.mat');
        case 6
            fn = strcat(directory,'02-27-2023/Expt5/aDBS012_2023-02-27_amplitude-analysis_v2.mat');
            tg = strcat(directory,'02-27-2023/Expt5/Experiment5.TextGrid');
            svn = strcat(directory,'02-27-2023/Expt5/datafile.mat');
    end
    load(fn);
    pows = {};

    %% Rotate Through Contacts
    for j = 1:4
        figpos = 4*(j-1)+i;
        datelabel = extractBetween(fn,'aDBS012_','_amplitude');
        switch j
            case 1
                tlabel = strcat(datelabel,' ; Contact Left mOFC');
                tdsig = amp_data.lfp(1).combinedDataTable.TD_key2;
                t0 = amp_data.ts1(1);
                tstamps = amp_data.ts1;
                svnspr = strrep(svn,'datafile',strcat('SPRiNT_LmOFC',version));
            case 2
                tlabel = strcat(datelabel,' ; Contact Left lOFC');
                tdsig = amp_data.lfp(1).combinedDataTable.TD_key3;
                t0 = amp_data.ts1(1);
                tstamps = amp_data.ts1;
                svnspr = strrep(svn,'datafile',strcat('SPRiNT_LlOFC',version));

            case 3
                tlabel = strcat(datelabel,' ; Contact Right mOFC');
                tdsig = amp_data.lfp(2).combinedDataTable.TD_key2;
                t0 = amp_data.ts2(1);
                tstamps = amp_data.ts2;
                svnspr = strrep(svn,'datafile',strcat('SPRiNT_RmOFC',version));

            case 4
                tlabel = strcat(datelabel,' ; Contact Right lOFC');
                tdsig = amp_data.lfp(2).combinedDataTable.TD_key3;
                t0 = amp_data.ts2(1);
                tstamps = amp_data.ts2;
                svnspr = strrep(svn,'datafile',strcat('SPRiNT_RlOFC',version));
                
        end
        %% Main Body
        try
            %% Nan Demean + Power Correction
            tdsig = nan_demean(tdsig); %Demean signal
            tmin = 0;
            tdsig = tdsig(tstamps>=tmin); % Chop pre-0 signal
            if strcmp(version,'_v4') %this calculates the max power as opposed to mean power
                [pwrs,times,tf,s_data] = correctedPowers(tdsig,tmin,frange,correct,1);
            else
                [pwrs,times,tf,s_data] = correctedPowers(tdsig,tmin,frange,correct,0);
            end
            if i == 4 && j <3 
                inds = find(times<265 | times>571); %times for the packet loss, hard coded
                times = times(inds);
                pwrs = pwrs(inds);%Removed a Packet Loss Segment for 4th date left hem
            end
            save(svnspr,'s_data');

            %% Include low/high amp binary
            amps = NaN(1,length(times));
            hiinds = find((times>=amp_data.DBS_high_times(1,1) & times<=amp_data.DBS_high_times(1,2)) | (times>=amp_data.DBS_high_times(2,1) & times<=amp_data.DBS_high_times(2,2)));
            loinds = find((times>=amp_data.DBS_low_times(1,1) & times<=amp_data.DBS_low_times(1,2)) | (times>=amp_data.DBS_low_times(2,1) & times<=amp_data.DBS_low_times(2,2)));
            clininds = find((times>=amp_data.DBS_clin_times(1,1) & times<=amp_data.DBS_clin_times(1,2)) );
            if (amp_data.clin_amp_left == 0 && amp_data.clin_amp_right == 0) | i == 5
                amps(clininds) = 0;
            else
                amps(clininds) = 3;
            end
            amps(hiinds) = 1;
            amps(loinds) = 0; % times with amp = nan should be excluded from analysis            
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
        if (amp_data.clin_amp_left == 0 && amp_data.clin_amp_right == 0) | i == 5
            amps(clininds) = 0;
        else
            amps(clininds) = 3;
        end
        amps(hiinds) = 1;
        amps(loinds) = 0; % times with amp = nan should be excluded from analysis
        pows(5).high_amp = amps;
       

    catch
        error; % Throw Error For Now
    end
    %% Save Data in A Struct
    stimdata.lowTimes = amp_data.DBS_low_times;
    stimdata.highTimes = amp_data.DBS_high_times;
    stimdata.clinTimes = amp_data.DBS_clin_times;
    stimdata.leftAmps = amp_data.amp_limits_left;
    stimdata.rightAmps = amp_data.amp_limits_right;
    stimdata.clinLeft = amp_data.clin_amp_left;
    stimdata.clinRight = amp_data.clin_amp_right;
    if correct
        svn = strrep(svn,'datafile','datafile_corrected');
    end
    svnfin = strrep(svn,'.mat',strcat(version,'.mat'));
    save(svnfin,'pows','stimdata');
end
close all











