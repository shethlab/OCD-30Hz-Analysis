function [DBS_high_start_times, DBS_high_end_times,DBS_low_start_times,DBS_low_end_times,DBS_clin_start_times,DBS_clin_end_times,high_amp,low_amp] = get_amp_timestamps(ampc1,datc1,clin_amp)

%ampc1(13:end,:)=[];
%datc1(13:end)=[];

high_amp = max(ampc1(:,1));
%high_amp = 3;

low_amp = min(ampc1(:,1));

DBS_low_inds = find(ampc1(:,1)==low_amp);
temp_low = find(diff(DBS_low_inds)~=1);
DBS_low_start_inds = [DBS_low_inds(1);DBS_low_inds(temp_low+1)];

DBS_high_inds = find(ampc1(:,1)==high_amp);
temp_high = find(diff(DBS_high_inds)~=1);
DBS_high_start_inds = [DBS_high_inds(1);DBS_high_inds(temp_high+1)];
DBS_high_end_inds = DBS_high_start_inds+1;
DBS_low_end_inds = DBS_high_start_inds-1;
if any(DBS_low_end_inds==0)
    DBS_low_end_inds(1)=[];
end
%DBS_low_start_times = datc1(DBS_low_start_inds);
%DBS_high_start_times = datc1(DBS_high_start_inds);

DBS_low_end_times = datc1(DBS_low_end_inds) - 5;
DBS_high_end_times = datc1(DBS_high_end_inds) - 5;

DBS_low_start_times = datc1(DBS_low_start_inds)+5;
DBS_high_start_times = datc1(DBS_high_start_inds)+5;

% if CT = LT, then remove last low end time and make it the clinical start
% time
% get clinical threshold inds
DBS_clin_inds = find(ampc1(:,1)==clin_amp);
DBS_clin_inds(1:2) = [];
DBS_clin_amp_inds = [DBS_clin_inds(end-1)];

if clin_amp == low_amp
    %DBS_low_start_times(1) = [];
    %DBS_low_end_times(1) = [];
    DBS_low_start_times(end) = [];
    %DBS_low_end_times(end) = [];
    DBS_clin_end_times = datc1(DBS_clin_amp_inds+1);
    DBS_clin_start_times = datc1(DBS_clin_amp_inds)+5;


elseif clin_amp == high_amp
    DBS_high_start_times(1) = [];
    DBS_high_end_times(1) = [];
    % add 3 mins 
    DBS_high_end_times(end) = DBS_high_start_times(2)+60*3;
    DBS_clin_start_times = DBS_high_end_times(end)+1;
    DBS_clin_end_times = datc1(DBS_clin_amp_inds+1);

else
    DBS_clin_start_times = datc1(DBS_clin_amp_inds)+5;
    DBS_clin_end_times = datc1(DBS_clin_amp_inds+1);
end


end