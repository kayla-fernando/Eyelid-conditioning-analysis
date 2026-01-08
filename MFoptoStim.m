clear all
close all
clc

experiment = 'experiment';
basepath = ['Z:\\home\kayla\Electrophysiology analysis\' experiment '\'];
folder = 'folder';
run = 'run';
mousepath = [folder '\' run '.abf'];
[d,si,h] = abfload([basepath mousepath]); % Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information
clc

% Summary sweep, note specific power
sweep = d(:,20);

baseline_search = [0.001 0.200]; % search window in s
event_search = [0.647 0.955]; %[0.647 0.895]; % 248 ms CS duration; fixed stim onset and offset
Fs = 50000; % sampling rate in Hz

% Determine if real event
baseline = std(sweep((Fs*baseline_search(1)):(Fs*baseline_search(2))))
event = mean(sweep((Fs*event_search(1)):(Fs*event_search(2))))
event >= 3*baseline

% Plot and find the area under the curve of the stimulus window
y = sweep((Fs*event_search(1)):(Fs*event_search(2)));
y = [y; y(1)];
x = [linspace(1,size(y,1),size(y,1))];
figure; plot(y); fill(x,y,'c')

mV_sample = sum(y) % mV*samples
mV_sample_base = sum(y)-sum(sweep((Fs*baseline_search(1)):(Fs*baseline_search(2)))) % subtract area of baseline; mV*samples

mV_ms = mV_sample * (1/Fs) * 1000 % mV*ms
mV_ms_base = mV_sample_base * (1/Fs) * 1000 % subtract area of baseline; mV*ms

% Measure mplitude of each peak, then tak these values and fit a linear regression, use slope to determine extent of ramping activity
% if ans == 1
%     peak_1 = max(sweep((Fs*0.668:(Fs*0.678))));
%     peak_2 = max(sweep((Fs*0.699:(Fs*0.709))));
%     peak_3 = max(sweep((Fs*0.731:(Fs*0.741))));
%     peak_4 = max(sweep((Fs*0.762:(Fs*0.772))));
%     peak_5 = max(sweep((Fs*0.793:(Fs*0.803))));
%     peak_6 = max(sweep((Fs*0.824:(Fs*0.834))));
%     peak_7 = max(sweep((Fs*0.855:(Fs*0.865))));
%     peak_8 = max(sweep((Fs*0.885:(Fs*0.895))));
%     peaks = [peak_1 peak_2 peak_3 peak_4 peak_5 peak_6 peak_7 peak_8]
%     plot(peaks)
%     lm = fitlm(1:length(peaks),peaks)

% end
