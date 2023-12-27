function ch = demean_removeNaNs(td1,cell_bool,fill_gaps)
try
ch1L = td1.TD_key0;
catch
    ch1L = td1.key0;
end
ch1L = ch1L -nanmean(ch1L);
try           
ch2L = td1.TD_key1;
catch
    ch2L = td1.key1;
end
ch2L = ch2L -nanmean(ch2L);
try       
ch3L = td1.TD_key2;
catch
    ch3L = td1.key2;
end
ch3L = ch3L -nanmean(ch3L);
try     
ch4L = td1.TD_key3;
catch
    ch4L = td1.key3;
end
ch4L = ch4L -nanmean(ch4L);

if fill_gaps == 1
    ch1L_filled = fillgaps(ch1L);
    disp('channel 1 gaps filled')
    ch2L_filled = fillgaps(ch2L);
    disp('channel 2 gaps filled')
    ch3L_filled = fillgaps(ch3L);
    disp('channel 3 gaps filled')
    ch4L_filled = fillgaps(ch4L);
    disp('channel 4 gaps filled')
    % Find sequences of NaNs longer than 10:
%     [B, N]  = RunLength(isnan(ch1L));
%     B(B & N < 250) = false;      % Exclude short sequences
%     Mask    = RunLength(B, N);  % Inflate again
%     ch1L_filled(Mask) = nan;    % Copy original NaNs to output
%     ch2L_filled(Mask) = nan;    % Copy original NaNs to output
%     ch3L_filled(Mask) = nan;    % Copy original NaNs to output
%     ch4L_filled(Mask) = nan;    % Copy original NaNs to output
    ch1L = ch1L_filled;
    ch2L = ch2L_filled;
    ch3L = ch3L_filled;
    ch4L = ch4L_filled;
else

    % replace nans with zeros
    nan_inds = find(isnan(ch1L));
    ch1L(nan_inds)=0;
    ch2L(nan_inds)=0;
    ch3L(nan_inds)=0;
    ch4L(nan_inds)=0;
end

% 
if cell_bool ==1
    ch = {ch1L,ch2L,ch3L,ch4L}';
else
    ch = [ch1L,ch2L,ch3L,ch4L];
end

function [b, n] = RunLength(x, n)
% Cheap and slower version of:
%   https://www.mathworks.com/matlabcentral/fileexchange/41813-runlength
if nargin == 1                    % Encode: x -> b, n
    d = [true; diff(x(:)) ~= 0];  % TRUE if values change
    b = x(d);                     % Elements without repetitions
    n = diff(find([d.', true]));  % Number of repetitions
else                              % Decode: b, n -> x
    len   = length(n);            % Number of bins
    d     = cumsum(n);            % Cummulated run lengths
    index = zeros(1, d(len));     % Pre-allocate
    index(d(1:len-1)+1) = 1;      % Get the indices where the value changes
    index(1)            = 1;      % First element is treated as "changed" also
    b     = x(cumsum(index));     % Cummulated indices
end
end
end