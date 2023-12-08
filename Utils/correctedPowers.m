function [pwrs,times,tf,s_data] = correctedPowers(sig,t0,frqs,correct)
F = sig'; %sprint input

%% Spectrogram
w = 4;
[~,~,~,tf]=spectrogram(sig,250*w,125*w,500,500);

%% SPRiNT

    clearvars s_data
    SPRiNT_AmpTesting;

%% Corrected Powers
for i = 1:length(s_data.SPRiNT.channel.data)
    times(i) = s_data.SPRiNT.channel.data(i).time+t0;

    if correct
        powers(i,:) = 10*log10(s_data.SPRiNT.channel.data(i).power_spectrum)-10*log10(s_data.SPRiNT.channel.data(i).ap_fit);
    else
        powers(i,:) = 10*log10(s_data.SPRiNT.channel.data(i).power_spectrum);
    end

end

frq = find(s_data.Freqs>=frqs(1) & s_data.Freqs<=frqs(2));

pwrs = mean(powers(:,frq),2);


end