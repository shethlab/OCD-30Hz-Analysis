close all;
clear all;
%% Load Files
load_dir = '/Users/sameerrajesh/Desktop/30Hz Project Data/2022-09-09/';
amp_analysis_file = [load_dir,'AnalysisFiles/amplitude/2022-09-09_amplitude-analysis.mat'];
tg = strcat(load_dir,'AudioData/2022-09-09_audio_amplitude.TextGrid');
psdfile = [load_dir,'AnalysisFiles/amplitude/2022-09-09_PSD-data_Left.mat'];
power_datafile = [load_dir,'AnalysisFiles/amplitude/datafile_corrected_v4.mat'];
vcvs_datafile = [load_dir,'AnalysisFiles/amplitude/vcvsdatafile_corrected_v4.mat'];
fig_num = 2;
savedir = '/Users/sameerrajesh/Desktop/30Hz Project Data/Figures/Figure 2/';
if ~isdir(savedir)
    mkdir(savedir);
end

%% Load
load(amp_analysis_file);
load(power_datafile);
a=tgRead(tg);
% Audio Info
wav = amp_data.audio;
Fs = amp_data.fs_audio;
% Praat Code
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

    stimValLeft=amp_data.stim_changes1(:,1);
    stimValRight=amp_data.stim_changes2(:,1);

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


%% Figure 2

%% Panel ABC
plotPSDs(psdfile,'Left',fig_num);
saveas(gcf,strcat(savedir,'PanelABCpsds.svg'));
close all
%% Panel E
plotViolinsFigure2(vcvs_datafile,power_datafile);
saveas(gcf,strcat(savedir,'PanelABCviolins.svg'));
close all
%% Intermediate Plots (for correct axis scaling)

fig1 = figure('Renderer', 'painters', 'Position', [10 10 2000 1200],'Color','w');
offset = 0;

% Plot Stim
h(1)=subplot(8,1,4);
plot(tStim+offset,stimValLeft,'Color',"#7E2F8E",'LineWidth',2);
hold on;
plot(tStim+offset,stimValRight,'Color',"#77AC30",'LineWidth',2);
legend({'Left','Right'})
    ylabel('DBS Amp. (mA)')

box off
set(gca,'TickLength',[0.005, 0.01])
q = gca;
q.XAxis.Visible = 'off';
h(1).FontSize = 14;

% Plot Audio
fig2 = figure('Renderer', 'painters', 'Position', [10 10 2000 1200],'Color','w');
h(2) = subplot(8,1,2);
plot(downsample(tW+offset,1),downsample(wav*3+2,1),'Color',"#D95319");
ylabel({'Audio', 'Amplitude (a.u.)'});
set(gca,'TickLength',[0.005, 0.01])
box off
q = gca;
q.XAxis.Visible = 'off';
h(2).FontSize = 14;

%% Panel E
fig3 = figure('Renderer', 'painters', 'Position', [10 10 2000 1200],'Color','w');

% Plot Power
h(3) = subplot(10,1,[2 3 4]);
hold on;
plot(pows(2).times,movavg(pows(2).value,"exponential",10),'LineStyle','-','Color','r','LineWidth',1.5);
ylabel({'30 Hz Power', '(dB, 1/f Corrected)'})
%ylim([3 15])
ylim([-inf,inf])
yticks([3,6,9,12,15]);
q = gca;
q.XAxis.Visible = 'off';
h(3).YAxis.Color = 'r';
h(3).FontSize = 14;


% Plot Pitch
pitch = readmatrix([load_dir,'AudioData/PitchData.csv']);
pitch = pitch(~isnan(pitch(:,1)),:);
h(4) = subplot(10,1,[5 6 7]);
%bar(pitch(:,1),pitch(:,2),'FaceColor',[0.8 0.8 0.9]);
hold on;
plot(pitch(:,1),movavg(pitch(:,2),'exponential',10),'Color','#77AC30','LineWidth',1.5);
ylabel('Pitch (Hz)'); 
h(4).YAxis.Color = '#77AC30';
q = gca;
q.XAxis.Visible = 'off';
box off
h(4).FontSize = 14;
ylim([-inf,inf])


% Plot Speech Rate


h(5) = subplot(10,1,[8 9 10]);
%bar(pows(5).times,pows(5).value,'FaceColor',[0.8 0.8 0.9]);
hold on;
plot(pows(5).times,movavg(pows(5).value',"exponential",5),'LineStyle','-','Color','b','LineWidth',1.5);
q = gca;
%q.XAxis.Visible = 'off';
%ylim([0,8])
ylim([-inf,inf])
yticks([0,2,4,6])
ylabel('Words/s (Hz)')
box off
h(5).FontSize = 14;
h(5).YAxis.Color = 'b';


specaxes = spectrogramPlot(amp_data.lfp(1).combinedDataTable(:,6),1,start_ind1,end_ind1,0,'Left ',{'vlPFC'},50);
xlimits = [cell2mat(xlim(h)); xlim(specaxes)];
xupperlim = min(xlimits(:,2));
linkaxes([specaxes,h],'x');
xlim([0,xupperlim]);
%%

saveas(gcf,strcat(savedir,'PanelD.svg'));
saveas(fig3,strcat(savedir,'PanelE.svg'));
saveas(fig1,strcat(savedir,'Amplitude.svg'));





