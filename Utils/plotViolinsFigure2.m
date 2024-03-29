function plotViolinsFigure2(vcvsfile,ecogfile)

fig4 = figure('Renderer', 'painters', 'Position', [10 10 2000 1200],'Color','w');

%% VCVS Violins
load(vcvsfile);
data = pows(1).value;
cat = pows(1).high_amp;
inds = find(cat == 0 | cat == 1);
data = data(inds);
cat = cat(inds);
subplot(2,6,1)
violins1 = violinplot(data,cat)
q1 = gca;
q1.FontSize = 14;
q1.XAxis.Visible = 'off';

%% OFC Violins
clearvars pows -except ecogfile;
load(ecogfile);
data = pows(1).value;
cat = pows(1).high_amp;
inds = find(cat == 0 | cat == 1);
data = data(inds);
cat = cat(inds);
subplot(2,6,2)
violins2 = violinplot(data,cat)
q2 = gca;
q2.FontSize = 14;
q2.XAxis.Visible = 'off';

%% vlPFC violins
data = pows(2).value;
cat = pows(2).high_amp;
inds = find(cat == 0 | cat == 1);
data = data(inds);
cat = cat(inds);
subplot(2,6,3)
violins3 = violinplot(data,cat)
q3 = gca;
q3.FontSize = 14;
q3.XAxis.Visible = 'off';

linkaxes([q1,q2,q3],'y');




end