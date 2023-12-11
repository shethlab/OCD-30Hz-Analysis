close all;
clear all;
%% Load Files
load_dir = '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/9-9-2022/';
amp_analysis_file = [load_dir,'/aDBS012_2022-09-09_amplitude-analysis_v2.mat'];
textgrid = [load_dir,'aDBS012_2022-09-09_audio_amplitude.TextGrid'];
psdfile = [load_dir,'aDBS012_2022-09-09_PSD-data_Left_v2.mat'];
fig_num = 3;


power_datafile = [load_dir,'datafile_corrected_v1.mat'];
savedir = '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/Figures/Figure 3/Version1';
exp = 0;

%% Load
load(amp_analysis_file);
load(power_datafile);
a=tgRead(textgrid);
%% Audio Info
wav = amp_data.audio;
Fs = amp_data.fs_audio;
%% Praat Code
b=a.tier;
b=a.tier{1};

try
keep=~cellfun(@isempty,b.Label);
rm=~cellfun(@isempty,strfind(b.Label,'*'));
tOn=b.T1(keep&~rm);
tOff=b.T2(keep&~rm);
t=(tOn+tOff)/2;
w = 2;
edges=0:w:max(tOn);
[n,edges]=histcounts(tOn,edges);
n=n/w;
wAmp=zeros(1,length(t));
tW=(1:length(wav))/Fs;
for i=1:length(t)
    wAmp(i)=rms(wav(tW>tOn(i)&tW<tOff(i)));
end
catch
    t = [];
    n = [];
    edges = [];
    wAmp =[];
    tW=(1:length(wav))/Fs;
    w = [];
end


%% Stim Info

tStim=amp_data.stim_times1;
if exp ~=6
    stimValLeft=amp_data.stim_changes1(:,1);
    stimValRight=amp_data.stim_changes2(:,1);
else
    stimValLeft=amp_data.stim_changes1(:,3);
    stimValRight=amp_data.stim_changes2(:,3);
end
if length(tStim) >2
stimOn=tStim(stimValLeft>0);
stimOn=reshape(stimOn,[2,length(stimOn)/2]);
indStim=zeros(size(t));
for i=1:size(stimOn,1)
    indStim=indStim+(t>stimOn(1,i)&t<stimOn(2,i));
end
indStim=logical(indStim);
else
    indStim = [1 1];
end

%% chop time domain data to experiment time 
if exp ~=6
    start_ind1 = find(round(amp_data.ts1,3) == round(amp_data.DBS_low_times(1,1),2));
    if isempty(start_ind1)
        start_ind1 = find(round(amp_data.ts1-0.001,3) == round(amp_data.DBS_low_times(1,1),2));
    end
    end_ind1 = find(round(amp_data.ts1,3) == round(amp_data.DBS_clin_times(1,2),2));
    if isempty(end_ind1)
        end_ind1 = find(round(amp_data.ts1-0.001,3) == round(amp_data.DBS_clin_times(1,2),2));
    end
    start_ind2 = find(round(amp_data.ts2,3) == round(amp_data.DBS_low_times(1,1),2));
    if isempty(start_ind2)
        start_ind2 = find(round(amp_data.ts2-0.001,3) == round(amp_data.DBS_low_times(1,1),2));
    end
    end_ind2 = find(round(amp_data.ts2,3) == round(amp_data.DBS_clin_times(1,2),2));
    if isempty(end_ind2)
        end_ind2 = find(round(amp_data.ts2-0.001,3) == round(amp_data.DBS_clin_times(1,2),2));
    end
else
    start_ind1 = find(round(amp_data.ts1,3) == round(amp_data.DBS_high_times(1,1),2));
    if isempty(start_ind1)
        start_ind1 = find(round(amp_data.ts1-0.001,3) == round(amp_data.DBS_high_times(1,1),2));
    end
    end_ind1 = find(round(amp_data.ts1,3) == round(amp_data.DBS_clin_times(1,2),2));
    if isempty(end_ind1)
        end_ind1 = find(round(amp_data.ts1-0.001,3) == round(amp_data.DBS_clin_times(1,2),2));
    end
    start_ind2 = find(round(amp_data.ts2,3) == round(amp_data.DBS_high_times(1,1),2));
    if isempty(start_ind2)
        start_ind2 = find(round(amp_data.ts2-0.001,3) == round(amp_data.DBS_high_times(1,1),2));
    end
    end_ind2 = find(round(amp_data.ts2,3) == round(amp_data.DBS_clin_times(1,2),2));
    if isempty(end_ind2)
        end_ind2 = find(round(amp_data.ts2-0.001,3) == round(amp_data.DBS_clin_times(1,2),2));
    end
end

%% Figure 3

%% Panel A +C
fig1 = figure('Renderer', 'painters', 'Position', [10 10 2000 1200],'Color','w');
offset = 0;
if exp == 6
    offset = -240;
end

%
h(1)=subplot(8,1,4);
plot(tStim+offset,stimValLeft,'Color',"#7E2F8E",'LineWidth',2);
hold on;
plot(tStim+offset,stimValRight,'Color',"#77AC30",'LineWidth',2);
legend({'Left','Right'})
if exp ~=6
    ylabel('DBS Amp. (mA)')
else
    ylabel('DBS Freq. (Hz)')
end
box off
set(gca,'TickLength',[0.005, 0.01])
q = gca;
q.XAxis.Visible = 'off';
h(1).FontSize = 14;

%
fig2 = figure('Renderer', 'painters', 'Position', [10 10 2000 1200],'Color','w');
h(2) = subplot(8,1,2);
plot(downsample(tW+offset,1),downsample(wav*3+2,1),'Color',"#D95319");
ylabel({'Audio', 'Amplitude (a.u.)'});
set(gca,'TickLength',[0.005, 0.01])
box off
q = gca;
q.XAxis.Visible = 'off';
h(2).FontSize = 14;

%%
fig3 = figure('Renderer', 'painters', 'Position', [10 10 2000 1200],'Color','w');
h(3) = subplot(10,1,[6 7 8 9]);
yyaxis left
bar(pows(5).times,pows(5).value,'FaceColor',[0.8 0.8 0.9]);
q = gca;
q.XAxis.Visible = 'off';
hold on;
plot(pows(5).times,movavg(pows(5).value',"exponential",5),'LineStyle','-','Color','b','LineWidth',1.5);
q = gca;
q.XAxis.Visible = 'off';
ylim([0,10])
ylabel('Words/s (Hz)')
box off
h(3).FontSize = 14;

%
%h(4) = subplot(10,1,[5 6 7]);
yyaxis right
%scatter(pows(2).times,pows(2).value,3,'k','filled');
hold on;
plot(pows(2).times,movavg(pows(2).value,"exponential",10),'LineStyle','-','Color','r','LineWidth',1.5);

ylabel({'30 Hz Power', '(dB, 1/f Corrected)'})
ylim([-7 7])
yticks([-7,-3.5,0,3.5,7]);
q = gca;
q.XAxis.Visible = 'off';
%h(4).FontSize = 14;
h(3).YAxis(1).Color = 'b';
h(3).YAxis(2).Color = 'r';

%% Panel B
specaxes = spectrogramPlot(amp_data.lfp(1).combinedDataTable(:,6),1,start_ind1,end_ind1,0,'Left ',{'Lateral OFC'},50);
xlimits = [cell2mat(xlim(h)); xlim(specaxes)];
xupperlim = min(xlimits(:,2));
linkaxes([specaxes,h],'x');
xlim([0,xupperlim]);
saveas(gcf,strcat(savedir,'PanelB.svg'));

saveas(fig1,strcat(savedir,'PanelA1.svg'));
saveas(fig2,strcat(savedir,'PanelA2.svg'));
saveas(fig3,strcat(savedir,'PanelC.svg'));
close all
%% Panel D
plotPSDs(psdfile,'Left',fig_num);
saveas(gcf,strcat(savedir,'PanelD.svg'));


%% Panel E
plotViolinsSVR;
saveas(gcf,strcat(savedir,'PanelE.svg'));
close all
