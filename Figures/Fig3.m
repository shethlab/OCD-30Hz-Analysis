fig3psd = figure('Renderer', 'painters', 'Position', [10 10 1200 800],'Color','w');
fig3violins = figure('Renderer', 'painters', 'Position', [10 10 2000 1200],'Color','w');

%% 11/15 Data

datafile = '/Users/sameerrajesh/Desktop/30Hz Project Data/2022-11-15/AnalysisFiles/amplitude/datafile_corrected_v4.mat';
psdfileleft = '/Users/sameerrajesh/Desktop/30Hz Project Data/2022-11-15/AnalysisFiles/amplitude/2022-11-15_PSD-data_Left.mat';
psdfileright = '/Users/sameerrajesh/Desktop/30Hz Project Data/2022-11-15/AnalysisFiles/amplitude/2022-11-15_PSD-data_Right.mat';

load(datafile);


% left
load(psdfileleft);
% plot PSD
c = [31 195 255;...
    251 86 59;...
    0 108 255;...
    237 28 36;...
    %0 38 255;...
    57 181 74]/255;
upper_freq_lim = 55;
figure(fig3psd);
ax(1) = subplot(3,3,1);
hold on
axis square
box off
for i = 1:3
    switch i
        case 1
            dat = low1; %exclude low2 because of packetloss
        case 2
            dat = high2; %exclude high1 because of packetloss
        case 3
            dat = clin1;
            i = 5;
    end
    hold on;
    plot(ax(1),f1,dat(:,4),'Color',c(i,:),'LineWidth',1)
    hold on;
    if i == 5


        title(ax(1),['Left vlPFC']);

        ylabel(ax(1),'Power (dB)');
        xlabel(ax(1),'Frequency (Hz)');
    end
    box off


end


ax(1).XLim = [0,upper_freq_lim];
xticks(ax(1),[0 10 20 30 40 50]);
ax(1).FontSize = 14;
legend(ax(1),{'Low','High','Clinical'})

% Violins
data = pows(2).value;
cat = pows(2).high_amp;
time1 = stimdata.lowTimes(1,2);
time2 = stimdata.lowTimes(2,2);
inds = find((cat == 0 | cat == 1) & (pows(2).times<=time1 | pows(2).times>=time2));
data = data(inds);
cat = cat(inds);
figure(fig3violins);
subplot(2,6,1);
violins1 = violinplot(data,cat,'ShowMean',true);
q(1) = gca;
q(1).FontSize = 14;
q(1).XAxis.Visible = 'off';
clearvars -except pows fig3psd fig3violins ax q psdfileright stimdata


% right
load(psdfileright);
% plot PSD
c = [31 195 255;...
    251 86 59;...
    0 108 255;...
    237 28 36;...
    %0 38 255;...
    57 181 74]/255;
upper_freq_lim = 55;
figure(fig3psd);
ax(2) = subplot(3,3,2);
hold on
axis square
box off
for i = 1:3
    switch i
        case 1
            dat = (low1+low2)/2;
        case 2
            dat = (high1+high2)/2;
        case 3
            dat = clin1;
            i = 5;
    end
    hold on;
    plot(ax(2),f1,dat(:,4),'Color',c(i,:),'LineWidth',1)
    hold on;
    if i == 5


        title(ax(2),['Right vlPFC']);

        ylabel(ax(2),'Power (dB)');
        xlabel(ax(2),'Frequency (Hz)');
    end
    box off


end


ax(2).XLim = [0,upper_freq_lim];
xticks(ax(2),[0 10 20 30 40 50]);
ax(2).FontSize = 14;
legend(ax(2),{'Low','High','Clinical'})

% Violins
data = pows(4).value;
cat = pows(4).high_amp;

inds = find((cat == 0 | cat == 1));
data = data(inds);
cat = cat(inds);
figure(fig3violins);
subplot(2,6,2);
violins1 = violinplot(data,cat,'ShowMean',true);
q(2) = gca;
q(2).FontSize = 14;
q(2).XAxis.Visible = 'off';
clearvars -except fig3psd fig3violins ax q
%%
%% 02/27 Data
datafile = '/Users/sameerrajesh/Desktop/30Hz Project Data/2023-02-27/AnalysisFiles/amplitude/Experiment_1/datafile_corrected_v4.mat';
psdfileleft = '/Users/sameerrajesh/Desktop/30Hz Project Data/2023-02-27/AnalysisFiles/amplitude/Experiment_1/2023-02-27_PSD-data_Left.mat';
psdfileright = '/Users/sameerrajesh/Desktop/30Hz Project Data/2023-02-27/AnalysisFiles/amplitude/Experiment_1/2023-02-27_PSD-data_Right.mat';
load(datafile);

%left
load(psdfileleft);
% plot PSD
c = [31 195 255;...
    251 86 59;...
    0 108 255;...
    237 28 36;...
    %0 38 255;...
    57 181 74]/255;
upper_freq_lim = 55;
figure(fig3psd);
ax(3) = subplot(3,3,3);
hold on
axis square
box off
for i = 1:2
    switch i
        case 1
            dat = (low1+low2+clin1)/3;
        case 2
            dat = (high1+high2)/2;
    end
    hold on;
    plot(ax(3),f1,dat(:,4),'Color',c(i,:),'LineWidth',1)
    hold on;
    if i == 2


        title(ax(3),['Left vlPFC']);

        ylabel(ax(3),'Power (dB)');
        xlabel(ax(3),'Frequency (Hz)');
    end
    box off


end


ax(3).XLim = [0,upper_freq_lim];
xticks(ax(3),[0 10 20 30 40 50]);
ax(3).FontSize = 14;
legend(ax(3),{'No Talking','Talking'})

% Violins
data = pows(2).value;
cat = pows(2).high_amp;
cat(cat==3)=0;
inds = find(cat == 0 | cat == 1);
data = data(inds);
cat = cat(inds);
figure(fig3violins);
subplot(2,6,3);
violins1 = violinplot(data,cat,'ShowMean',true);
q(3) = gca;
q(3).FontSize = 14;
q(3).XAxis.Visible = 'off';

clearvars -except fig3psd fig3violins ax q pows psdfileright

%Right
load(psdfileright);
% plot PSD
c = [31 195 255;...
    251 86 59;...
    0 108 255;...
    237 28 36;...
    %0 38 255;...
    57 181 74]/255;
upper_freq_lim = 55;
figure(fig3psd);
ax(4) = subplot(3,3,4);
hold on
axis square
box off
for i = 1:2
    switch i
        case 1
            dat = (low1+low2+clin1)/3;
        case 2
            dat = (high1+high2)/2;
    end
    hold on;
    plot(ax(4),f1,dat(:,4),'Color',c(i,:),'LineWidth',1)
    hold on;
    if i == 2


        title(ax(4),['Right vlPFC']);

        ylabel(ax(4),'Power (dB)');
        xlabel(ax(4),'Frequency (Hz)');
    end
    box off


end


ax(4).XLim = [0,upper_freq_lim];
xticks(ax(4),[0 10 20 30 40 50]);
ax(4).FontSize = 14;
legend(ax(4),{'No Talking','Talking'})

% Violins
data = pows(4).value;
cat = pows(4).high_amp;
cat(cat==3)=0;
inds = find(cat == 0 | cat == 1);
data = data(inds);
cat = cat(inds);
figure(fig3violins);
subplot(2,6,4);
violins1 = violinplot(data,cat,'ShowMean',true);
q(4) = gca;
q(4).FontSize = 14;
q(4).XAxis.Visible = 'off';

ylim(q,[0,20])
linkaxes(ax,'y');
linkaxes(q,'y');


%% Save Figure
savedir = '/Users/sameerrajesh/Desktop/30Hz Project Data/Figures/Figure 3/';
if ~isdir(savedir)
    mkdir(savedir);
end

saveas(fig3psd,strcat(savedir,'PSDs.svg'))
saveas(fig3violins,strcat(savedir,'Violins.svg'))