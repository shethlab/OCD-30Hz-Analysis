load([load_dir,'vcvsdatafile_corrected.mat']);
data = pows(1).value;
cat = pows(1).high_amp;
inds = find(cat == 0 | cat == 1);
data = data(inds);
cat = cat(inds);
fig4 = figure('Renderer', 'painters', 'Position', [10 10 2000 1200],'Color','w');
subplot(2,6,1)
violins1 = violinplot(data,cat)
q1 = gca;
q1.FontSize = 14;

q1.XAxis.Visible = 'off';
%%
clearvars pows -except power_datafile;
load(power_datafile);
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
