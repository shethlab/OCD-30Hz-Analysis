%% Panel Left Hem
psdfile = '/Users/sameerrajesh/Desktop/30Hz Project Data/2022-09-09/AnalysisFiles/rest/2022-09-09_PSD-data_Left.mat';
plotPSDs(psdfile,'Left',1);
saveas(gcf,'/Users/sameerrajesh/Desktop/30Hz Project Data/Figures/Figure 1/LeftPSDs.svg');
close all
%% Panel Right Hem
psdfile = '/Users/sameerrajesh/Desktop/30Hz Project Data/2022-09-09/AnalysisFiles/rest/2022-09-09_PSD-data_Right.mat';
plotPSDs(psdfile,'Right',1);
saveas(gcf,'/Users/sameerrajesh/Desktop/30Hz Project Data/Figures/Figure 1/RightPSDs.svg');
close all