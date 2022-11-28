%% eyelidSumsLatencyCR %%
% Calculate latency to different aspects of learned CR

% Written by Kayla Fernando (11/24/22)

% NOTE: define the trial type to analyze and run sections separately

clear all
close all
clc

mouse = 'KF39'; 
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

% Use only successful trials
% If trained on multiple rigs, cell array output format will include 
% sessions that don't have trials and CRamps to keep (i.e., empty cells)
% Truncate these cell arrays in later sections
[keep_cramp,keep_trials] = sortTrials(rig,win,trialType,files);

%% Latency to CR onset (defined as 10 percent of CRamp)

% If same rig throughout training
if numel(unique(rig)) == 1
    abs_ten_percent = keep_cramp*0.10; % an absolute value
    % Black rig throughout training
    if strcmp(rig,'black') == 1
        baseline_ten_percent = round(mean(keep_trials(:,1:66),2)+abs_ten_percent,2); % add this absolute value to the baseline value in each trial
        for k = 1:size(keep_trials,1)
            keep_trials_temp = flip(keep_trials(k,68:143)); % window between CS onset and US onset, flip the signal
            idx{k} = find(round(keep_trials_temp,2) == baseline_ten_percent(k)+0.01,1); % find the first index where the eyelid position equals baseline_ten_percent (flipping ignores noisy baseline)
            if isempty(idx{k}) % if you can't get an exact match
                increment = 0.01;
                while isempty(idx{k}) 
                    idx{k} = find(round(keep_trials_temp,2) == baseline_ten_percent(k)+increment,1); % increase baseline_ten_percent by a small increment and try again
                    increment = increment + 0.01;
                    if increment > 1
                        break
                    end
                end
            end
            latencies{k} = (size(keep_trials_temp,2)-idx{k})*3; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR begins. 3 ms/frame
        end
    % Blue rig throughout training    
    elseif strcmp(rig,'blue') == 1 
        baseline_ten_percent = round(mean(keep_trials(:,1:10),2)+abs_ten_percent,2); % add this absolute value to the baseline value in each trial
        for k = 1:size(keep_trials,1)
            keep_trials_temp = flip(keep_trials(k,24:51)); % window between CS onset and US onset, flip the signal
            idx{k} = find(round(keep_trials_temp,2) == baseline_ten_percent(k),1); % find the first index where the eyelid position equals baseline_ten_percent (flipping ignores noisy baseline)
            if isempty(idx{k}) % if you can't get an exact match
                increment = 0.01;
                while isempty(idx{k}) 
                    idx{k} = find(round(keep_trials_temp,2) == baseline_ten_percent(k)+increment,1); % increase baseline_ten_percent by a small increment and try again
                    increment = increment + 0.01;
                    if increment > 1
                        break
                    end
                end
            end
            latencies{k} = (size(keep_trials_temp,2)-idx{k})*8; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR begins. 8 ms/frame
        end
    end
    latencies = vertcat(latencies{:}); % latencies b/w CS onset and CR onset in ms
    latencies = latencies(latencies >= 100); % real CRs have at least 100 ms latency from looking at eyelid traces, get rid of false positives

% If different rigs throughout training
elseif numel(unique(rig)) > 1
    abs_ten_percent = cellfun(@absTenPercent,keep_cramp,'UniformOutput',false); % an absolute value
    % If there are sessions (cells) that do not have any trials to keep
    % (i.e., are empty)
    if any(cellfun(@isempty,keep_trials)) == 1
        empty = cellfun(@isempty,keep_trials);
        ses = find(empty == 0); % find the sessions that do have trials to keep
        for k = 1:length(files) % iterate through the entire list but nothing happens with empty cells
            for ii = 1:length(ses) % by specifically using this new session index
                keep_trials_temp = keep_trials{ses(ii)};
                if strcmp(rig{ses(ii)},'black') == 1
                    a = mat2cell(mean(keep_trials_temp(:,1:66),2),size(keep_trials{ses(ii)},1));
                    b = mat2cell(abs_ten_percent{ses(ii)},length(abs_ten_percent{ses(ii)}));
                    baseline_ten_percent{ses(ii)} = round(a{:}+b{:},2); % add this absolute value to the baseline value in each trial
                elseif strcmp(rig{ses(ii)},'blue') == 1
                    a = mat2cell(mean(keep_trials_temp(:,1:66),2),size(keep_trials{ses(ii)},1));
                    b = mat2cell(abs_ten_percent{ses(ii)},length(abs_ten_percent{ses(ii)}));
                    baseline_ten_percent{ses(ii)} = round(a{:}+b{:},2); % add this absolute value to the baseline value in each trial
                end
            end
        end
    % If all sessions (cells) have trials to keep (i.e., no empty cells)    
    else
        for k = 1:length(files) 
            keep_trials_temp = keep_trials{k};
            if strcmp(rig{k},'black') == 1
                a = mat2cell(mean(keep_trials_temp(:,1:66),2),size(keep_trials{k},1));
                b = mat2cell(abs_ten_percent{k},length(abs_ten_percent{k}));
                baseline_ten_percent{k} = round(a{:}+b{:},2); % add this absolute value to the baseline value in each trial
             elseif strcmp(rig{k},'blue') == 1
                a = mat2cell(mean(keep_trials_temp(:,1:10),2),size(keep_trials{k},1));
                b = mat2cell(abs_ten_percent{k},length(abs_ten_percent{k}));
                baseline_ten_percent{k} = round(a{:}+b{:},2); % add this absolute value to the baseline value in each trial
            end
        end
    end
    
    % If there are sessions (cells) that do not have any trials to keep
    % (i.e., are empty)
    if any(cellfun(@isempty,baseline_ten_percent)) == 1
        baseline_ten_percent = baseline_ten_percent(~cellfun('isempty',baseline_ten_percent)); % truncate the list
        % Initialize idx and latencies cell arrays
        idx = cell(1,length(baseline_ten_percent));
        latencies = cell(1,length(baseline_ten_percent));
        for n = 1:length(baseline_ten_percent);
            baseline_ten_percent_temp = baseline_ten_percent{n};
            idx{n} = cell(1,length(baseline_ten_percent_temp)); % truncate the list, keep relevant indices
            latencies{n} = cell(1,length(baseline_ten_percent_temp)); %truncate the list, keep relevant indices
            rig{n} = rig{ses(n)}; %truncate the list, keep relevant indices
        end
        keep_trials = keep_trials(~cellfun('isempty',keep_trials));
        rig = rig(1:length(baseline_ten_percent));
    % If all sessions (cells) have trials to keep (i.e., no empty cells)
    else
        % Initialize idx and latencies cell arrays
        idx = cell(1,length(files));
        latencies = cell(1,length(files));
        for k = 1:length(files)
            baseline_ten_percent_temp = baseline_ten_percent{k};
            idx{k} = cell(1,length(baseline_ten_percent_temp));
            latencies{k} = cell(1,length(baseline_ten_percent_temp));
        end
    end
    
    % If we had to get rid of empty cells
    if numel(files) ~= numel(baseline_ten_percent)
        k = 1:length(baseline_ten_percent); % use this session index
    % If we didn't have to get rid of empty cells    
    else
        k = 1:length(files); % iterate through the entire list
    end
    
    % For whichever index you use
    for k = k(1):k(end)
        if strcmp(rig{k},'black') == 1
            baseline_ten_percent_temp = baseline_ten_percent{k};
            keep_trials_temp = keep_trials{k};
            keep_trials_window = flip(keep_trials_temp(:,68:143),2);
            for ii = 1:size(baseline_ten_percent_temp,1)
                idx{k}{ii} = find(round(keep_trials_window(ii,:),2) == baseline_ten_percent_temp(ii),1);  
                if isempty(idx{k}{ii})
                    increment = 0.01;
                    while isempty(idx{k}{ii})
                        idx{k}{ii} = find(round(keep_trials_window(ii,:),2) == baseline_ten_percent_temp(ii)+increment,1);
                        increment = increment + 0.01;
                        if increment > 1
                            break
                        end
                    end
                end
                latencies{k}{ii} = (size(keep_trials_window,2)-idx{k}{ii})*3; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR begins. 3 ms/frame
            end
        elseif strcmp(rig{k},'blue') == 1
            baseline_ten_percent_temp = baseline_ten_percent{k};
            keep_trials_temp = keep_trials{k};
            keep_trials_window = flip(keep_trials_temp(:,24:51),2);
            for ii = 1:size(baseline_ten_percent_temp,1)
                idx{k}{ii} = find(round(keep_trials_window(ii,:),2) == baseline_ten_percent_temp(ii),1); 
                if isempty(idx{k}{ii})
                    increment = 0.01;
                    while isempty(idx{k}{ii})
                        idx{k}{ii} = find(round(keep_trials_window(ii,:),2) == baseline_ten_percent_temp(ii)+increment,1);
                        increment = increment + 0.01;
                        if increment > 1
                            break
                        end
                    end
                end
                latencies{k}{ii} = (size(keep_trials_window,2)-idx{k}{ii})*8; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR begins. 8 ms/frame
            end
        end  
    end
    
    % If there were empty cells
    if numel(files) ~= numel(baseline_ten_percent)
        k = 1:length(baseline_ten_percent);
        for k = 1:length(k)
            t{k} = cell2mat(latencies{k});
        end
        latencies = horzcat(t{1:length(t)});
    % If no empty cells
    else
        k = 1:length(files);
        for k = 1:length(k)
            t{k} = cell2mat(latencies{k});
        end
        latencies = horzcat(t{1:length(files)})';
    end
    latencies = latencies(latencies >= 100); % real CRs are at least 100 ms long from looking at eyelid traces, get rid of false positives
end

sort_latencies = sort(latencies);

%% Latency to CR peak

% if numel(unique(rig)) == 1
%     if strcmp(rig,'black') == 1
%         for k = 1:size(keep_trials,1)
%             keep_trials_temp = keep_trials(k,68:end);
%             idx{k} = find(keep_trials_temp == max(keep_trials_temp),1,'first'); % find the first index where the eyelid position equals the maximum CR amplitude
%             latencies{k} = idx{k}*3; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR reaches max amp. 3 ms/frame
%         end
%     elseif strcmp(rig,'blue') == 1 
%         for k = 1:size(keep_trials,1)
%             keep_trials_temp = keep_trials(k,24:end);
%             idx{k} = find(keep_trials_temp == max(keep_trials_temp),1,'first'); % find the first index where the eyelid position equals the maximum CR amplitude
%             latencies{k} = idx{k}*8; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR reaches max amp. 8 ms/frame
%         end
%     end
%     latencies = vertcat(latencies{:}); % latencies b/w CS onset and CR peak in ms
% elseif numel(unique(rig)) > 1
%     idx = cell(1,length(files));
%     latencies = cell(1,length(files));
%     for k = 1:length(files)
%         keep_cramp_temp = keep_cramp{k};
%         idx{k} = cell(1,length(keep_cramp));
%         latencies{k} = cell(1,length(keep_cramp));
%     end
%     for k = 1:length(files)
%         if strcmp(rig{k},'black') == 1
%             keep_cramp_temp = keep_cramp{k};
%             keep_trials_temp = keep_trials{k};
%             keep_trials_window = keep_trials_temp(:,68:end);
%             for ii = 1:length(keep_cramp_temp)
%                 idx{k}{ii} = find(keep_trials_window(ii,:) == max(keep_trials_temp(ii)),1,'first');  
%                 latencies{k}{ii} = idx{k}{ii}*3; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR reaches max amp. 3 ms/frame
%             end
%         elseif strcmp(rig{k},'blue') == 1
%             keep_cramp_temp = keep_cramp{k};
%             keep_trials_temp = keep_trials{k};
%             keep_trials_window = keep_trials_temp(:,24:end);
%             for ii = 1:length(keep_cramp_temp)
%                 idx{k}{ii} = find(keep_trials_window(ii,:) == max(keep_trials_temp(ii)),1,'first'); 
%                 latencies{k}{ii} = idx{k}{ii}*8; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR reaches max amp. 8 ms/frame
%             end
%         end  
%     end
%     for k = 1:length(files)
%         t{k} = cell2mat(latencies{k});
%     end
%     latencies = horzcat(t{1:length(files)})';
% end
% 
% sort_latencies = sort(latencies);

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
