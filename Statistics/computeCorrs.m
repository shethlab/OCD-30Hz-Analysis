function [r,p] = computeCorrs(pows,raws)

%% Empty Correlation Vectors
r = zeros(4,1);
p = zeros(4,1);

%% Speech Data + ema init
datspeech = pows(5);
try
    if raws(2)
        emaspeech = datspeech.value';
    else
        emaspeech = movavg(datspeech.value',"exponential",5);
    end
catch
    if raws(2)
        emaspeech = datspeech.value;
    else
        emaspeech = movavg(datspeech.value,"exponential",5);
    end
end

%% Loop Contacts
for i = 1:4
    datneural = pows(i);
    [~,shareda,sharedb] = intersect(datneural.times,datspeech.times);
    if raws(1)
        emaneural = datneural.value;
    else
        emaneural = movavg(datneural.value,"exponential",10);
    end

    %% Sampling
    emaneuralds = emaneural(shareda);
    emaspeechds = emaspeech(sharedb);

    %% Corrs
    [R,P] = corrcoef(emaneuralds,emaspeechds);
    r(i) = R(1,2);
    p(i) = P(1,2);

end

end