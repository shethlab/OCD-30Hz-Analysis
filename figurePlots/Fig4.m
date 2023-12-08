fig4 = figure('Renderer', 'painters', 'Position', [10 10 2000 1200],'Color','w');

t = tiledlayout(2,2);

%% 11/15 Data
datafile = '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/11-15-2022/datafile_corrected_v1.mat';
psdfile = '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/11-15-2022/aDBS012_2022-11-15_PSD-data_Left_v2.mat';
load(datafile);
load(psdfile);
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
for i = 1:5
    switch i
        case 1
            dat = low1;
        case 2
            dat = high1;
        case 3
            dat = low2;
        case 4
            dat = high2;
        case 5
            dat = clin1;
    end
    hold on;
    plot(ax(1),f1,dat(:,3),'Color',c(i,:),'LineWidth',1)
    hold on;
    if i == 5


        title(ax(1),['Left lOFC']);

        ylabel(ax(1),'Power (dB)');
        xlabel(ax(1),'Frequency (Hz)');
    end
    box off


end


ax(1).XLim = [0,upper_freq_lim];
xticks(ax(1),[0 10 20 30 40 50]);
ax(1).FontSize = 14;
legend(ax(1),{'Low 1','High 1','Low 2', 'High 2','Clinical'})

% Violins
data = pows(2).value;
cat = pows(2).high_amp;
inds = find(cat == 0 | cat == 1);
data = data(inds);
cat = cat(inds);
nexttile;
violins1 = violinplot(data,cat);
q1 = gca;
q1.FontSize = 14;
q1.XAxis.Visible = 'off';
clearvars -except fig4 t ax q1
%%
%% 11/15 Data
datafile = '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/02-27-2023/Expt1/datafile_corrected_v1.mat';
psdfile = '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/02-27-2023/Expt1/aDBS012_2023-02-27_PSD-data_Left_v2.mat';
load(datafile);
load(psdfile);
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
for i = 1:5
    switch i
        case 1
            dat = low1;
        case 2
            dat = high1;
        case 3
            dat = low2;
        case 4
            dat = high2;
        case 5
            dat = clin1;
    end
    hold on;
    plot(ax(2),f1,dat(:,3),'Color',c(i,:),'LineWidth',1)
    hold on;
    if i == 5


        title(ax(2),['Left lOFC']);

        ylabel(ax(2),'Power (dB)');
        xlabel(ax(2),'Frequency (Hz)');
    end
    box off


end


ax(2).XLim = [0,upper_freq_lim];
xticks(ax(2),[0 10 20 30 40 50]);
ax(2).FontSize = 14;
legend(ax(2),{'Low 1','High 1','Low 2', 'High 2','Clinical'})

% Violins
data = pows(2).value;
cat = pows(2).high_amp;
cat(cat==3)=1;
inds = find(cat == 0 | cat == 1);
data = data(inds);
cat = cat(inds);
nexttile;
violins1 = violinplot(data,cat);
q2 = gca;
q2.FontSize = 14;
q2.XAxis.Visible = 'off';


linkaxes(ax,'y');
linkaxes([q1,q2],'y');