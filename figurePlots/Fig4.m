fig4 = figure('Renderer', 'painters', 'Position', [10 10 2000 1200],'Color','w');

t = tiledlayout(4,4);

%% 11/15 Data
datafile = '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/11-15-2022/datafile_corrected_v1.mat';
psdfileleft = '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/11-15-2022/aDBS012_2022-11-15_PSD-data_Left_v2.mat';
psdfileright = '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/11-15-2022/aDBS012_2022-11-15_PSD-data_Right_v2.mat';

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
ax(1) = nexttile;
hold on
axis square
box off
for i = 1:3
    switch i
        case 1
            dat = low1;
        case 2
            dat = high2;
        case 3
            dat = clin1;
            i = 5;
    end
    hold on;
    plot(ax(1),f1,dat(:,3),'Color',c(i,:),'LineWidth',1)
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
nexttile;
violins1 = violinplot(data,cat,'ShowMean',true);
q(1) = gca;
q(1).FontSize = 14;
q(1).XAxis.Visible = 'off';
clearvars -except pows fig4 t ax q psdfileright stimdata


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
ax(2) = nexttile;
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
    plot(ax(2),f1,dat(:,3),'Color',c(i,:),'LineWidth',1)
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
nexttile;
violins1 = violinplot(data,cat,'ShowMean',true);
q(2) = gca;
q(2).FontSize = 14;
q(2).XAxis.Visible = 'off';
clearvars -except fig4 t ax q
%%
%% 02/27 Data
datafile = '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/02-27-2023/Expt1/datafile_corrected_v1.mat';
psdfileleft = '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/02-27-2023/Expt1/aDBS012_2023-02-27_PSD-data_Left_v2.mat';
psdfileright = '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/02-27-2023/Expt1/aDBS012_2023-02-27_PSD-data_Right_v2.mat';
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
ax(3) = nexttile;
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
    plot(ax(3),f1,dat(:,3),'Color',c(i,:),'LineWidth',1)
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
nexttile;
violins1 = violinplot(data,cat,'ShowMean',true);
q(3) = gca;
q(3).FontSize = 14;
q(3).XAxis.Visible = 'off';

clearvars -except fig4 t ax q pows psdfileright

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
ax(4) = nexttile;
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
    plot(ax(4),f1,dat(:,3),'Color',c(i,:),'LineWidth',1)
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
nexttile;
violins1 = violinplot(data,cat,'ShowMean',true);
q(4) = gca;
q(4).FontSize = 14;
q(4).XAxis.Visible = 'off';

ylim(q,[-8,12])
linkaxes(ax,'y');
linkaxes(q,'y');

saveas(gcf,'/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/Figures/Figure 4/PanelA.svg')