function [TF,ts,f] = windowedWelch(data,L,O,w,overlap,fs)
tvec = (1:length(data))/fs;
L = L*fs;
w = w*fs;
overlap = overlap*fs;

segments = [1 L];
%% Big Window Length L overlapping at O%
while segments(end,2)<length(data)
    segments = [segments; segments(end,2)-round(O*L)+1 segments(end,2)-round(O*L)+L];
end
segments = segments(1:end-1,:);

%% Time Vector
ts = zeros(1,size(segments,1));
for i = 1:length(ts)
    ts(i) = (tvec(segments(i,1))+tvec(segments(i,2)))/2-1/(2*fs);
end

%% Welch
TF = [];
for i = 1:length(ts)
    [pxx,f] = pwelch(data(segments(i,1):segments(i,2)),hamming(w),overlap,[],fs);
    TF(1,i,:) = pxx;

end

f = f';

end