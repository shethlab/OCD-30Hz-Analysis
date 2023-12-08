function histoBox(fn,tlab)
for t = 2
    tstr = {'Left mOFC', 'Left lOFC','Right mOFC','Right lOFC'};
    figure('Renderer', 'painters', 'Position', [10 10 600 1200],'Color','w');
f = tiledlayout(4,2);
a= [];

for i = 1:4 %Only Left l OFC
    load(fn{i});
    hamp = pows(t).high_amp;
    val = pows(t).value;
    hvals = val(hamp==1);
    lvals = val(hamp==0);
    nexttile;
    histogram(lvals,'BinWidth',0.5);
    hold on
    histogram(hvals,'BinWidth',0.5)
    if t == 4
        legend({'Low Amp','High Amp'},'Location','northeastoutside');
    end
    title(tlab{i})
    ax = gca;
    a(i) = ax;
    nexttile;
    boxplot([hvals;lvals],[repmat({'High'},length(hvals),1);repmat({'Low'},length(lvals),1)]);
    smat = computeStats(pows);
    title(strcat('P Value: ',string(smat(t))));
    title(f,tstr{t})
    ax.FontSize = 14;

end
linkaxes(a,'x')
end






end