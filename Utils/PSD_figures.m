close all;
psd_win_size = 1024;
psd_overlap = 512;
upper_freq_lim = 55;
%leg_position = [.5 .5 .05 .03];
leg_position = [.5 .48 .05 .03];

log_bool = 1;
tag = 'v2';

low_amp1 = min(amp_data.stim_changes1(:,1)); 
low_amp2 = min(amp_data.stim_changes2(:,1)); 
high_amp1 = max(amp_data.stim_changes1(:,1)); 
high_amp2 = max(amp_data.stim_changes2(:,1));
clin_amp1 = amp_data.clin_amp_left; 
clin_amp2 = amp_data.clin_amp_right;

pw1 = [num2str(amp_data.stim_changes1(1,2)),' us'];
freq1 = [sprintf('%05.1f', amp_data.stim_changes1(1,3)),' Hz'];
pw2 = [num2str(amp_data.stim_changes2(1,2)),' us'];
freq2 = [sprintf('%05.1f', amp_data.stim_changes2(1,3)),' Hz'];

stimc1 = amp_data.lfp(1).simple_stim_log.Contact{1};  
i=1;
while strcmp(stimc1,'None')
    stimc1 = amp_data.lfp(1).simple_stim_log.Contact{i+1};
    i = i+1;
end

stimc2 = amp_data.lfp(2).simple_stim_log.Contact{1};  
i=1;
while strcmp(stimc2,'None')
    stimc2 = amp_data.lfp(2).simple_stim_log.Contact{i+1};
    i = i+1;
end

c = [31 195 255;...
    251 86 59;...
    0 108 255;...
    237 28 36;...
    %0 38 255;...
    57 181 74]/255;

% hold_on = 0;    
% [ax1,~,~,~,~,~] = plot_PSD_nans(dat1,'Left',trial_inds_low1{1},hold_on,amp_data.channels(:,1),psd_win_size,psd_overlap,upper_freq_lim,log_bool);
% hold_on = 1;
% [ax1,~,~,~,~,~] = plot_PSD_nans(dat1,'Left',trial_inds_low1{2},hold_on,amp_data.channels(:,1),psd_win_size,psd_overlap,upper_freq_lim,log_bool);
% [ax1,~,~,~,~,~] = plot_PSD_nans(dat1,'Left',trial_inds_clin1{1},hold_on,amp_data.channels(:,1),psd_win_size,psd_overlap,upper_freq_lim,log_bool);
% leg1 = legend({'OFF 1';'OFF 2';'OFF 3'},'Orientation','horizontal');
% set(leg1,'Position',leg_position);
% sgtitle('Left Hemisphere DBS LOW') 
% saveas(gcf,[analysis_save_dir,subject_id,'_',date,'_amplitude-analysis_OFF-Left_',tag,'.png'])
% saveas(gcf,[analysis_save_dir,subject_id,'_',date,'_amplitude-analysis_OFF-Left_',tag,'.svg'])

% hold_on = 0;    
% [ax1,~,~,~,~,~] = plot_PSD_nans(dat2,'Right',trial_inds_low2{1},hold_on,amp_data.channels(:,2),psd_win_size,psd_overlap,upper_freq_lim,log_bool);
% hold_on = 1;
% [ax1,~,~,~,~,~] = plot_PSD_nans(dat2,'Right',trial_inds_low2{2},hold_on,amp_data.channels(:,2),psd_win_size,psd_overlap,upper_freq_lim,log_bool);
% [ax1,~,~,~,~,~] = plot_PSD_nans(dat2,'Right',trial_inds_clin2{1},hold_on,amp_data.channels(:,2),psd_win_size,psd_overlap,upper_freq_lim,log_bool);
% leg1 = legend({'OFF 1';'OFF 2';'OFF 3'},'Orientation','horizontal');
% set(leg1,'Position',leg_position);
% %sgtitle('Right Hemisphere DBS LOW') 
% saveas(gcf,[analysis_save_dir,subject_id,'_',date,'_amplitude-analysis_OFF-Right_',tag,'.png'])
% saveas(gcf,[analysis_save_dir,subject_id,'_',date,'_amplitude-analysis_OFF-Right_',tag,'.svg'])

% hold_on = 0;    
% [ax1,~,~,~,~,~] = plot_PSD_nans(dat1,'Left',trial_inds_high1{1},hold_on,amp_data.channels(:,1),psd_win_size,psd_overlap,upper_freq_lim,log_bool);
% hold_on = 1;
% [ax1,~,~,~,~,~] = plot_PSD_nans(dat1,'Left',trial_inds_high1{2},hold_on,amp_data.channels(:,1),psd_win_size,psd_overlap,upper_freq_lim,log_bool);
% leg1 = legend({'ON1';'ON2'},'Orientation','horizontal');
% set(leg1,'Position',leg_position);
% %sgtitle('Left Hemisphere DBS HIGH') 
% saveas(gcf,[analysis_save_dir,subject_id,'_',date,'_amplitude-analysis_ON-Left_',tag,'.png'])
% 
% hold_on = 0;    
% [ax1,~,~,~,~,~] = plot_PSD_nans(dat2,'Right',trial_inds_high2{1},hold_on,amp_data.channels(:,2),psd_win_size,psd_overlap,upper_freq_lim,log_bool);
% hold_on = 1;
% [ax1,~,~,~,~,~] = plot_PSD_nans(dat2,'Right',trial_inds_high2{2},hold_on,amp_data.channels(:,2),psd_win_size,psd_overlap,upper_freq_lim,log_bool);
% leg1 = legend({'HIGH1';'HIGH2'},'Orientation','horizontal');
% set(leg1,'Position',leg_position);
% %sgtitle('Right Hemisphere DBS HIGH') 
% saveas(gcf,[analysis_save_dir,subject_id,'_',date,'_amplitude-analysis_ON-Right_',tag,'.png'])

hold_on = 0;    
[ax1,f1,mean_psdMat1_low1,mean_psdMat2_low1,mean_psdMat3_low1,mean_psdMat4_low1] = plot_PSD_nans(dat1,'Left',trial_inds_low1{1},hold_on,amp_data.channels(:,1),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(1,:));
hold_on = 1;
[ax1,f1,mean_psdMat1_high1,mean_psdMat2_high1,mean_psdMat3_high1,mean_psdMat4_high1] = plot_PSD_nans(dat1,'Left',trial_inds_high1{1},hold_on,amp_data.channels(:,1),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(2,:));
[ax1,f1,mean_psdMat1_low2,mean_psdMat2_low2,mean_psdMat3_low2,mean_psdMat4_low2] = plot_PSD_nans(dat1,'Left',trial_inds_low1{2},hold_on,amp_data.channels(:,1),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(3,:));
[ax1,f1,mean_psdMat1_high2,mean_psdMat2_high2,mean_psdMat3_high2,mean_psdMat4_high2] = plot_PSD_nans(dat1,'Left',trial_inds_high1{2},hold_on,amp_data.channels(:,1),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(4,:));
[ax1,f1,mean_psdMat1_clin1,mean_psdMat2_clin1,mean_psdMat3_clin1,mean_psdMat4_clin1] = plot_PSD_nans(dat1,'Left',trial_inds_clin1{1},hold_on,amp_data.channels(:,1),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(5,:));

leg1 = legend({['A: ',num2str(low_amp1),' mA'];['B: ',num2str(high_amp1),' mA'];['C: ',num2str(low_amp1),' mA'];['D: ',num2str(high_amp1),' mA'];['E: ',num2str(clin_amp1),' mA']},'Location','eastoutside','Orientation','horizontal','NumColumns',5,'FontSize',11);
set(leg1,'Position',leg_position);
temp= ax1(1).Title.String;
ax1(1).Title.String = [temp,': ',stimc1,', ',pw1,', ',freq1];
sgtitle([subject_id,': ',date],'FontSize',18);
low1 = [mean_psdMat1_low1,mean_psdMat2_low1,mean_psdMat3_low1,mean_psdMat4_low1];
low2 = [mean_psdMat1_low2,mean_psdMat2_low2,mean_psdMat3_low2,mean_psdMat4_low2];
high1 = [mean_psdMat1_high1,mean_psdMat2_high1,mean_psdMat3_high1,mean_psdMat4_high1];
high2 = [mean_psdMat1_high2,mean_psdMat2_high2,mean_psdMat3_high2,mean_psdMat4_high2];
clin1 = [mean_psdMat1_clin1,mean_psdMat2_clin1,mean_psdMat3_clin1,mean_psdMat4_clin1];
save([analysis_save_dir,subject_id,'_',date,'_PSD-data_Left_',tag,'.mat'],'f1','low1','low2','high1','high2','clin1')
saveas(gcf,[analysis_save_dir,subject_id,'_',date,'_amplitude-analysis_ON-OFF-Left_',tag,'.png'])
saveas(gcf,[analysis_save_dir,subject_id,'_',date,'_amplitude-analysis_ON-OFF-Left_',tag,'.svg'])
saveas(gcf,[analysis_save_dir_all,subject_id,'_',date,'_amplitude-analysis_Left_',num2str(exp),'_',tag,'.png'])

hold_on = 0;    
[ax1,f1,mean_psdMat1_low1,mean_psdMat2_low1,mean_psdMat3_low1,mean_psdMat4_low1] = plot_PSD_nans(dat2,'Right',trial_inds_low2{1},hold_on,amp_data.channels(:,2),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(1,:));
hold_on = 1;
[ax1,f1,mean_psdMat1_high1,mean_psdMat2_high1,mean_psdMat3_high1,mean_psdMat4_high1] = plot_PSD_nans(dat2,'Right',trial_inds_high2{1},hold_on,amp_data.channels(:,2),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(2,:));
[ax1,f1,mean_psdMat1_low2,mean_psdMat2_low2,mean_psdMat3_low2,mean_psdMat4_low2] = plot_PSD_nans(dat2,'Right',trial_inds_low2{2},hold_on,amp_data.channels(:,2),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(3,:));
[ax1,f1,mean_psdMat1_high2,mean_psdMat2_high2,mean_psdMat3_high2,mean_psdMat4_high2] = plot_PSD_nans(dat2,'Right',trial_inds_high2{2},hold_on,amp_data.channels(:,2),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(4,:));
[ax1,f1,mean_psdMat1_clin1,mean_psdMat2_clin1,mean_psdMat3_clin1,mean_psdMat4_clin1] = plot_PSD_nans(dat2,'Right',trial_inds_clin2{1},hold_on,amp_data.channels(:,2),psd_win_size,psd_overlap,upper_freq_lim,log_bool,c(5,:));

leg1 = legend({['A: ',num2str(low_amp2),' mA'];['B: ',num2str(high_amp2),' mA'];['C: ',num2str(low_amp2),' mA'];['D: ',num2str(high_amp2),' mA'];['E: ',num2str(clin_amp2),' mA']},'Location','eastoutside','Orientation','horizontal','NumColumns',5,'FontSize',11);
set(leg1,'Position',leg_position);
temp= ax1(1).Title.String;
ax1(1).Title.String = [temp,': ',stimc2,', ',pw2,', ',freq2];
sgtitle([subject_id,': ',date],'FontSize',18);
low1 = [mean_psdMat1_low1,mean_psdMat2_low1,mean_psdMat3_low1,mean_psdMat4_low1];
low2 = [mean_psdMat1_low2,mean_psdMat2_low2,mean_psdMat3_low2,mean_psdMat4_low2];
high1 = [mean_psdMat1_high1,mean_psdMat2_high1,mean_psdMat3_high1,mean_psdMat4_high1];
high2 = [mean_psdMat1_high2,mean_psdMat2_high2,mean_psdMat3_high2,mean_psdMat4_high2];
clin1 = [mean_psdMat1_clin1,mean_psdMat2_clin1,mean_psdMat3_clin1,mean_psdMat4_clin1];
save([analysis_save_dir,subject_id,'_',date,'_PSD-data_Right_',tag,'.mat'],'f1','low1','low2','high1','high2','clin1')
saveas(gcf,[analysis_save_dir,subject_id,'_',date,'_amplitude-analysis_ON-OFF-Right_',tag,'.png'])
saveas(gcf,[analysis_save_dir,subject_id,'_',date,'_amplitude-analysis_ON-OFF-Right_',tag,'.svg'])
saveas(gcf,[analysis_save_dir_all,subject_id,'_',date,'_amplitude-analysis_Right_',num2str(exp),'_',tag,'.png'])