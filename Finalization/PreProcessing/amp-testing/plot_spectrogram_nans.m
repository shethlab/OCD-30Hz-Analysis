function ax = plot_spetrogram_nans(td1,td2,ch_input1,ch_input2,si1,ei1,si2,ei2,hold_on,channels,psd_win_size,overlap,upper_freq_lim)
%addpath(genpath('C:\Users\Nicole\OneDrive\Documents\GitHub\fieldtrip\'))

%%
chL = demean_removeNaNs(td1(si1:ei1,:),0,0);
tsL = (1/500):(1/500):(length(chL(:,1))/500);

%%
chR = demean_removeNaNs(td2(si2:ei2,:),0,0);
tsR = (1/500):(1/500):(length(chR(:,1))/500);
        
%freq = [1:0.5:4,4:0.5:8,8:0.5:15,15:1:30,30:1:55]; 
% freq = [29:0.5:31]; 
% 
% [spectrum, freqoi, timeoi] = ft_specest_wavelet(chL(:,4)',tsL, 'freqoi',freq,'gwidth',14,'width',6);
% s = mean(squeeze(real(spectrum)),1).^2;
% figure;
% plot(timeoi,s);
% figure;
% clims = [0 .2]
% imagesc('XData',timeoi,'YData',freqoi,'CData',s,clims)
% colorbar
% ax = gca;
% %ax.YLim = [0,200];
% colormap jet

% figure;
% [cfs,f] = cwt(chL(:,4),500);
% figure;
% imagesc("XData",tsL,'YData',f,"CData",abs(cfs),[0,.02])
% set(gca,'YScale','log')
% colormap jet


% [~,f,t,tf]=spectrogram(chL(:,4),250,125,250,500);
% 
% figure;
% [~,f,t,tf]=spectrogram(chL(:,4),250,125,250,500);
% imagesc('XData',t,'YData',f,'CData',cnelab_TF_Smooth(log(abs(tf)),'gaussian',[1,10]),[-27,-8]);
% colormap(jet);
% colorbar 

% figure;
% imagesc('XData',t,'YData',f,'CData',cnelab_TF_Smooth(abs(tf),'gaussian',[1,100]),[0,0.00002]);
% colormap(jet);
% figure;
% imagesc('XData',t,'YData',f,'CData',abs(tf),[0,0.00002]);
% colormap(jet);
%%
close all;
ch_1 = chL(:,ch_input1);
figure('Renderer', 'painters', 'Position', [10 10 2000 800]);

ax1 = subplot(2,1,1)
[~,f,t,tf]=spectrogram(ch_1,250,125,250,500);
scaling = [-27,-8];
imagesc('XData',t,'YData',f,'CData',cnelab_TF_Smooth(log(abs(tf)),'gaussian',[1,10]),scaling);
colormap(jet);%title(['Left ',channels{ch_input1}])
%title('Left lateral OFC')

ylabel('Frequency (Hz)')
%xlabel('seconds')
colormap jet
colorbar off
ax1.YLim = [1,155];
ax1.XLim = [0,t(end)];
drawnow;
ax1.FontSize = 14;
f_plot = and(f<33,f>29);
%figure;
%plot(t,cnelab_TF_Smooth(log(abs(tf(16,:))),'gaussian',[1,10]))

x = input('happy with scaling?');
while x==0
    scaling = input('new colorbar? [x y]');
    clim(scaling);
    drawnow;
    x = input('happy with scaling?');
end
%clim([-100,-20])
% ax2 = subplot(4,1,2)
% plot(tsL,ch_1)
% linkaxes([ax1,ax2],'x')
% xlabel('Time (minutes)')
% ylabel('Voltage (mV)')

ch_2 = chR(:,ch_input2);

ax3 = subplot(2,1,2);
[~,f,t,tf]=spectrogram(ch_2,250,125,250,500);
imagesc('XData',t,'YData',f,'CData',cnelab_TF_Smooth(log(abs(tf)),'gaussian',[1,10]),[-27,-8]);
colormap(jet);%title(['Right ',channels{4+ch_input2}])
%title('Right lateral OFC')
colormap jet
colorbar off
drawnow;
ax3.FontSize = 14;


%clim([-100,-20])
% ax4 = subplot(3,1,4);
% plot(tsR,ch_2)
% linkaxes([ax1,ax2,ax3,ax4],'x')
% xlabel('Time (minutes)')
% ylabel('Voltage (mV)')
linkaxes([ax1,ax3],'xy')
ax1.YLim = [1,155];
ax1.XLim = [0,t(end)];
    clim(scaling)

ylabel('Frequency (Hz)')
xlabel('seconds')
%ax5 = subplot(5,1,5);

% [cxy,fc] = mscohere(ch_1,ch_2,hamming(500),250,[],500);
% plot(fc,cxy)
% ylabel('Coherence')
% xlabel('Frequency (Hz)')



end

