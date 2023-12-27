function ax = talking_triggered_beta(td1,td2,ch_input1,ch_input2,si1,ei1,si2,ei2,hold_on,channels,psd_win_size,overlap,upper_freq_lim)
%addpath(genpath('C:\Users\Nicole\OneDrive\Documents\GitHub\fieldtrip\'))
load('Z:\OCD_Data\preprocessed-new\aDBS012\2022-09-09\amplitude\analysis\wps.mat')
%%
chL = demean_removeNaNs(td1(si1:ei1,:),0,0);
tsL = (1/500):(1/500):(length(chL(:,1))/500);

%%
chR = demean_removeNaNs(td2(si2:ei2,:),0,0);
tsR = (1/500):(1/500):(length(chR(:,1))/500);
        
%%
ch_1 = chL(:,ch_input1);
[~,f,t,tf]=spectrogram(ch_1,250,125,250,500);

% find timestamps where there is speech
ind_speech = find(words_per_second~=0);
ts_speech = ts_words_per_second(ind_speech);
inds_all_t = [];
for i = 1:length(ts_speech)
    inds_temp = find(and(t>(ts_speech(i)-2.5),t<ts_speech(i)+2.5));
    inds_all_t = [inds_all_t,inds_temp]
end
log_inds = false(length(t), 1);
log_inds(inds_all_t) = true;
%%
close all;
figure('Renderer', 'painters', 'Position', [10 10 2000 800]);

%ax1 = subplot(2,1,1)
%[~,f,t,tf]=spectrogram(ch_1,250,125,250,500);
% scaling = [-27,-8];
% imagesc('XData',t,'YData',f,'CData',cnelab_TF_Smooth(log(abs(tf)),'gaussian',[1,10]),scaling);
% colormap(jet);title(['Left ',channels{ch_input1}])
% ylabel('Frequency (Hz)')
% xlabel('seconds')
% colormap jet
% colorbar
% ax1.YLim = [1,155];
% ax1.XLim = [0,t(end)];
% drawnow;

f_plot = and(f<33,f>29);
ax2 = subplot(2,1,2);
plot(t,cnelab_TF_Smooth(log(abs(tf(16,:))),'gaussian',[1,10]))

b1 = log(abs(tf(f_plot,:)));

figure;
bw = .2;
histogram(b1(find(log_inds)),'BinWidth',bw)
hold on
histogram(b1(find(~log_inds)),'BinWidth',bw)
legend('Talking','Not talking')
xlabel('Beta Power [dB]')
ylabel('count')
[h2,p2] = ranksum(b1(find(log_inds)),b1(find(~log_inds)))
title(['P value: ',num2str(h2)])
saveas(gcf,'Z:\OCD_Data\preprocessed-new\aDBS012\2022-09-09\amplitude\analysis\talking-triggered-beta-LH.png')

ch_2 = chR(:,ch_input2);
%ax3 = subplot(2,1,2);
[~,f,t,tf]=spectrogram(ch_2,250,125,250,500);
%imagesc('XData',t,'YData',f,'CData',cnelab_TF_Smooth(log(abs(tf)),'gaussian',[1,10]),[-27,-8]);
%colormap(jet);title(['Right ',channels{4+ch_input2}])
%colormap jet
%colorbar
%drawnow;


%clim([-100,-20])
% ax4 = subplot(3,1,4);
% plot(tsR,ch_2)
% linkaxes([ax1,ax2,ax3,ax4],'x')
% xlabel('Time (minutes)')
% ylabel('Voltage (mV)')
%linkaxes([ax1,ax3],'xy')
% ax1.YLim = [1,155];
% ax1.XLim = [0,t(end)];
%     clim(scaling)
% 
% ylabel('Frequency (Hz)')
% xlabel('seconds')
%ax5 = subplot(5,1,5);

figure
f_plot = 16;
b1 = log(abs(tf(f_plot,:)));
plot(t,b1)
ylabel('Beta (29-31 Hz) Power [dB]')

figure;
bw = .2;
histogram(b1(find(log_inds)),'BinWidth',bw)
hold on
histogram(b1(find(~log_inds)),'BinWidth',bw)
legend('Talking','Not talking')
xlabel('Beta Power [dB]')
ylabel('count')
[h2,p2] = ranksum(b1(find(log_inds)),b1(find(~log_inds)))
title(['P value: ',num2str(h2)])
saveas(gcf,'Z:\OCD_Data\preprocessed-new\aDBS012\2022-09-09\amplitude\analysis\talking-triggered-beta-RH.png')
% [cxy,fc] = mscohere(ch_1,ch_2,hamming(500),250,[],500);
% plot(fc,cxy)
% ylabel('Coherence')
% xlabel('Frequency (Hz)')



end

