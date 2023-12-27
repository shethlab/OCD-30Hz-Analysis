function [stable_periods,stim_params_left,stim_params_right,condition,left_plats,right_plats] =findBilateralStablePeriodsEntrainment(ampc1,ampc2,datc1,datc2)
%%
prompt = 'Enter clinical frequency on left: ';
clin_freq_left = input(prompt);

prompt = 'Enter clinical frequency on right: ';
clin_freq_right = input(prompt);

%% Nullify stim off
for i = 1:length(ampc1)
    if isnan(ampc1(i,1)) 
        ampc1(i,1) = 0;
        ampc1(i,2) = 0;
        ampc1(i,3) = 0;
    end
end
for i = 1:length(ampc2)
    if isnan(ampc2(i,1)) 
        ampc2(i,1) = 0;
        ampc2(i,2) = 0;
        ampc2(i,3) = 0;
    end
end
%% Left Change points
left_removals = [];
for i =2:length(ampc1)
    prev = ampc1(i-1,:);
    curr = ampc1(i,:);
    if sum(curr == prev)~=3
        left_removals = [left_removals;datc1(i)];
    end
end
left_intervals=[];
for i = 1:length(left_removals)
    rem_time = left_removals(i);
    rem_interval = [rem_time-1,rem_time+5];
    left_intervals(i,:) = rem_interval;
end

%% Right Change points
right_removals = [];
for i =2:length(ampc2)
    prev = ampc2(i-1,:);
    curr = ampc2(i,:);
    if sum(curr == prev)~=3
        right_removals = [right_removals;datc2(i)];
    end
end
right_intervals=[];
for i = 1:length(right_removals)
    rem_time = right_removals(i);
    rem_interval = [rem_time-1,rem_time+5];
    right_intervals(i,:) = rem_interval;
end

%% Find stable intervals
combined_intervals = sort([left_intervals; right_intervals]);
intervals = combined_intervals(1,:);
c=1;
for i = 2:length(combined_intervals)
    prev = intervals(c,:);
    curr = combined_intervals(i,:); 
    if prev(2) < curr(1)-20
        intervals = [intervals; curr];
        c = c+1;
    else
        intervals(c,2) = curr(2);
    end
end
stable_periods = [0,intervals(1,1)];

for i = 2:length(intervals)
    next_stable = [intervals(i-1,2),intervals(i,1)];
    stable_periods = [stable_periods;next_stable];
end
stable_periods = [stable_periods;intervals(end,2),max(datc1(end),datc2(end))];
%% 
stim_params_left = [];
stim_params_right = [];
for i = 1: length(stable_periods)
    time = stable_periods(i,1);
    if time == 0 
        time = min(datc1);
    end
    linds = find(datc1<=time);
    linds = linds(end);
    rinds = find(datc2<=time);
    rinds = rinds(end);
    stim_params_left = [stim_params_left; ampc1(linds,:)];
    stim_params_right = [stim_params_right; ampc2(rinds,:)];
end

left_high = max(stim_params_left(:,3));
left_low = min(stim_params_left(:,3));
left_medium = setdiff(stim_params_left(:,3),[left_high, left_low, clin_freq_left]);

right_high = max(stim_params_right(:,3));
right_low = min(stim_params_right(:,3));
right_medium = setdiff(stim_params_right(:,3),[right_high, right_low, clin_freq_right]);

condition = [];
for i = 1:length(stable_periods)
    if stim_params_left(i,3) == left_high && stim_params_right(i,3) == right_high
        if (stim_params_left(i,3) == clin_freq_left && stim_params_right(i,3) == clin_freq_right) && i == length(stable_periods)
            condition{i} = 'Clinical freqency';
        else
            condition{i}= 'High freqency';
        end
    elseif stim_params_left(i,3) == left_medium && stim_params_right(i,3) == right_medium
        if (stim_params_left(i,3) == clin_freq_left && stim_params_right(i,3) == clin_freq_right) && i == length(stable_periods)
            condition{i} = 'Clinical freqency';
        else
            condition{i}= 'Medium freqency';
        end
    elseif stim_params_left(i,3) == left_low && stim_params_right(i,3) == right_low
        if (stim_params_left(i,3) == clin_freq_left && stim_params_right(i,3) == clin_freq_right) && i == length(stable_periods)
            condition{i} = 'Clinical freqency';
        else
            condition{i}= 'Low freqency';
        end
    elseif (stim_params_left(i,3) == clin_freq_left && stim_params_right(i,3) == clin_freq_right) 
        condition{i} = 'Clinical freqency';
    else
        condition{i} = 'Other; Conditions do not match bilaterally';
    end
end
condition = condition';
left_plats = [left_low,left_high,clin_freq_left];
right_plats = [right_low,right_high,clin_freq_right];
