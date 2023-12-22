

load('/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/9-9-2022/datafile_corrected_v4.mat')
version = 1;

%% correlation plot
    figure('Renderer', 'painters', 'Position', [10 10 2000 800],'Color','w');

dat1 = pows(2);
dat2 = pows(5);

if version >1
[~,shared1,shared2] = intersect(dat1.times-0.5,dat2.times);
end
v1 = movavg(dat1.value,"exponential",10);
v2 = movavg(dat2.value',"exponential",5);

vec1 = v1(shared1);
vec2 = v2(shared2);

mdl = fitlm(vec1,vec2);
subplot(3,3,1)

plot(mdl);
legend off
xlabel({'30 Hz Power', '(dB, 1/f corrected, EMA smoothed)'});
ylabel({'Speech Rate', '(Hz, EMA smoothed)'});
title(strcat('R^2 = ',string(mdl.Rsquared.Ordinary)));
ax = gca;
ax.FontSize = 14;
axis square
saveas(gcf,'/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/Figures/Figure 3/Version3/PanelF.png');
