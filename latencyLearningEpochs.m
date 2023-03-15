%%latencyLearningEpochs%%
% Calculate latency to different aspects of learned CR at different
% learning epochs

% Written by Kayla Fernando (3/15/23)

close all
clear all
clc

% Load workspace (average eyelid trace for naive, chance, or learned
% condition for each animal in a given experimental condition. 1 row = 1
% animal
load('ASTN2 learning epochs.mat');
WT_learned_catch(WT_learned_catch == 0) = NaN;

for k = 1:size(WT_learned_catch,1)
     if any(isnan(WT_learned_catch(k,:))) == 1
         rig{k} = 'blue';
         win{k} = [47 48 49 50];
     else
         rig{k} = 'black';
         win{k} = [139 140 141 142];
     end
end

for k = 1:size(WT_learned_catch,1)
     if strcmp(rig{k},'black') == 1
        cramp(k) = mean(WT_learned_catch(k,win{k}),2) - mean(WT_learned_catch(k,1:66),2);
     elseif strcmp(rig{k},'blue') == 1
        cramp(k) = mean(WT_learned_catch(k,win{k}),2) - mean(WT_learned_catch(k,1:10),2);
     end
end

%% Latency to CR onset (defined as 10 percent of CRamp) (using CS-US trials)

abs_ten_percent = absTenPercent(cramp);

for k = 1:size(WT_learned_catch,1)
    if strcmp(rig{k},'black') == 1
        baseline_ten_percent = round(mean(WT_learned_catch(k,1:66),2)+abs_ten_percent,2);
        trials_temp = flip(WT_learned_catch(k,68:143)); % window between CS onset and US onset, flip the signal
            idx{k} = find(round(trials_temp,2) == baseline_ten_percent(k),1); % find the first index where the eyelid position equals baseline_ten_percent (flipping ignores noisy baseline)
            if isempty(idx{k}) % if you can't get an exact match
                increment = 0.01;
                while isempty(idx{k}) 
                    idx{k} = find(round(trials_temp,2) == baseline_ten_percent(k)+increment,1); % increase baseline_ten_percent by a small increment and try again
                    increment = increment + 0.01;
                    if increment > 1
                        break
                    end
                end
            end
            latencies{k} = (size(trials_temp,2)-idx{k})*3; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR begins. 3 ms/frame
    elseif strcmp(rig{k},'blue') == 1
        baseline_ten_percent = round(mean(WT_learned_catch(k,1:10),2)+abs_ten_percent,2);
        trials_temp = flip(WT_learned_catch(k,24:51)); % window between CS onset and US onset, flip the signal
            idx{k} = find(round(trials_temp,2) == baseline_ten_percent(k),1); % find the first index where the eyelid position equals baseline_ten_percent (flipping ignores noisy baseline)
            if isempty(idx{k}) % if you can't get an exact match
                increment = 0.01;
                while isempty(idx{k}) 
                    idx{k} = find(round(trials_temp,2) == baseline_ten_percent(k)+increment,1); % increase baseline_ten_percent by a small increment and try again
                    increment = increment + 0.01;
                    if increment > 1
                        break
                    end
                end
            end
            latencies{k} = (size(trials_temp,2)-idx{k})*8; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR begins. 8 ms/frame
    end
end

latencies = vertcat(latencies{:}); % latencies b/w CS onset and CR onset in ms
latencies = latencies(latencies >= 100); % real CRs have at least 100 ms latency from looking at eyelid traces, get rid of false positives

 %% Latency to CR peak (using CS-catch trials)

for k = 1:size(WT_learned_catch,1)
    if strcmp(rig{k},'black') == 1
        trials_temp = WT_learned_catch(k,68:end);
        idx{k} = find(trials_temp == max(trials_temp),1,'first'); % find the first index where the eyelid position equals the maximum CR amplitude
        latencies{k} = idx{k}*3; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR reaches max amp. 3 ms/frame
    elseif strcmp(rig{k},'blue') == 1     
        trials_temp = WT_learned_catch(k,24:end);
        idx{k} = find(trials_temp == max(trials_temp),1,'first'); % find the first index where the eyelid position equals the maximum CR amplitude
        latencies{k} = idx{k}*8; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR reaches max amp. 8 ms/frame
    end
end
 
latencies = vertcat(latencies{:}); % latencies b/w CS onset and CR peak in ms
latencies = latencies(latencies >= 100 & latencies <= 350); % exclude detection of double blinks/grooming
