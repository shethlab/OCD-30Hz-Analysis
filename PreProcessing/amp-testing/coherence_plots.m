function fn = coherence_plots(ch,channels,combo,start_stop_inds_low,start_stop_inds_high,start_stop_inds_clin)

%% calculate coherence
% L1, H1, L2, H2, C1
if combo(1)<=4
    hem1 = 'Left';
    h1i = 1;
else
    hem1 = 'Right';
    h1i = 2;
end
if combo(2)<=4
    hem2 = 'Left';
    h2i = 1;
else
    hem2 = 'Right';
    h2i = 2;
end

dat1 = ch{combo(1)};
dat2 = ch{combo(2)};

figure('Renderer', 'painters', 'Position', [10 10 900 800]);
ax1 = subplot(5,1,1);
[cxy,fc] = mscohere(dat1(start_stop_inds_low{1,h1i}(1):start_stop_inds_low{1,h1i}(2)),...
                    dat2(start_stop_inds_low{1,h2i}(1):start_stop_inds_low{1,h2i}(2)),hamming(500),250,[],500);
inds_to_plot = find(fc<50);

plot(fc(inds_to_plot),cxy(inds_to_plot))
ylabel('Coherence')
xlabel('Frequency (Hz)')
title('Low1');

ax2 = subplot(5,1,2);
[cxy,fc] = mscohere(dat1(start_stop_inds_high{1,h1i}(1):start_stop_inds_high{1,h1i}(2)),...
                    dat2(start_stop_inds_high{1,h2i}(1):start_stop_inds_high{1,h2i}(2)),hamming(500),250,[],500);
plot(fc(inds_to_plot),cxy(inds_to_plot))
ylabel('Coherence')
xlabel('Frequency (Hz)')
title('High1');

ax3 = subplot(5,1,3);
[cxy,fc] = mscohere(dat1(start_stop_inds_low{2,h1i}(1):start_stop_inds_low{2,h1i}(2)),...
                    dat2(start_stop_inds_low{2,h2i}(1):start_stop_inds_low{2,h2i}(2)),hamming(500),250,[],500);
plot(fc(inds_to_plot),cxy(inds_to_plot))
ylabel('Coherence')
xlabel('Frequency (Hz)')
title('Low2');

ax4 = subplot(5,1,4);
[cxy,fc] = mscohere(dat1(start_stop_inds_high{2,h1i}(1):start_stop_inds_high{2,h1i}(2)),...
                    dat2(start_stop_inds_high{2,h2i}(1):start_stop_inds_high{2,h2i}(2)),hamming(500),250,[],500);
plot(fc(inds_to_plot),cxy(inds_to_plot))
ylabel('Coherence')
xlabel('Frequency (Hz)')
title('High2');

ax5 = subplot(5,1,5);
[cxy,fc] = mscohere(dat1(start_stop_inds_clin{1,h1i}(1):start_stop_inds_clin{1,h1i}(2)),...
                    dat2(start_stop_inds_clin{1,h2i}(1):start_stop_inds_clin{1,h2i}(2)),hamming(500),250,[],500);
plot(fc(inds_to_plot),cxy(inds_to_plot))
ylabel('Coherence')
xlabel('Frequency (Hz)')
title('Clin1');
sgtitle({[hem1,' ',channels{combo(1)}];[hem2,' ',channels{combo(2)}]})

linkaxes([ax1,ax2,ax3,ax4,ax5],'xy')
ax1.XLim = [0,50];
fn = [hem1,' ',channels{combo(1)},'-',hem2,' ',channels{combo(2)}];
end