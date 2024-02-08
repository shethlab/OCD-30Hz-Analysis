function [wps,tms] = dbsSpeechAnalysis(tg,amp_data)
%% Load TextGrid

text = tgRead(tg);
wav = amp_data.audio;
b=text.tier{1};

%% Try Speech Analysis and Catch
try
    keep=~cellfun(@isempty,b.Label);
    rm=~cellfun(@isempty,strfind(b.Label,'*'));
    tOn=b.T1(keep&~rm);
    tOff=b.T2(keep&~rm);
    t=(tOn+tOff)/2;
    w=2;
    edges=0:w:max(tOn)+w;
    [n,edges]=histcounts(tOn,edges);
    n=n/w;
    wAmp=zeros(1,length(t));
    tW=(1:length(wav))/amp_data.fs_audio;
    for i=1:length(t)
        wAmp(i)=rms(wav(tW>tOn(i)&tW<tOff(i)));
    end

catch
    t = [];
    n = [];
    edges = [];
    wAmp =[];
    tW=(1:length(wav))/amp_data.fs_audio;
    w = [];
end 
%%
tms = edges((1:end-1))+w/2;
wps = n;
end