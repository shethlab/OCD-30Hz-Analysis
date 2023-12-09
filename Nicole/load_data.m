
code_path = 'C:\Users\Nicole\OneDrive\Documents\GitHub\OCD-30Hz-Analysis\';
addpath(genpath(code_path))

data_path = 'D:\Amplitude Data\';
addpath(genpath(data_path))

save_path = 'D:\Amplitude Data\Figures4\';
addpath(genpath(save_path))

dates = {'09092022';'09192022';'10042022';'11152022';'02272023exp1';'02272023exp2';'02272023exp4';'02272023exp5'};

R_P_EMA = zeros(8,2);
R_P_RAW = zeros(8,2);
idx = 3;

for i = 1:8
load([data_path,dates{i},'\',['datafile_corrected',dates{i},'.mat']]);
%load([data_path,dates{i},'\',['datafile',dates{i},'.mat']]);

%% plot left lateral OFC data with speech 
close all
fig = figure('Renderer', 'painters', 'Position', [10 10 2000 800],'Color','w');

h(1) = subplot(10,1,1);
plot(pows(idx).times,pows(idx).high_amp,'Color','k');
ax = gca;
ax.XLim = [0,pows(idx).times(end)];
axis off
box off 
title(dates{i})

h(2) = subplot(10,1,[2:10]);
scatter(pows(idx).times,pows(idx).value,3,'k','filled');
hold on
yyaxis left
pow_EMA = movavg(pows(idx).value,"exponential",10);
plot(pows(idx).times,pow_EMA,'Color','b','LineWidth',1);
ylabel('30 Hz Power');
yyaxis right

% try speech_EMA = movavg(pows(5).value',"exponential",5);
% catch
%     pows(5).value = zeros(size(pows(2).value));
% end
try speech_EMA = movavg(pows(5).value',"exponential",5);
catch speech_EMA = movavg(pows(5).value,"exponential",5);
end
plot(pows(5).times,speech_EMA,'Color','r','LineWidth',1);
ylabel('Speech Rate (words/s)')
ax = gca;
ax.YLim = [0,8];
xlabel('Seconds')
ax.XLim = [0,pows(idx).times(end)];

grid on

h(1).FontSize = 14;
h(2).FontSize = 14;

saveas(fig,[save_path,dates{i},'_data',num2str(idx),'.png'])
close all

%% scatter speech vs. 30 hz
fig = figure('Renderer', 'painters', 'Position', [10 10 1200 600],'Color','w');
lag = 0;

subplot(1,2,1)
[~,shareda,sharedb] = intersect(pows(idx).times,pows(5).times);
x = pows(idx).value(shareda(1:(end-lag)));
y = pows(5).value(sharedb((lag+1):end))';
scatter(x,y,3,'k','filled');
ylabel({[dates{i},', lag = ',num2str(lag*2),' s'];'Speech Rate (words/s)'})
xlabel('30 Hz Power');
[R,P] = corrcoef(x,y);
R_P_RAW(i,1) = R(1,2);
R_P_RAW(i,2) = P(1,2);
title({'Raw Data';['R = ',num2str(R(1,2)),' p = ',num2str(P(1,2))]})


subplot(1,2,2)
[~,shareda,sharedb] = intersect(pows(idx).times,pows(5).times);
x = pow_EMA(shareda(1:(end-lag)));
y = speech_EMA(sharedb((lag+1):end))';
scatter(x,y,3,'k','filled');
ylabel('Speech Rate (words/s)')
xlabel('30 Hz Power');
[R,P] = corrcoef(x,y);
R_P_EMA(i,1) = R(1,2);
R_P_EMA(i,2) = P(1,2);
title({'EMA Data';['R = ',num2str(R(1,2)),' p = ',num2str(P(1,2))]})
saveas(fig,[save_path,dates{i},'_corr_lag',num2str(lag*2),'_',num2str(idx),'.png'])



end

close all;

save([save_path,'corr_p_lag',num2str(idx),'.mat'],'R_P_EMA','R_P_RAW','lag')
writematrix(R_P_EMA,[save_path,'corr_p_lag',num2str(idx),'.csv'])
%% high/low distributions of 30 Hz power on each day 
fig3 = figure('Renderer', 'painters', 'Position', [10 10 600 1200],'Color','w');

for i = 1:4
    load([data_path,dates{i},'\',['datafile_corrected',dates{i},'.mat']]);
    pow_EMA = movavg(pows(idx).value,"exponential",10);
    try speech_EMA = movavg(pows(5).value',"exponential",5);
    catch speech_EMA = movavg(pows(5).value,"exponential",5);
    end
    high = pow_EMA(find(pows(idx).high_amp));
    low = pow_EMA(find(pows(idx).high_amp==0));
    
    % power 
subplot(4,2,2*(i-1)+1)
    histogram(high,'BinWidth',0.2)
    hold on
    histogram(low,'BinWidth',0.2)
    legend({'high';'low'})
    xlabel('30 Hz Power')
    ylabel('Count')
subplot(4,2,2*(i-1)+2)
    boxplot(pow_EMA,pows(idx).high_amp')
    [j,p] = ttest2(high,low);
    title({dates{i};['p=',num2str(p)]});
end
    saveas(fig3,[save_path,'_dists_pow',num2str(lag*2),'_',num2str(idx),'.png'])

%% speech hist
fig4 = figure('Renderer', 'painters', 'Position', [10 10 600 1200],'Color','w');

for i = 1:4
    load([data_path,dates{i},'\',['datafile_corrected',dates{i},'.mat']]);
    pow_EMA = movavg(pows(idx).value,"exponential",10);
    try speech_EMA = movavg(pows(5).value',"exponential",5);
    catch speech_EMA = movavg(pows(5).value,"exponential",5);
    end
    [~,shareda,sharedb] = intersect(pows(idx).times,pows(5).times);
    high_shared = find(pows(idx).high_amp(shareda));
    high = speech_EMA(high_shared);
    low_shared = find(pows(idx).high_amp(shareda)==0);
    low = speech_EMA(low_shared);

    % power 
subplot(4,2,2*(i-1)+1)
    histogram(high,'BinWidth',0.2)
    hold on
    histogram(low,'BinWidth',0.2)
    legend({'high';'low'})
    xlabel('Speech Rate (words/s)')
    ylabel('Count')
subplot(4,2,2*(i-1)+2)
    boxplot(speech_EMA(sharedb),pows(idx).high_amp(shareda)')
    [j,p] = ttest2(high,low);
    title({dates{i};['p=',num2str(p)]});
end
    saveas(fig4,[save_path,'_dists_speech',num2str(lag*2),'_',num2str(idx),'.png'])

% %%
% lag0 = load([save_path,'corr_p_lag0']);
% lag2 = load([save_path,'corr_p_lag2']);
% lag4 = load([save_path,'corr_p_lag4']);
% lag6 = load([save_path,'corr_p_lag6']);
% 
% lags = [0,2,4,6]';
% fig = figure('Renderer', 'painters', 'Position', [10 10 800 1200],'Color','w');
% for i =1:4
%     plot_r_p;
% end
% saveas(fig,[save_path,'_lag_summary.png'])
