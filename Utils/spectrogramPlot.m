function ax1 = spectrogramPlot(td,ch_input1,si1,ei1,hold_on,hem,channels,upper_freq_lim)

%%
ch = nan_demean(td{si1:ei1,:});
ts = (1/500):(1/500):(length(ch(:,1))/500);

%%
ch_1 = ch(:,ch_input1);
if hold_on==0
    figure('Renderer', 'painters', 'Position', [10 10 2000 800],'Color','w');
end

ax1 = subplot(10,1,[4 5 6]);
[~,f,t,tf]=spectrogram(ch_1,250,125,250,500);
scaling = [-108 -40];
imagesc('XData',t,'YData',f,'CData',cnelab_TF_Smooth(10*log10(abs(tf)),'gaussian',[1,10]),scaling);
colormap(jet);
title([hem,channels{ch_input1}])
ylabel('Frequency (Hz)')
xlabel('seconds')
colormap jet
colorbar 
ax1.YLim = [1,upper_freq_lim];
ax1.XLim = [0,t(end)];
drawnow;
ax1.FontSize = 14;
f_plot = and(f<33,f>29);

x = input('happy with scaling?');
while x==0
    scaling = input('new colorbar? [x y]');
    clim(scaling);
    drawnow;
    x = input('happy with scaling?');
end

end


