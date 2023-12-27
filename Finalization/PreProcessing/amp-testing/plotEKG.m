function [ts_ekg,denoised_EKG,ts_pulse,denoised_pulse] = plotEKG(ekg,pulse)

ekg_lowpassed = lowpass(ekg,3,5000); %max allowed HR is 180
pulse_lowpassed = lowpass(pulse,3,5000);

[up,lo] = envelope(ekg_lowpassed,100,'peak');
ts_ekg = find(islocalmin(up,'MinSeparation',2000));
if isempty(ts_ekg)
    denoised_EKG = [];
else
    x = linspace(1,length(ts_ekg),length(ts_ekg));
    bpm = 60*5000*diff(x)./diff(ts_ekg);
    mean_hr = mean(bpm);
    denoised_EKG = smoothdata(bpm,'gaussian', 2*round(mean_hr));
    ts_ekg = ts_ekg(2:end)/5000;
end

[up,lo] = envelope(pulse_lowpassed,100,'peak');
ts_pulse = find(islocalmin(up,'MinSeparation',2000));
if isempty(ts_pulse)
    denoised_pulse = [];
else  
    x = linspace(1,length(ts_pulse),length(ts_pulse));
    bpm = 60*5000*diff(x)./diff(ts_pulse);
    mean_hr = mean(bpm);
    denoised_pulse = smoothdata(bpm,'gaussian', 2*round(mean_hr));
    ts_pulse = ts_pulse(2:end)/5000;
end

end