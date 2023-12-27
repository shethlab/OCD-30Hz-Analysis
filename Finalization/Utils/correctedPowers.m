%% Compute Corrected Powers (1/f subtraction)
% Inputs:
% sig: time domain signal (demeaned, nans replaced with 0)
% t0: start time (usually 0)
% frqs: frequency range to compute result
% correct: return 1/f corrected powers; when set to 0, report raw power
% calcmax: return max power in range; when set to 0, report mean power


function [pwrs,times,tf,s_data] = correctedPowers(sig,t0,frqs,correct,calcmax)


F = sig'; %SPRiNT input dimension change

%% Spectrogram
w = 4;
[~,~,~,tf]=spectrogram(sig,250*w,125*w,500,500);
%report the time frequency result from spectrogram if desired, with adjustable window parameter internally

%% SPRiNT
clearvars s_data % s_data may be a latent variable in workspace, clear it
SPRiNT_AmpTesting;

%% Corrected Powers
for i = 1:length(s_data.SPRiNT.channel.data)
    times(i) = s_data.SPRiNT.channel.data(i).time+t0; % Time vector
    if correct
        powers(i,:) = 10*log10(s_data.SPRiNT.channel.data(i).power_spectrum)-10*log10(s_data.SPRiNT.channel.data(i).ap_fit);
    else
        powers(i,:) = 10*log10(s_data.SPRiNT.channel.data(i).power_spectrum);
    end

end

%% Report Mean or Max in range
frq = find(s_data.Freqs>=frqs(1) & s_data.Freqs<=frqs(2));
if calcmax
    pwrs = max(powers(:,frq),[],2);
else
    pwrs = mean(powers(:,frq),2);
end


end