%% eyelidSumsLatencyCR %%
% Calculate latency to different aspects of learned CR

% Written by Kayla Fernando (10/27/22)

% NOTE: define the trial type to analyze and run sections separately

clear all
close all
clc

mouse = 'KF51'; 
basepath = 'Y:\\home\kayla\Eyelid conditioning\';

% Preprocess eyelid conditioning data, output promptData.txt
eyelidPreprocess

% Define trial type to analyze
if numel(unique(rig)) == 1
    trialType = cspaired_all;
elseif numel(unique(rig)) > 1
    trialType = cspaired_all_cell;
end

% Define windows
if numel(unique(rig)) == 1
    if strcmp(rig,'black') == 1
        win = [139 140 141 142]; % determined through imageSubtraction.m
    elseif strcmp(rig,'blue') == 1 
        win = [47 48 49 50]; % determined through imageSubtraction.m
    end
elseif numel(unique(rig)) > 1
    keep_trials = cell(1,length(files));
    for k = 1:length(files)
        if strcmp(rig{k},'black') == 1
            win{k} = [139 140 141 142];
         elseif strcmp(rig{k},'blue') == 1
            win{k} = [47 48 49 50];
        end
    end
end

% Use only successful CS-US trials
[keep_cramp,keep_trials] = sortTrials(rig,win,trialType,files);
if iscell(keep_cramp) == 1
    keep_cramp = cell2mat(keep_cramp');
end

%% Latency to CR onset (defined as 5 percent rise time)

if numel(unique(rig)) == 1
    abs_five_percent = keep_cramp*0.05; % an absolute value
    if strcmp(rig,'black') == 1
        baseline_five_percent = round(mean(keep_trials(:,1:66),2)+abs_five_percent,2); % add this absolute value to the baseline value in each trial
        for k = 1:size(keep_trials,1)
            keep_trials_temp = keep_trials(k,68:151); % window between CS onset and US onset
            idx{k} = find(round(keep_trials_temp,2) == baseline_five_percent(k),1,'last'); % find the last index where the eyelid position equals baseline_five_percent (closest to the US onset)
            if isempty(idx{k}) % if you can't get an exact match
                increment = 0.01;
                while isempty(idx{k}) 
                    idx{k} = find(round(keep_trials_temp,2) == baseline_five_percent(k)+increment,1,'last'); % increase baseline_five_percent by a small increment and try again
                    increment = increment + 0.01;
                    if increment > 1
                        break
                    end
                end
            end
            latencies{k} = idx{k}*3; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR begins. 3 ms/frame
        end
    elseif strcmp(rig,'blue') == 1 
        baseline_five_percent = round(mean(keep_trials(:,1:10),2)+abs_five_percent,2); % add this absolute value to the baseline value in each trial
        for k = 1:size(keep_trials,1)
            keep_trials_temp = keep_trials(k,24:51); % window between CS onset and US onset
            idx{k} = find(round(keep_trials_temp,2) == baseline_five_percent(k),1,'last'); % find the last index where the eyelid position equals baseline_five_percent (closest to the US onset)
            if isempty(idx{k}) % if you can't get an exact match
                increment = 0.01;
                while isempty(idx{k}) 
                    idx{k} = find(round(keep_trials_temp,2) == baseline_five_percent(k)+increment,1,'last'); % increase baseline_five_percent by a small increment and try again
                    increment = increment + 0.01;
                    if increment > 1
                        break
                    end
                end
            end
            latencies{k} = idx{k}*8; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR begins. 8 ms/frame
        end
    end
    latencies = vertcat(latencies{:}); % latencies b/w CS onset and CR onset in ms
elseif numel(unique(rig)) > 1
    abs_five_percent = cellfun(@absFivePercent,keep_cramp,'UniformOutput',false); % an absolute value
    for k = 1:length(files)
        keep_trials_temp = keep_trials{k};
        if strcmp(rig{k},'black') == 1
            a = mat2cell(mean(keep_trials_temp(:,1:66),2),size(keep_trials{k},1));
            b = mat2cell(abs_five_percent{k},length(abs_five_percent{k}));
            baseline_five_percent{k} = round(a{:}+b{:},2); % add this absolute value to the baseline value in each trial
         elseif strcmp(rig{k},'blue') == 1
            a = mat2cell(mean(keep_trials_temp(:,1:10),2),size(keep_trials{k},1));
            b = mat2cell(abs_five_percent{k},length(abs_five_percent{k}));
            baseline_five_percent{k} = round(a{:}+b{:},2); % add this absolute value to the baseline value in each trial
        end
    end
    idx = cell(1,length(files));
    latencies = cell(1,length(files));
    for k = 1:length(files)
        baseline_five_percent_temp = baseline_five_percent{k};
        idx{k} = cell(1,length(baseline_five_percent_temp));
        latencies{k} = cell(1,length(baseline_five_percent_temp));
    end
    for k = 1:length(files)
        if strcmp(rig{k},'black') == 1
            baseline_five_percent_temp = baseline_five_percent{k};
            keep_trials_temp = keep_trials{k};
            keep_trials_window = keep_trials_temp(:,68:143);
            for ii = 1:length(baseline_five_percent_temp)
                idx{k}{ii} = find(round(keep_trials_window(ii,:),2) == baseline_five_percent_temp(ii),1,'last');  
                if isempty(idx{k}{ii})
                    increment = 0.01;
                    while isempty(idx{k}{ii})
                        idx{k}{ii} = find(round(keep_trials_window(ii,:),2) == baseline_five_percent_temp(ii)+increment,1,'last');
                        increment = increment + 0.01;
                        if increment > 1
                            break
                        end
                    end
                end
                latencies{k}{ii} = idx{k}{ii}*3; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR begins. 3 ms/frame
            end
        elseif strcmp(rig{k},'blue') == 1
            baseline_five_percent_temp = baseline_five_percent{k};
            keep_trials_temp = keep_trials{k};
            keep_trials_window = keep_trials_temp(:,24:51);
            for ii = 1:length(baseline_five_percent_temp)
                idx{k}{ii} = find(round(keep_trials_window(ii,:),2) == baseline_five_percent_temp(ii),1,'last'); 
                if isempty(idx{k}{ii})
                    increment = 0.01;
                    while isempty(idx{k}{ii})
                        idx{k}{ii} = find(round(keep_trials_window(ii,:),2) == baseline_five_percent_temp(ii)+increment,1,'last');
                        increment = increment + 0.01;
                        if increment > 1
                            break
                        end
                    end
                end
                latencies{k}{ii} = idx{k}{ii}*8; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR begins. 8 ms/frame
            end
        end  
    end
    for k = 1:length(files)
        t{k} = cell2mat(latencies{k});
    end
    latencies = horzcat(t{1:length(files)})';
end

sort_latencies = sort(latencies);

%% Latency to CR peak

if numel(unique(rig)) == 1
    if strcmp(rig,'black') == 1
        for k = 1:size(keep_trials,1)
            keep_trials_temp = keep_trials(k,68:151); % entire CS window
            idx{k} = find(keep_trials_temp == max(keep_trials_temp),1,'first'); % find the first index where the eyelid position equals the maximum CR amplitude
            latencies{k} = idx{k}*3; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR reaches max amp. 3 ms/frame
        end
    elseif strcmp(rig,'blue') == 1 
        for k = 1:size(keep_trials,1)
            keep_trials_temp = keep_trials(k,24:53); % entire CS window
            idx{k} = find(keep_trials_temp == max(keep_trials_temp),1,'first'); % find the first index where the eyelid position equals the maximum CR amplitude
            latencies{k} = idx{k}*8; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR reaches max amp. 8 ms/frame
        end
    end
    latencies = vertcat(latencies{:}); % latencies b/w CS onset and CR peak in ms
elseif numel(unique(rig)) > 1
    idx = cell(1,length(files));
    latencies = cell(1,length(files));
    for k = 1:length(files)
        keep_cramp_temp = keep_cramp{k};
        idx{k} = cell(1,length(keep_cramp));
        latencies{k} = cell(1,length(keep_cramp));
    end
    for k = 1:length(files)
        if strcmp(rig{k},'black') == 1
            keep_cramp_temp = keep_cramp{k};
            keep_trials_temp = keep_trials{k};
            keep_trials_window = keep_trials_temp(:,68:151);
            for ii = 1:length(keep_cramp_temp)
                idx{k}{ii} = find(keep_trials_window(ii,:) == max(keep_trials_temp(ii)),1,'first');  
                latencies{k}{ii} = idx{k}{ii}*3; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR reaches max amp. 3 ms/frame
            end
        elseif strcmp(rig{k},'blue') == 1
            keep_cramp_temp = keep_cramp{k};
            keep_trials_temp = keep_trials{k};
            keep_trials_window = keep_trials_temp(:,24:53);
            for ii = 1:length(keep_cramp_temp)
                idx{k}{ii} = find(keep_trials_window(ii,:) == max(keep_trials_temp(ii)),1,'first'); 
                latencies{k}{ii} = idx{k}{ii}*8; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR reaches max amp. 8 ms/frame
            end
        end  
    end
    for k = 1:length(files)
        t{k} = cell2mat(latencies{k});
    end
    latencies = horzcat(t{1:length(files)})';
end

sort_latencies = sort(latencies);

%% Plotting latencies over time

meanFilterFunction = @(block_struct) mean(block_struct.data);
m = blockproc(latencies,[100 1],meanFilterFunction);
subplot(2,1,1); plot(m); ylim([0 15]);
subplot(2,1,2); scatter(1:length(m),m,'Marker','.'); ylim([0 15]);

%% CDF histograms 

% Load workspace
load('ASTN2 latencies all trials.mat');

filename = {KO_onset_paired, WT_onset_paired};
forHist = [];
        
% KO 
KO_onset_paired_cell = convert2cell(filename{1});
[h1,forHist_KO_onset_paired] = cdfEventHistCells(KO_onset_paired_cell,forHist,'latency','ms');
set(h1, 'EdgeColor', 'r');
forHist_KO_onset_paired_WX = reshape(forHist_KO_onset_paired,[],1);

hold on;

% WT 
WT_onset_paired_cell = convert2cell(filename{2});
[h2,forHist_WT_onset_paired] = cdfEventHistCells(WT_onset_paired_cell,forHist,'latency','ms');
set(h2, 'EdgeColor', 'k');
forHist_WT_onset_paired_WX = reshape(forHist_WT_onset_paired,[],1);

xlim([0 220]);
ylim([0 1]);
hold off

% % Two-sample Komolgorov-Smirnov test 
% % In command window:
% [x,p,ks2stat] = kstest2(forAmpHist_KO_M_KS,forAmpHist_WT_M_KS)

% % Wilcoxon rank-sum test
% % In command window:
% [p,h,stats] = ranksum(forAmpHist_KO_M_WX,forAmpHist_WT_M_WX)
