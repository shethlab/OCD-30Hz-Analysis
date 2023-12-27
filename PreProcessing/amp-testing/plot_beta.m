%%
chL = demean_removeNaNs(dat1(start_ind1:end_ind1,:),0,0);
tsL = (1/500):(1/500):(length(chL(:,1))/500);

%%
chR = demean_removeNaNs(dat2(start_ind2:end_ind1,:),0,0);
tsR = (1/500):(1/500):(length(chR(:,1))/500);
        
close all;
ch_1 = chL(:,4);
figure('Renderer', 'painters', 'Position', [10 10 2000 800]);

ax1 = subplot(6,1,1)
[~,f,t,tf]=spectrogram(ch_1,250,125,250,500);
scaling = [-27,-8];
imagesc('XData',t,'YData',f,'CData',cnelab_TF_Smooth(log(abs(tf)),'gaussian',[1,10]),scaling);
colormap(jet);title(['Left ',amp_data.channels{4}])
ylabel('Frequency (Hz)')
xlabel('seconds')
colormap jet
%colorbar
ax1.YLim = [1,155];
ax1.XLim = [0,t(end)];
drawnow;

f_plot = and(f<33,f>29);
f_plot = 16;

ax2 = subplot(6,1,2) 
plot(t,cnelab_TF_Smooth(log(abs(tf(f_plot,:))),'gaussian',[1,10]))
%plot(t,log(abs(tf(16,:))))

hold on
xline(amp_data.DBS_low_times(1,:),'k')
hold on
xline(amp_data.DBS_low_times(2,:),'k')
hold on
xline(amp_data.DBS_high_times(1,:),'r')
hold on
xline(amp_data.DBS_high_times(2,:),'r')
hold on
xline(amp_data.DBS_clin_times,'b')
ylabel({'Beta (29-31 Hz)'; 'Power [dB]'})
xlabel('seconds')

clim([-100,-20])
ax2.XLim = [0,t(end)];

low_i = find(or(and(t>amp_data.DBS_low_times(1,1),t<amp_data.DBS_low_times(1,2)),and(t>amp_data.DBS_low_times(2,1),t<amp_data.DBS_low_times(2,2))));
high_i = find(or(and(t>amp_data.DBS_high_times(1,1),t<amp_data.DBS_high_times(1,2)),and(t>amp_data.DBS_high_times(2,1),t<amp_data.DBS_high_times(2,2))));
clin_i = find(and(t>amp_data.DBS_clin_times(1,1),t<amp_data.DBS_clin_times(1,2)));
p = cnelab_TF_Smooth(log(abs(tf(16,:))),'gaussian',[1,10]);
%p = log(abs(tf(16,:)));
ax3 = subplot(6,1,3)
bw = .02;
histogram(p(low_i),'BinWidth',bw)
hold on
histogram(p(high_i),'BinWidth',bw)
hold on
histogram(p(clin_i),'BinWidth',bw)
ylabel('count')
xlabel('Beta (29-31 Hz) Power [dB]')
legend({'Low','High','Clin'})

[h1,p1] = ranksum(p(low_i),p(high_i));

% plot(tsL,ch_1)
% linkaxes([ax1,ax2],'x')
% xlabel('Time (minutes)')
% ylabel('Voltage (mV)')

ch_2 = chR(:,4);

ax4 = subplot(6,1,4);
[~,f,t,tf]=spectrogram(ch_2,250,125,250,500);
imagesc('XData',t,'YData',f,'CData',cnelab_TF_Smooth(log(abs(tf)),'gaussian',[1,10]),[-27,-8]);
colormap(jet);title(['Right ',amp_data.channels{4+4}])
colormap jet
%colorbar
drawnow;
clim([-100,-20])

linkaxes([ax1,ax4],'xy')
ax4.YLim = [1,155];
ax4.XLim = [0,t(end)];
clim(scaling)

ylabel('Frequency (Hz)')
xlabel('seconds')

f_plot = and(f<33,f>29);
f_plot = 16;
ax5 = subplot(6,1,5) 
plot(t,cnelab_TF_Smooth(log(abs(tf(f_plot,:))),'gaussian',[1,10]))
%plot(t,log(abs(tf(16,:))))
hold on
xline(amp_data.DBS_low_times(1,:),'k')
hold on
xline(amp_data.DBS_low_times(2,:),'k')
hold on
xline(amp_data.DBS_high_times(1,:),'r')
hold on
xline(amp_data.DBS_high_times(2,:),'r')
hold on
xline(amp_data.DBS_clin_times,'b')
ylabel({'Beta (29-31 Hz)'; 'Power [dB]'})
xlabel('seconds')
ax5.XLim = [0,t(end)];

%linkaxes([ax1 ax2 ax3 ax4],'x')

low_i = find(or(and(t>amp_data.DBS_low_times(1,1),t<amp_data.DBS_low_times(1,2)),and(t>amp_data.DBS_low_times(2,1),t<amp_data.DBS_low_times(2,2))));
high_i = find(or(and(t>amp_data.DBS_high_times(1,1),t<amp_data.DBS_high_times(1,2)),and(t>amp_data.DBS_high_times(2,1),t<amp_data.DBS_high_times(2,2))));
clin_i = find(and(t>amp_data.DBS_clin_times(1,1),t<amp_data.DBS_clin_times(1,2)));
p = cnelab_TF_Smooth(log(abs(tf(16,:))),'gaussian',[1,10]);
%p = log(abs(tf(16,:)));
ax6 = subplot(6,1,6)
histogram(p(low_i),'BinWidth',bw)
hold on
histogram(p(high_i),'BinWidth',bw)
hold on
histogram(p(clin_i),'BinWidth',bw)
ylabel('count')
xlabel('Beta (29-31 Hz) Power [dB]')
legend({'Low','High','Clin'})


[h2,p2] = ranksum(p(low_i),p(high_i));


%%
[~,f,t,tf]=spectrogram(ch_1,250,125,250,500);

low_i = find(or(and(t>amp_data.DBS_low_times(1,1),t<amp_data.DBS_low_times(1,2)),and(t>amp_data.DBS_low_times(2,1),t<amp_data.DBS_low_times(2,2))));
high_i = find(or(and(t>amp_data.DBS_high_times(1,1),t<amp_data.DBS_high_times(1,2)),and(t>amp_data.DBS_high_times(2,1),t<amp_data.DBS_high_times(2,2))));
clin_i = find(and(t>amp_data.DBS_clin_times(1,1),t<amp_data.DBS_clin_times(1,2)));
p = cnelab_TF_Smooth(log(abs(tf(16,:))),'gaussian',[1,10]);

bw = .06;
    figure('Renderer', 'painters', 'Position', [10 10 1000 400]);
    subplot(1,2,1)
histogram(p(low_i),'BinWidth',bw)
hold on
histogram(p(high_i),'BinWidth',bw)
hold on
histogram(p(clin_i),'BinWidth',bw)
ylabel('count')
xlabel('Beta (29-31 Hz) Power [dB]')
legend({'OFF 1+2','ON 1+2','OFF 3'},'FontSize',11)
title('Left lOFC')

ax = gca;
ax.FontSize = 14;
%saveas(gcf,[analysis_save_dir,subject_id,'_',date,'_amplitude-analysis_betastimHist_',ch_inputs,'.svg'])

subplot(1,2,2)
[~,f,t,tf]=spectrogram(ch_2,250,125,250,500);
low_i = find(or(and(t>amp_data.DBS_low_times(1,1),t<amp_data.DBS_low_times(1,2)),and(t>amp_data.DBS_low_times(2,1),t<amp_data.DBS_low_times(2,2))));
high_i = find(or(and(t>amp_data.DBS_high_times(1,1),t<amp_data.DBS_high_times(1,2)),and(t>amp_data.DBS_high_times(2,1),t<amp_data.DBS_high_times(2,2))));
clin_i = find(and(t>amp_data.DBS_clin_times(1,1),t<amp_data.DBS_clin_times(1,2)));
p = cnelab_TF_Smooth(log(abs(tf(16,:))),'gaussian',[1,10]);
%p = log(abs(tf(16,:)));
histogram(p(low_i),'BinWidth',bw)
hold on
histogram(p(high_i),'BinWidth',bw)
hold on
histogram(p(clin_i),'BinWidth',bw)
ylabel('count')
xlabel('Beta (29-31 Hz) Power [dB]')
legend({'OFF 1+2','ON 1+2','OFF 3'},'FontSize',11)
title('Right lOFC')
ax = gca;
ax.FontSize = 14;
ax.FontSize = 14;

saveas(gcf,[analysis_save_dir,subject_id,'_',date,'_amplitude-analysis_betastimHist_',ch_inputs,'.svg'])

