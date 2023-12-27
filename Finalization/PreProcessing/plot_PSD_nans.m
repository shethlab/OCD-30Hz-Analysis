%% Segment timedomain based on trial inds and make PSDs

function [ax,f1,mean_psdMat1,mean_psdMat2,mean_psdMat3,mean_psdMat4] = plot_PSD_nans(td,hem,trial_inds,hold_on,channels,psd_win_size,psd_overlap,upper_freq_lim,log_bool,c)
psdMat1=cell(size(trial_inds,1),1);
psdMat2=cell(size(trial_inds,1),1);
psdMat3=cell(size(trial_inds,1),1);
psdMat4=cell(size(trial_inds,1),1);

for i = 1:size(trial_inds,1)
    si = trial_inds(i,1);
    ei = trial_inds(i,2);
    ch={};
    ch{1} =nan_demean(td.TD_key0{si:ei});
    ch{2} =nan_demean(td.TD_key1{si:ei});
    ch{3} =nan_demean(td.TD_key2{si:ei});
    ch{4} =nan_demean(td.TD_key3{si:ei});
    [psdMat1{i},f1]=pwelch(ch{1},hamming(psd_win_size),psd_overlap,[],500);
    psdMat2{i}=pwelch(ch{2},hamming(psd_win_size),psd_overlap,[],500);
    psdMat3{i}=pwelch(ch{3},hamming(psd_win_size),psd_overlap,[],500);
    psdMat4{i}=pwelch(ch{4},hamming(psd_win_size),psd_overlap,[],500);
end
%%
psdMat1 = [psdMat1{:}];
psdMat2 = [psdMat2{:}];
psdMat3 = [psdMat3{:}];
psdMat4 = [psdMat4{:}];

if log_bool ==1
    mean_psdMat1 = 10*log10(mean(psdMat1,2));
    mean_psdMat2 = 10*log10(mean(psdMat2,2));
    mean_psdMat3 = 10*log10(mean(psdMat3,2));
    mean_psdMat4 = 10*log10(mean(psdMat4,2));
    xtext = 'dB';
else
    mean_psdMat1 = mean(psdMat1,2);
    mean_psdMat2 = mean(psdMat2,2);
    mean_psdMat3 = mean(psdMat3,2);
    mean_psdMat4 = mean(psdMat4,2);
    xtext = 'mV^2 / Hz';
end

if hold_on == 1
    hold on
else
    figure('Renderer', 'painters', 'Position', [10 10 1200 800]);
end


%% Plot PSDs
ax(1) = subplot(2,3,1);
plot(ax(1), f1,(mean_psdMat1),'Color',c,'LineWidth',1)
hold on
title([hem,' VC/VS'])
ylabel('Power (dB)')
box off


ax(2) = subplot(2,3,2);
hold on
plot(ax(2),f1,(mean_psdMat3),'Color',c,'LineWidth',1)
title([hem,' OFC'])


ax(3) = subplot(2,3,3);
hold on
plot(ax(3),f1,(mean_psdMat4),'Color',c,'LineWidth',1)
title([hem,' vlPFC'])

ax(1).XLim = [0,upper_freq_lim];
ax(2).XLim = [0,upper_freq_lim];
ax(3).XLim = [0,upper_freq_lim];
ax(1).FontSize = 14;
ax(2).FontSize = 14;
ax(3).FontSize = 14;

% 2nd row:
ax(4) = subplot(2,3,4);
plot(ax(4), f1,(mean_psdMat1),'Color',c,'LineWidth',1)
hold on
ylabel('Power (dB)')
xlabel('Frequency (Hz)')
box off



ax(5) = subplot(2,3,5);
hold on
plot(ax(5),f1,(mean_psdMat3),'Color',c,'LineWidth',1)
xlabel('Frequency (Hz)')

ax(6) = subplot(2,3,6);
hold on
plot(ax(6),f1,(mean_psdMat4),'Color',c,'LineWidth',1)
xlabel('Frequency (Hz)')

ax(4).FontSize = 14;
ax(5).FontSize = 14;
ax(6).FontSize = 14;
ax(4).XLim = [0,250];
ax(5).XLim = [0,250];
ax(6).XLim = [0,250];


end

