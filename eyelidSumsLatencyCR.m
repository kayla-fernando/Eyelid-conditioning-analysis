%% eyelidSumsLatencyCR %%
% Calculate latency to different aspects of learned CR

% Written by Kayla Fernando (11/28/22)

% NOTE: define the trial type to analyze and run sections separately

clear all
close all
clc

mouse = 'mouse'; 
experiment = 'experiment';
basepath = ['Z:\\home\kayla\Eyelid conditioning\' experiment '\'];
blackwin = [139 140 141 142];
bluewin = [47 48 49 50];

% Preprocess eyelid conditioning data, output promptData.txt
eyelidPreprocess; clearvars eyelid3_0_trials eyelid3_5_trials eyelid3_7_trials calib_trials catch_trials conditioning_trials 

% Define trial type to analyze (cspaired_all/cspaired_all_cell; cscatch_all/cscatch_all_cell)
if numel(unique(rig)) == 1
    trialType = cspaired_all;
elseif numel(unique(rig)) > 1
    trialType = cspaired_all_cell;
end

% Define windows
if numel(unique(rig)) == 1
    if strcmp(rig,'black') == 1
        win = blackwin; % determined through imageSubtraction.m
    elseif strcmp(rig,'blue') == 1 
        win = bluewin; % determined through imageSubtraction.m
    end
elseif numel(unique(rig)) > 1
    keep_trials = cell(1,length(files));
    for k = 1:length(files)
        if strcmp(rig{k},'black') == 1
            win{k} = blackwin;
         elseif strcmp(rig{k},'blue') == 1
            win{k} = bluewin;
        end
    end
end

% Use only successful trials
% If trained on multiple rigs, cell array output format will include 
% sessions that don't have trials and CRamps to keep (i.e., empty cells)
% Truncate these cell arrays in later sections
[keep_cramp,keep_trials] = sortTrials(rig,blackwin,bluewin,trialType,files);

%% Latency to CR onset (defined as 10 percent of CRamp)
% Use CS-US trials for larger sample size
% CS-catch trials work, too

% If same rig throughout training
if numel(unique(rig)) == 1
    abs_ten_percent = keep_cramp*0.10; % an absolute value
    % Black rig throughout training
    if strcmp(rig,'black') == 1
        baseline_ten_percent = round(mean(keep_trials(:,1:66),2)+abs_ten_percent,2); % add this absolute value to the baseline value in each trial
        for k = 1:size(keep_trials,1)
            keep_trials_temp = flip(keep_trials(k,68:143)); % window between CS onset and US onset, flip the signal
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
    latencies = latencies(latencies >= 100); % real CRs begin at least 100 ms post-CS onset from looking at eyelid traces, get rid of false positives

% If different rigs throughout training
elseif numel(unique(rig)) > 1
    abs_ten_percent = cellfun(@absTenPercent,keep_cramp,'UniformOutput',false); % an absolute value
    % If there are sessions (cells) without any trials to keep
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
    
    % If there are sessions (cells) without any trials to keep
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
    latencies = latencies(latencies >= 100); % real CRs have at least 100 ms latency from looking at eyelid traces, get rid of false positives
end

scatter(1:size(latencies),latencies)

%% Latency to CR peak
% Ideally use CS-catch trials
% Can use CS-US trials for larger sample size, but search window is biased

% If same rig throughout training
if numel(unique(rig)) == 1
    if strcmp(rig,'black') == 1
        for k = 1:size(keep_trials,1)
            if logical(size(trialType,1) == size(cscatch_all,1)) == 1
                keep_trials_temp = keep_trials(k,68:end);
                idx{k} = find(keep_trials_temp == max(keep_trials_temp),1,'first'); % find the first index where the eyelid position equals the maximum CR amplitude
                latencies{k} = idx{k}*3; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR reaches max amp. 3 ms/frame
            elseif logical(size(trialType,1) == size(cspaired_all,1)) == 1
                keep_trials_temp = keep_trials(k,68:142); % excludes US onset
                idx{k} = find(keep_trials_temp == max(keep_trials_temp),1,'first'); % find the first index where the eyelid position equals the maximum CR amplitude
                latencies{k} = idx{k}*3; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR reaches max amp. 3 ms/frame
            end
        end
    elseif strcmp(rig,'blue') == 1 
        for k = 1:size(keep_trials,1)
            if logical(size(trialType,1) == size(cscatch_all,1)) == 1
                keep_trials_temp = keep_trials(k,24:end);
                idx{k} = find(keep_trials_temp == max(keep_trials_temp),1,'first'); % find the first index where the eyelid position equals the maximum CR amplitude
                latencies{k} = idx{k}*8; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR reaches max amp. 8 ms/frame
            elseif logical(size(trialType,1) == size(cspaired_all,1)) == 1
                keep_trials_temp = keep_trials(k,24:50); % excludes US onset
                idx{k} = find(keep_trials_temp == max(keep_trials_temp),1,'first'); % find the first index where the eyelid position equals the maximum CR amplitude
                latencies{k} = idx{k}*8; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR reaches max amp. 8 ms/frame
            end
        end
    end
    latencies = vertcat(latencies{:}); % latencies b/w CS onset and CR peak in ms
    latencies = latencies(latencies >= 100 & latencies <= 350); % exclude detection of double blinks/grooming

% If different rigs throughout training
elseif numel(unique(rig)) > 1
    % If there are sessions (cells) without any trials to keep
    % (i.e., are empty)
    if any(cellfun(@isempty,keep_trials)) == 1
        empty = cellfun(@isempty,keep_trials);
        ses = find(empty == 0); % find the sessions that do have trials to keep
        keep_trials = keep_trials(~cellfun('isempty',keep_trials)); % truncate the list
        keep_cramp = keep_cramp(~cellfun('isempty',keep_cramp)); % truncate the list
        % Initialize idx and latencies cell arrays
        idx = cell(1,length(keep_trials));
        latencies = cell(1,length(keep_trials));
        for ii = 1:length(keep_trials);
            keep_trials_temp = keep_trials{ii};
            idx{ii} = cell(1,size(keep_trials_temp,1)); % truncate the list, keep relevant indices
            latencies{ii} = cell(1,size(keep_trials_temp,1)); % truncate the list, keep relevant indices
            rig{ii} = rig{ses(ii)}; % keep relevant indices
        end
        for n = length(keep_trials)+1:length(files)
            rig{n} = [];   
        end
        rig = rig(~cellfun('isempty',rig)); % truncate the list
    % If all sessions (cells) have trials to keep (i.e., no empty cells)      
    else
        % Initialize idx and latencies cell arrays
        idx = cell(1,length(files));
        latencies = cell(1,length(files));
        for k = 1:length(files)
            keep_cramp_temp = keep_cramp{k};
            idx{k} = cell(1,length(keep_cramp));
            latencies{k} = cell(1,length(keep_cramp));
        end
    end
    
    % If we had to get rid of empty cells
    if numel(files) ~= numel(keep_trials)
        k = 1:length(keep_trials); % use this session index
    % If we didn't have to get rid of empty cells    
    else
        k = 1:length(files); % iterate through the entire list
    end

    % For whichever index you use
    for k = k(1):k(end)
        if strcmp(rig{k},'black') == 1
            keep_trials_temp = keep_trials{k};
            for ii = 1:size(keep_trials_temp,1)
                keep_trials_temp2 = keep_trials_temp(ii,:);
                if logical(size(trialType,1) == size(cscatch_all,1)) == 1
                    keep_trials_window = keep_trials_temp2(1,68:end);
                    idx{k}{ii} = find(keep_trials_window == max(keep_trials_temp2),1,'first');  
                    latencies{k}{ii} = idx{k}{ii}*3; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR reaches max amp. 3 ms/frame
                elseif logical(size(trialType,1) == size(cspaired_all,1)) == 1
                    keep_trials_window = keep_trials_temp2(1,68:142); % excludes US onset
                    idx{k}{ii} = find(keep_trials_window == max(keep_trials_temp2),1,'first');  
                    latencies{k}{ii} = idx{k}{ii}*3; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR reaches max amp. 3 ms/frame
                end
            end
        elseif strcmp(rig{k},'blue') == 1
            keep_trials_temp = keep_trials{k};
            for ii = 1:size(keep_trials_temp,1)
                keep_trials_temp2 = keep_trials_temp(ii,:);  
                if logical(size(trialType,1) == size(cscatch_all,1)) == 1
                    keep_trials_window = keep_trials_temp2(1,24:end);
                    idx{k}{ii} = find(keep_trials_window == max(keep_trials_temp2),1,'first'); 
                    latencies{k}{ii} = idx{k}{ii}*8; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR reaches max amp. 8 ms/frame
                elseif logical(size(trialType,1) == size(cspaired_all,1)) == 1
                    keep_trials_window = keep_trials_temp2(1,24:50); % excludes US onset
                    idx{k}{ii} = find(keep_trials_window == max(keep_trials_temp2),1,'first'); 
                    latencies{k}{ii} = idx{k}{ii}*8; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR reaches max amp. 8 ms/frame
                end
            end
        end
    end

    % If there were empty cells
    if numel(files) ~= numel(keep_trials)
        k = 1:length(keep_trials);
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
    latencies = latencies';
    latencies = latencies(latencies >= 100 & latencies <= 350); % exclude detection of double blinks/grooming
end

scatter(1:size(latencies),latencies)

%% Standard deviation of CR latency and CR peak over time

% Comment out all 4 latency logicals in previous 2 sections
logic = (latencies(:,1) >= 100 & latencies(:,1) <= 350);

selectLatencies = latencies(logic);
selectTrials = keep_trials_idx(logic);

allData = horzcat(selectLatencies,selectTrials);

%% Plotting latencies over time
% Does NOT keep CRs in trial space

meanFilterFunction = @(block_struct) mean(block_struct.data);
m = blockproc(latencies,[20 1],meanFilterFunction);
subplot(2,1,1); plot(m);
subplot(2,1,2); scatter(1:length(m),m,'Marker','.');
