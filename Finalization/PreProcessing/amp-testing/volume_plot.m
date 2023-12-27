close all;

% fig = figure('units','normalized','outerposition',[0 0 1 .6]);
% %subplot(3,1,1)
% plot(amp_data.stim_times1,amp_data.stim_changes1(:,1),'LineWidth',3,'Color','b')
% hold on
% plot(amp_data.stim_times1,amp_data.stim_changes2(:,1),'LineWidth',2,'Color','r')
% ylabel('Amplitude (mA)')
% legend('Left Hemisphere','Right Hemisphere')

fig = figure('units','normalized','outerposition',[0 0 1 .6]);
ax1 = subplot(2,1,1)
yyaxis left
plot(amp_data.ts_audio,amp_data.audio)
ylabel('Audio','FontSize',14)

yyaxis right
plot(amp_data.stim_times1,amp_data.stim_changes1(:,1),'LineWidth',1,'Color','b')
ylabel({'Bilateral';'DBS Amplitude (mA)'},'FontSize',14)
ax = gca;
ax.YAxis(2).Color = 'b';
ax.YLim = [0,5.5];
ax2 = subplot(2,1,2)
yyaxis left


aud = decimate(amp_data.audio,20,'fir');
aud_ts = decimate(amp_data.ts_audio,20,'fir');
[up,lo] = envelope(aud,1500,'peak');
%plot(amp_data.ts_audio,amp_data.audio)
%hold on
plot(aud_ts,up-lo,'k')
ylabel({'Peak to Peak';'Audio Envelope'},'FontSize',14)
xlabel('seconds','FontSize',14)
yyaxis right
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'b';
%ax.YLim = [0,5.5];

plot(amp_data.stim_times1,amp_data.stim_changes1(:,1),'LineWidth',1,'Color','b')
ylabel({'Bilateral';'DBS Amplitude (mA)'},'FontSize',14)
ax = gca;
ax.YLim = [0,5.5];

% ax_all = [ax1;ax2]
% for i = 1:length(ax_all)
%     axes(ax_all(i))
%     xline(amp_data.DBS_low_times(1,:),'k')
%     hold on
%     xline(amp_data.DBS_low_times(2,:),'k')
%     hold on
%     xline(amp_data.DBS_high_times(1,:),'r')
%     hold on
%     xline(amp_data.DBS_high_times(2,:),'r')
%     hold on
%     xline(amp_data.DBS_clin_times,'b')
% end