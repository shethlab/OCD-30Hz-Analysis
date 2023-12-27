%reboot;
close all;
clear all;
%addpath(genpath('C:\Users\Nicole\OneDrive\Documents\GitHub\OCD-phaseII\'))
addpath(genpath('C:\Users\Owner\Documents\GitHub\OCD-phaseII\'))
prompt = 'Enter date string for preprocessing (e.g. "2020-01-08"): ';
date = input(prompt);
if isstring(date)
    date = convertStringsToChars(date);
end

prompt = 'Enter subject ID string: ';
subject_id = input(prompt);
if isstring(subject_id)
    subject_id = convertStringsToChars(subject_id);
end

prompt = 'Enter experiment number (0 if none): ';
exp = input(prompt);
if exp==0
    exp_str = '';
else
    exp_str = ['Experiment_',num2str(exp),'\'];
end

task = 'amplitude';
analysis_save_dir_all = 'D:\Amplitude-analysis-results\all_patients\';
loaddir = ['Z:\OCD_Data\preprocessed-new\',subject_id,'\',date,'\',task,'\',exp_str];
loadfile = ['\analysis\',subject_id,'_',date,'_amplitude-analysis_v2.mat'];
load([loaddir,loadfile])

textg = uigetfile([loaddir,'*.TextGrid']);
textgfile = fullfile(loaddir,textg);

a=tgRead(textgfile);
%[wav,Fs]=audioread("audio.wav");
%%
wav = amp_data.audio;
Fs = amp_data.fs_audio;
b=a.tier;
b=a.tier{1};
%%
try
keep=~cellfun(@isempty,b.Label);
rm=~cellfun(@isempty,strfind(b.Label,'*'));
tOn=b.T1(keep&~rm);
tOff=b.T2(keep&~rm);
t=(tOn+tOff)/2;
w=5;
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
%%

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

%%
fig = figure('Renderer', 'painters', 'Position', [10 10 2000 1200]);
offset = 0;

if exp == 6
    offset = -240;
end
h(1)=subplot(511);
plot(tStim+offset,stimValLeft,'Color',"#7E2F8E",'LineWidth',2);
hold on;
plot(tStim+offset,stimValRight,'Color',"#77AC30",'LineWidth',2);
plot(tW+offset,wav*3+2,'Color',"#D95319");
if exp ~=6
    ylabel('DBS Amp. (mA)')
else
    ylabel('DBS Freq. (Hz)')
end
legend({'Left','Right'})

h(2)=subplot(512);
bar(edges((1:end-1))+w/2+offset,n)
%title('Words per second')
ylabel('Words/s (Hz)')

% % % % h(3)=subplot(513);
% % % % yy = smooth(t+offset,wAmp,0.05,'rloess');
% % % % plot(t,wAmp,'.');
% % % % hold on;
% % % % plot(t+offset,yy,'k')
% % % % ylabel({'Word';'Volume'})
% % % % xlim(amp_data.stim_times1([1,end]))
% % % % ts_words_per_second = edges((1:end-1))+w/2+offset;
% % % % words_per_second = n;
% % % % hold on
% % % % linkaxes(h(:),'x')
% % % % if exp ==0
% % % % h(1).XLim = [0,   1.1315e+03];
% % % % else 
% % % %     h(1).XLim = [0,   380];
% % % % end

%xlabel('Seconds')

h(1).FontSize = 14;
h(2).FontSize = 14;
% % % % h(3).FontSize = 14;
%saveas(gcf,[analysis_save_dir,subject_id,'_',date,'_amplitude-analysis_audio.svg'])

%
%xlabel('seconds')
hold_on = 1;
ch1_input = 4;
ch2_input = 4;
spectro = input('Plot Spectrogram? ')
if spectro
    psd_win_size = 1024;
psd_overlap = 512;
upper_freq_lim = 50;
hold_on = 1;
specaxes = plot_spectrogram_nans2(amp_data.lfp(1).combinedDataTable(:,3:6),amp_data.lfp(2).combinedDataTable(:,3:6),ch1_input,ch2_input,start_ind1,end_ind1,start_ind2,end_ind2,hold_on,amp_data.channels,psd_win_size,psd_overlap,upper_freq_lim,fig);
ch_inputs = ['L-',num2str(ch1_input),'_R-',num2str(ch2_input)];
xlimits = [cell2mat(xlim(h)); cell2mat(xlim(specaxes))];
xupperlim = min(xlimits(:,2));
linkaxes([specaxes,h],'x');
xlim([0,xupperlim]);
saveas(gcf,[analysis_save_dir_all,subject_id,'_',date,'_amplitude-analysis_spectrogram_aud_',num2str(exp),'_',ch_inputs,'.png'])
saveas(gcf,[analysis_save_dir_all,subject_id,'_',date,'_amplitude-analysis_spectrogram_aud_',num2str(exp),'_',ch_inputs,'.svg'])
end
%%
% % % % linkaxes(h(:),'x')
% % % % save('Z:\OCD_Data\preprocessed-new\aDBS012\2022-09-09\amplitude\analysis\wps.mat','ts_words_per_second','words_per_second')
% % % % 
% % % % h(5)=subplot(615);
% % % % [~,f,t,tf]=spectrogram(ch_1,250,125,250,500);
% % % % yyaxis right
% % % % plot(tStim,stimVal);
% % % % ylabel('Stim Amplitude (mA)')
% % % % 
% % % % hold on
% % % % yyaxis left
% % % % plot(t,cnelab_TF_Smooth(log(abs(tf(f_plot,:))),'gaussian',[1,10]))
% % % % b1 = smooth(log(abs(tf(f_plot,:))),20);
% % % % plot(t,b1)
% % % % ylabel('Beta (29-31 Hz) Power [dB]')
% % % % 
% % % % h(6)=subplot(616);
% % % % [~,f,t,tf]=spectrogram(ch_2,250,125,250,500);
% % % % yyaxis right
% % % % plot(tStim,stimVal);
% % % % ylabel('Stim Amplitude (mA)')
% % % % 
% % % % hold on
% % % % yyaxis left
% % % % plot(t,cnelab_TF_Smooth(log(abs(tf(f_plot,:))),'gaussian',[1,10]))
% % % % b2 = smooth(log(abs(tf(f_plot,:))),20);
% % % % plot(t,b2)
% % % % ylabel('Beta (29-31 Hz) Power [dB]')
% % % % xlabel('Seconds')
% % % % ax6.XLim = ax1.XLim;
% % % % ax5.XLim =ax1.XLim;
% % % % linkaxes(h,'x')
% % % % 
% % % % 
% % % % %
% % % % figure(2);clf;
% % % % subplot(121);hold on;
% % % % w=.05;
% % % % edges=0:w:max(wordL);
% % % % [n,edges]=histcounts(wordL(indStim),edges);
% % % % n=n/sum(n);
% % % % [n2,edges]=histcounts(wordL(~indStim),edges);
% % % % n2=n2/sum(n2);
% % % % bar(edges((1:end-1))+w/2,[n;n2]','hist')
% % % % legend('Stimulation On','Stimulation Off')
% % % % xlabel('s')
% % % % ylabel('n')
% % % % title('Word Length')
% % % % subplot(122);hold on;
% % % % 
% % % % w=.01;
% % % % edges=0:w:max(wAmp);
% % % % [n,edges]=histcounts(wAmp(indStim),edges);
% % % % n=n/sum(n);
% % % % [n2,edges]=histcounts(wAmp(~indStim),edges);
% % % % n2=n2/sum(n2);
% % % % bar(edges((1:end-1))+w/2,[n;n2]','hist')
% % % % legend('Stimulation On','Stimulation Off')
% % % % xlabel('RMS')
% % % % ylabel('n')
% % % % title('Word Amplitude')
