function [datc,ampc] = plot_stim_settings(x,fs,dat2,task_start,task_end,hem)
% takes in stim_log_settings =x, and fs
% outputs time array and amp, pw, and hz
stim_local_times = ((x.HostUnixTime)-task_start)/1000;

amp = str2num(char(extractBetween(x.stimParams_prog1,', ','mA')));
pw = str2num(char(extractBetween(x.stimParams_prog1,'mA, ','us')));
hz = str2num(char(extractBetween(x.stimParams_prog1,'us, ','Hz')));

therapy_status = x.therapyStatus;
for i = 1:length(therapy_status)
    if therapy_status(i)==0
        amp(i)=nan;
    else
    end
end

%% make continuous
ampc = nan(2*length(amp),3);
datc = nan(2*length(amp),1);
for i = 1:length(amp)
    ind = (2*(i-1)+1):((2*(i-1)+2));

    if i ~= (length(amp))
        datc(ind(1),1) = stim_local_times(i);
        datc(ind(2),1) = stim_local_times(i+1)-(1/fs);
        temp_amp = amp(i);
        ampc(ind,1) = [amp(i);amp(i)];
        ampc(ind,2) = [pw(i);pw(i)];
        ampc(ind,3) = [hz(i);hz(i)];

    else
        datc(ind(1),1) = stim_local_times(i);
        datc(ind(2),1) = (dat2.DerivedTime(end)-dat2.DerivedTime(1))/1000;
        ampc(ind,1) = [amp(end);amp(end)];
        ampc(ind,2) = [pw(end);pw(end)];
        ampc(ind,3) = [hz(end);hz(end)];
    end
end

% take last stim parameter before task started and replace time with time 0
replace_times_i = find(datc<0);
replace_times_i = replace_times_i(end);
ampc(1:(replace_times_i-1),:) = [];
datc(1:(replace_times_i-1)) = [];
datc(1) = 0;

% do the same with the end
dur= (task_end-task_start)/1000;
replace_times_i = find(datc>dur);
replace_times_i = replace_times_i(1);
ampc((replace_times_i+1):end,:) = [];
datc((replace_times_i+1):end) = [];
datc(end) = dur;
%%
figure;
subplot(3,1,1)
plot(datc,ampc(:,1))
ylabel('Amplitude (mA)')
hold on
xline(task_start-task_start)
xline(dur)
title(hem)

subplot(3,1,2)
plot(datc,ampc(:,2))
ylabel('Pulse width (us)')

hold on
subplot(3,1,3)
plot(datc,ampc(:,3))
ylabel('Frequency (Hz)')

