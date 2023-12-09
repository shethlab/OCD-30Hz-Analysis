subplot(4,2,2*(i-1)+1)
yyaxis left
plot(lags,[lag0.R_P_RAW(i,1);lag2.R_P_RAW(i,1);lag4.R_P_RAW(i,1);lag6.R_P_RAW(i,1)])
ylabel('R')
ax = gca;
ax.YLim = [0,0.5];
yyaxis right
plot(lags,[lag0.R_P_RAW(i,2);lag2.R_P_RAW(i,2);lag4.R_P_RAW(i,2);lag6.R_P_RAW(i,2)])
ylabel('p')
ax = gca;
ax.YLim = [0,0.25];
title('Raw')
xlabel('lag (s)')

subplot(4,2,2*(i-1)+2)
yyaxis left
plot(lags,[lag0.R_P_EMA(i,1);lag2.R_P_EMA(i,1);lag4.R_P_EMA(i,1);lag6.R_P_EMA(i,1)])
ylabel('R')
ax = gca;
ax.YLim = [0,0.5];
yyaxis right
plot(lags,[lag0.R_P_EMA(i,2);lag2.R_P_EMA(i,2);lag4.R_P_EMA(i,2);lag6.R_P_EMA(i,2)])
ylabel('p')
xlabel('lag (s)')
ax = gca;
ax.YLim = [0,10e-8];
title('EMA')