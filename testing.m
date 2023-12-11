version_tag = {'_v1.mat','_v2.mat','_v3.mat'};
includeclin = 0;
control = 1;
nicole = 1;
lowf = 31.5-1;
highf = 31.5+1;

if control
    if nicole == 1 
        dir = 'D:\Amplitude Data\DataFits\DataFits\02-27-2023\Expt1\';
    else
        dir = '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/02-27-2023/Expt1/';
    end
else
    if nicole == 1
        dir = 'D:\Amplitude Data\DataFits\DataFits\11-15-2022\'
    else
        dir = '/Users/sameerrajesh/Desktop/aDBS012 AMP PSD/11-15-2022/';
    end
end
datafile = [dir,'datafile_corrected'];

c = [31 195 255;...
    251 86 59;...
    0 108 255;...
    237 28 36;...
    %0 38 255;...
    57 181 74]/255;
for i = 1
    switch i
        case 1
            sprfile = [dir,'SPRiNT_LlOFC'];
        case 2
            sprfile = [dir,'SPRiNT_LmOFC'];

    end
    figure('Renderer', 'painters', 'Position', [10 10 2000 800],'Color','w');
    max_all = cell(2,1);
    for j = 1:2
        for k = 1

            load(strcat(sprfile,version_tag{k}));
            load(strcat(datafile,version_tag{k}));
            switch j
                case 1
                    if includeclin
                        inds = find(pows(1).high_amp == 0 | pows(1).high_amp == 3);
                    else
                        inds = find(pows(1).high_amp == 0);
                    end

                case 2
                    inds = find(pows(1).high_amp == 1);
            end
            allpsd = [];
            allaper = [];
            if ~control
            inds(find(pows(1).times(inds)>=238 & pows(1).times(inds)<=671)) = [];
            end
            inds = pows(1).times(inds);
            for f = 1:length(inds)
                allpsd(f,:) = 10*log10(s_data.SPRiNT.channel.data(inds(f)).power_spectrum);
                allaper(f,:) = 10*log10(s_data.SPRiNT.channel.data(inds(f)).ap_fit);
            end
            avgpsd = mean(allpsd,1);
            avgaper = mean(allaper,1);
            
            finds = find(s_data.Freqs>=lowf & s_data.Freqs<=highf);
            frange = allpsd(:,finds)-avgaper(:,finds);
            max_all{j,1} = max(frange,[],2);
        
        end
        hold on
        plot(s_data.Freqs,avgpsd,'Color',c(j,:));
        plot(s_data.Freqs,avgaper,'Color',c(j,:),'LineStyle',':');
        ax = gca;
        ax.YLim = [-70 -20];
        differ = avgpsd-avgaper;
        finds = find(s_data.Freqs>=lowf & s_data.Freqs<=highf);

        pwrs(j) = mean(differ(:,finds));
        max_pwr(j) = max(differ(:,finds));
    end
end





%% histograms

high = find(pows(1).high_amp==1);
low = find(pows(1).high_amp==0);

bw = 0.5;
figure; 
histogram(pows(1).value(high),'BinWidth',bw); 
hold on
histogram(pows(1).value(low),'BinWidth',bw); 
legend('high','low')
[h,p] = ttest2(pows(1).value(high),pows(1).value(low));
title({'average power';['p=',num2str(p)]})
mean(pows(1).value(high))
mean(pows(1).value(low))

figure;
histogram(max_all{2},'BinWidth',bw); 
hold on
histogram(max_all{1},'BinWidth',bw); 
legend('high','low')
[h,p] = ttest2(max_all{2},max_all{1});
title({'max power';['p=',num2str(p)]})


mean(max_all{2})
mean(max_all{1})
