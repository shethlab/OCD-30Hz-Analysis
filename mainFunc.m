%% Main Analysis Function
% Load Directory: include 4 folders labeled by date (see below file
% organization) and include analysis_v2 file and TextGrid in the folder.
directory = '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/';
correct = 1; %correct 30Hz Powers (toggle to 0 for raw power)

% Box Plot Figure Init.
figure('units','normalized','outerposition',[0 0 1 1]);
tiledlayout(5,4);
stats_mat = zeros(5,4); % Init Stats Matrix for heatmap
%% Rotate Through Dates
for i = 1:4
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
                svnspr = strrep(svn,'datafile','SPRiNT_LmOFC');
            case 2
                tlabel = strcat(datelabel,' ; Contact Left lOFC');
                tdsig = amp_data.lfp(1).combinedDataTable.TD_key3;
                t0 = amp_data.ts1(1);
                tstamps = amp_data.ts1;

                svnspr = strrep(svn,'datafile','SPRiNT_LlOFC');

            case 3
                tlabel = strcat(datelabel,' ; Contact Right mOFC');
                tdsig = amp_data.lfp(2).combinedDataTable.TD_key2;
                t0 = amp_data.ts2(1);
                tstamps = amp_data.ts2;

                svnspr = strrep(svn,'datafile','SPRiNT_RmOFC');

            case 4
                tlabel = strcat(datelabel,' ; Contact Right lOFC');
                tdsig = amp_data.lfp(2).combinedDataTable.TD_key3;
                t0 = amp_data.ts2(1);
                tstamps = amp_data.ts2;

                svnspr = strrep(svn,'datafile','SPRiNT_RlOFC');
        end
        %% Main Body
        try
            %% Nan Demean + Power Correction
            tdsig = nan_demean(tdsig); %Demean signal
            tmin = 0;
            %tmax = amp_data.DBS_high_times(2,2);
            tdsig = tdsig(tstamps>=tmin); % Chop pre-0 signal
            [pwrs,times,tf,s_data] = correctedPowers(tdsig,tmin,[28 32],correct);
            if i == 4 && j <3
                inds = find(times<265 | times>571);
                times = times(inds);
                pwrs = pwrs(inds);%Removed a Packet Loss Segment for last date left hem
            end
            save(svnspr,'s_data');
            %% Power Epoching
            powersHigh = [gatherInEpoch(pwrs,times,amp_data.DBS_high_times(1,:)); gatherInEpoch(pwrs,times,amp_data.DBS_high_times(2,:))];
            powersLow = [gatherInEpoch(pwrs,times,amp_data.DBS_low_times(1,:)); gatherInEpoch(pwrs,times,amp_data.DBS_low_times(2,:))];
            powersHighDs = downsample(powersHigh,2); % For stats, downsample for independence
            powersLowDs = downsample(powersLow,2); % For stats, downsample for independence
            %% Include low/high amp binary
            amps =zeros(1,length(times))-1;
            hiinds = find((times>=amp_data.DBS_high_times(1,1) & times<=amp_data.DBS_high_times(1,2)) | (times>=amp_data.DBS_high_times(2,1) & times<=amp_data.DBS_high_times(2,2)));
            loinds = find((times>=amp_data.DBS_low_times(1,1) & times<=amp_data.DBS_low_times(1,2)) | (times>=amp_data.DBS_low_times(2,1) & times<=amp_data.DBS_low_times(2,2)));
            amps(hiinds) = 1;
            amps(loinds) = 0; % times with amp = -1 should be excluded from analysis
            %% Box Plot
            nexttile(figpos);
            boxplot([powersHighDs;powersLowDs],[repmat({'High'},length(powersHighDs),1);repmat({'Low'},length(powersLowDs),1)]);
            title(tlabel);

            %% Stats Mat
            [~,p] = ranksum(powersHighDs,powersLowDs);
            stats_mat(j,i) = p;
        catch

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
        nexttile(figpos+4);
        boxplot([spHigh,spLow],[repmat({'High'},length(spHigh),1);repmat({'Low'},length(spLow),1)]);
        title('Speech');
        pows(5).value = wps;
        pows(5).times = tms;
        amps =zeros(1,length(tms))-1;
        hiinds = find((tms>=amp_data.DBS_high_times(1,1) & tms<=amp_data.DBS_high_times(1,2)) | (tms>=amp_data.DBS_high_times(2,1) & tms<=amp_data.DBS_high_times(2,2)));
        hiinds = find((tms>=amp_data.DBS_low_times(1,1) & tms<=amp_data.DBS_low_times(1,2)) | (tms>=amp_data.DBS_low_times(2,1) & tms<=amp_data.DBS_low_times(2,2)));
        amps(hiinds) = 1;
        amps(loinds) = 0;
        pows(5).high_amp = amps;

        %% Stats Mat
        [~,p] = ranksum(spHigh,spLow);
        stats_mat(5,i) = p;

    catch
    end
    %% Save Data in A Struct
    stimdata.lowTimes = amp_data.DBS_low_times;
    stimdata.highTimes = amp_data.DBS_high_times;
    stimdata.leftAmps = amp_data.amp_limits_left;
    stimdata.rightAmps = amp_data.amp_limits_right;
    if correct
        svn = strrep(svn,'datafile','datafile_corrected');
    end
    save(svn,'pows','stimdata');
end

%% Save Figure of boxplot and save stats mat

save(strcat(directory,'allStats.mat','stats_mat'));
saveas(gcf,strcat(directory,'BoxPlotsAll.png'));




close all




%% Heatmap of stats
heatmap({'9-9-22','9-19-22','10-04-22','11-15-22'},{'Left mOFC', 'Left lOFC','Right mOFC','Right lOFC','Speech'},1-stats_mat); clim([0.95 1]);










