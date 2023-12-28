function [stable_periods,stim_params_left,stim_params_right,condition,left_plats,right_plats] =findBilateralStablePeriods(ampc1,ampc2,datc1,datc2)
%%
prompt = 'Enter clinical amplitude on left: ';
clin_amp_left = input(prompt);

prompt = 'Enter clinical amplitude on right: ';
clin_amp_right = input(prompt);
%% Left Change points
left_removals = [];
for i =2:height(ampc1)
    prev = ampc1(i-1,:);
    curr = ampc1(i,:);
    if sum(curr == prev)~=3
        left_removals = [left_removals;datc1(i)];
    end
end
left_intervals=[];
for i = 1:height(left_removals)
    rem_time = left_removals(i);
    rem_interval = [rem_time-3,rem_time+5];
    left_intervals(i,:) = rem_interval;
end

%% Right Change points
right_removals = [];
for i =2:height(ampc2)
    prev = ampc2(i-1,:);
    curr = ampc2(i,:);
    if sum(curr == prev)~=3
        right_removals = [right_removals;datc2(i)];
    end
end
right_intervals=[];
for i = 1:height(right_removals)
    rem_time = right_removals(i);
    rem_interval = [rem_time-5,rem_time+5];
    right_intervals(i,:) = rem_interval;
end
if isempty(left_intervals) && isempty(right_intervals)
    left_intervals = datc1';
    right_intervals = datc2';
end
%% Find stable intervals
combined_intervals = sort([left_intervals; right_intervals]);
intervals = combined_intervals(1,:);
c=1;
for i = 2:height(combined_intervals)
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

for i = 2:height(intervals)
    next_stable = [intervals(i-1,2),intervals(i,1)];
    stable_periods = [stable_periods;next_stable];
end
stable_periods = [stable_periods;intervals(end,2),max(datc1(end),datc2(end))];

stim_params_left = [];
stim_params_right = [];
for i = 1: height(stable_periods)
    time = stable_periods(i,1);
    linds = find(datc1<=time);
    linds = linds(end);
    rinds = find(datc2<=time);
    rinds = rinds(end);
    stim_params_left = [stim_params_left; ampc1(linds,:)];
    stim_params_right = [stim_params_right; ampc2(rinds,:)];
end

stim_params_left(isnan(stim_params_left(:,1))) = 0;
stim_params_right(isnan(stim_params_right(:,1))) = 0;

left_high = max(stim_params_left(:,1));
left_low = min(stim_params_left(:,1));

right_high = max(stim_params_right(:,1));
right_low = min(stim_params_right(:,1));

condition = [];
for i = 1:height(stable_periods)
    if stim_params_left(i,1) == left_high && stim_params_right(i,1) == right_high
        if (stim_params_left(i,1) == clin_amp_left && stim_params_right(i,1) == clin_amp_right) && i == length(stable_periods)
            condition{i} = 'Clinical Amplitude';
        else
            condition{i}= 'High Amplitude';
        end
    elseif stim_params_left(i,1) == left_low && stim_params_right(i,1) == right_low
        if (stim_params_left(i,1) == clin_amp_left && stim_params_right(i,1) == clin_amp_right) && i == length(stable_periods)
            condition{i} = 'Clinical Amplitude';
        else
            condition{i}= 'Low Amplitude';
        end
    elseif (stim_params_left(i,1) == clin_amp_left && stim_params_right(i,1) == clin_amp_right) 
        condition{i} = 'Clinical Amplitude';
    else
        condition{i} = 'Other; Conditions do not match bilaterally';
    end
end
condition = condition';
left_plats = [left_low,left_high,clin_amp_left];
right_plats = [right_low,right_high,clin_amp_right];
end