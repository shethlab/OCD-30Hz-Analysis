function plotPSDs(fn,hem)
c = [31 195 255;...
    251 86 59;...
    0 108 255;...
    237 28 36;...
    %0 38 255;...
    57 181 74]/255;
upper_freq_lim = 55;
load(fn);
figure('Renderer', 'painters', 'Position', [10 10 1200 800],'Color','w');

ax(1) = subplot(3,3,1);
hold on
axis square
box off

ax(2) = subplot(3,3,2);
hold on
axis square

box off

ax(3) = subplot(3,3,3);
hold on
axis square

box off


for i = 1:5
    switch i 
        case 1
            dat = low1;
        case 2
            dat = high1;
        case 3
            dat = low2;
        case 4
            dat = high2;
        case 5
            dat = clin1;
    end
    for j = 1:3
        hold on;
        plot(ax(j),f1,dat(:,j),'Color',c(i,:),'LineWidth',1)
        hold on;
        if i == 5
            switch j
                case 1
                    title(ax(j),[hem,' VC/VS']);
                case 2
                    title(ax(j),[hem,' mOFC']);

                case 3
                    title(ax(j),[hem,' lOFC']);
            end
            ylabel(ax(j),'Power (dB)');
            xlabel(ax(j),'Frequency (Hz)');
        end
        box off

    end
end


ax(1).XLim = [0,upper_freq_lim];
ax(2).XLim = [0,upper_freq_lim];
ax(3).XLim = [0,upper_freq_lim];
xticks(ax(1),[0 10 20 30 40 50]);
xticks(ax(2),[0 10 20 30 40 50]);
xticks(ax(3),[0 10 20 30 40 50]);
ax(1).FontSize = 14;
ax(2).FontSize = 14;
ax(3).FontSize = 14;
legend(ax(1),{'Low 1','High 1','Low 2', 'High 2','Clinical'})

linkaxes(ax,'y')

end