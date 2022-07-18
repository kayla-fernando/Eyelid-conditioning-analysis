%% Calculate latency to different aspects of learned CR %%

& Written by Kayla Fernando (7/18/22)

clear all
close all
clc

mouse = 'KF21';
basepath = 'Y:\\All_Staff\home\kayla\Eyelid conditioning\';

prompt = input('Does this mouse have multiple sessions at any point during training? ("1" for yes, "0" for no) ');
switch prompt
    % If mouse has no multiple sessions at any point during training:
    case 0 
        prompt1 = input('Was this mouse trained on the same rig throughout training? ("1" for yes, "0" for no) ');
        switch prompt1
            % If not trained on the same rig throughout training:
            case 0 
                % Normalize eyelid traces
                [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,files,directory,trials,date] = getAllEyelidTraces(mouse,basepath);
                % Generate a list of which rig was used on each day for appropriate plotting parameters
                for k = 1:length(files)
                    r = input(['"1" for BLACK rig or "0" for BLUE rig on ' num2str(date{k}) ': '],"s");
                    if strcmp(r,'1') == 1
                        rig{k} = 'black'; 
                    elseif strcmp(r,'0') == 1 
                        rig{k} = 'blue'; 
                    end
                end
            % If trained on the same rig throughout training:
            case 1 
                prompt2 = input('Which rig? ("1" for BLACK, "0" for BLUE) ');
                switch prompt2
                    % Blue rig throughout all of training
                    case 0
                        % Normalize average eyelid traces of all trial types for each session
                        [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,cspaired_all,usonly_all,cscatch_all,files,directory,trials,date] = getAllEyelidTraces(mouse,basepath);
                        rig = cell(1,length(files)); rig(1,1:length(files)) = {'blue'};
                    % Black rig throughout all of training
                    case 1         
                        % Normalize average eyelid traces of all trial types for each session
                        [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,cspaired_all,usonly_all,cscatch_all,files,directory,trials,date] = getAllEyelidTraces(mouse,basepath);
                        rig = cell(1,length(files)); rig(1,1:length(files)) = {'black'};
                end
        end
    % If mouse has multiple sessions at any point during training:    
    case 1
        prompt1 = input('Was this mouse trained on the same rig throughout training? ("1" for yes, "0" for no) ');
        switch prompt1
            % If not trained on the same rig throughout training:
            case 0 
                % Normalize eyelid traces, combining multiple sessions on a given day if necessary
                [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,files,directory,trials,date] = getAllEyelidTraces_mSessions(mouse,basepath);
                % Generate a list of which rig was used for each day for appropriate plotting parameters
                for k = 1:length(files)
                    r = input(['"1" for BLACK rig or "0" for BLUE rig on ' num2str(date{k}) ': '],"s")
                    if strcmp(r,'1') == 1
                        rig{k} = 'black'; 
                    elseif strcmp(r,'0') == 1 
                        rig{k} = 'blue'; 
                    end
                end
            % If trained on the same rig throughout training:
            case 1 
                prompt2 = input('Which rig? ("1" for BLACK, "0" for BLUE) ');
                switch prompt2
                    % Blue rig throughout all of training
                    case 0
                        % Normalize average eyelid traces of all trial types for each session, combining multiple sessions on a given day if necessary
                        [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,cspaired_all,usonly_all,cscatch_all,files,directory,trials,date] = getAllEyelidTraces_mSessions(mouse,basepath);
                        rig = cell(1,length(files)); rig(1,1:length(files)) = {'blue'};
                    % Black rig throughout all of training
                    case 1
                        % Normalize average eyelid traces of all trial types for each session, combining multiple sessions on a given day if necessary
                        [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,cspaired_all,usonly_all,cscatch_all,files,directory,trials,date] = getAllEyelidTraces_mSessions(mouse,basepath);
                        rig = cell(1,length(files)); rig(1,1:length(files)) = {'black'};
                end
        end
end

% Define trial type to analyze
if numel(unique(rig)) == 1
    trialType = cspaired_all;
elseif numel(unique(rig)) > 1
    trialType = cspaired_all_cell;
end

if numel(unique(rig)) == 1
    if strcmp(rig,'black') == 1
        win = [126 127 128 129]; % determined through imageSubtraction.m
        cramp = mean(trialType(:,win),2) - mean(trialType(:,1:66),2);
        for k = 1:length(cramp)
            if cramp(k) > 0.1 % 10 percent of normalized eyelid position throughout the trial
                keep_trials{k} = trialType(k,:); % keep the trials that satisfy criterion
            end
        end
        keep_trials = keep_trials(~cellfun('isempty',keep_trials));
        keep_trials = vertcat(keep_trials{:});
        keep_cramp = mean(keep_trials(:,win),2) - mean(keep_trials(:,1:66),2); % keep the CRamp values that satisfy criterion
    elseif strcmp(rig,'blue') == 1 
        win = [35 36 37 38]; % determined through imageSubtraction.m
        cramp = mean(trialType(:,win),2) - mean(trialType(:,1:10),2);
        for k = 1:length(cramp)
            if cramp(k) > 0.1 % 10 percent of normalized eyelid position throughout the trial
                keep_trials{k} = trialType(k,:); % keep the trials that satisfy criterion
            end
        end
        keep_trials = keep_trials(~cellfun('isempty',keep_trials));
        keep_trials = vertcat(keep_trials{:});
        keep_cramp = mean(keep_trials(:,win),2) - mean(keep_trials(:,1:10),2); % keep the CRamp values that satisfy criterion
    end 
elseif numel(unique(rig)) > 1
    keep_trials = cell(1,length(files));
    for k = 1:length(files)
        if strcmp(rig{k},'black') == 1
            win{k} = [126,127,128,129];
            trialTypeTemp = trialType{k};
            cramp{k} = mean(trialTypeTemp(:,win{k}),2) - mean(trialTypeTemp(:,1:66),2); 
            keep_trials_temp = keep_trials{k};
            for ii = 1:length(cramp{k})
                cramp_temp = cramp{k};
                if cramp_temp(ii) > 0.1 % 10 percent of normalized eyelid position throughout the trial
                    keep_trials_temp{ii} = trialTypeTemp(ii,:); % keep the trials that satisfy criterion
                    keep_trials{k} = keep_trials_temp(~cellfun('isempty',keep_trials_temp));
                    keep_trials{k} = vertcat(keep_trials_temp{:}); 
                end
            end
        elseif strcmp(rig{k},'blue') == 1
            win{k} = [35,36,37,38];
            trialTypeTemp = trialType{k};
            cramp{k} = mean(trialTypeTemp(:,win{k}),2) - mean(trialTypeTemp(:,1:10),2); 
            keep_trials_temp = keep_trials{k};
            for ii = 1:length(cramp{k})
                cramp_temp = cramp{k};
                if cramp_temp(ii) > 0.1 % 10 percent of normalized eyelid position throughout the trial
                    keep_trials_temp{ii} = trialTypeTemp(ii,:); % keep the trials that satisfy criterion
                    keep_trials{k} = keep_trials_temp(~cellfun('isempty',keep_trials_temp));
                    keep_trials{k} = vertcat(keep_trials_temp{:});
                end
            end 
        end  
    end
    keep_cramp = cell(1,length(files));
    for k = 1:length(files)
        keep_trials_temp = keep_trials{k};
        if strcmp(rig{k},'black') == 1
            keep_cramp{k} = mean(keep_trials_temp(:,win{k}),2) - mean(keep_trials_temp(:,1:66),2);
        elseif strcmp(rig{k},'blue') == 1
            keep_cramp{k} = mean(keep_trials_temp(:,win{k}),2) - mean(keep_trials_temp(:,1:10),2);
        end
    end
end

%% Latency to CR onset (defined as 5 percent rise time)

if numel(unique(rig)) == 1
    abs_five_percent = keep_cramp*0.05; % an absolute value
    if strcmp(rig,'black') == 1
        baseline_five_percent = round(mean(keep_trials(:,1:66),2)+abs_five_percent,2); % add this absolute value to the baseline value in each trial
        for k = 1:length(keep_trials)
            keep_trials_temp = keep_trials(k,68:129); % window between CS onset and US onset
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
            latencies{k} = idx{k}*0.3; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR begins. 0.3 ms/frame
        end
    elseif strcmp(rig,'blue') == 1 
        baseline_five_percent = round(mean(keep_trials(:,1:10),2)+abs_five_percent,2); % add this absolute value to the baseline value in each trial
        for k = 1:length(keep_trials)
            keep_trials_temp = keep_trials(k,24:38); % window between CS onset and US onset
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
            latencies{k} = idx{k}*0.8; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR begins. 0.8 ms/frame
        end
    end
    latencies = vertcat(latencies{:}); % latencies b/w CS onset and CR onset in ms
elseif numel(unique(rig)) > 1
    abs_five_percent = cellfun(@abs_five_percent,keep_cramp,'UniformOutput',false); % an absolute value
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
            keep_trials_window = keep_trials_temp(:,68:129);
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
                latencies{k}{ii} = idx{k}{ii}*0.3; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR begins. 0.3 ms/frame
            end
        elseif strcmp(rig{k},'blue') == 1
            baseline_five_percent_temp = baseline_five_percent{k};
            keep_trials_temp = keep_trials{k};
            keep_trials_window = keep_trials_temp(:,24:38);
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
                latencies{k}{ii} = idx{k}{ii}*0.8; % our window starts at CS onset, therefore idx is the number of frames after CS onset that the CR begins. 0.8 ms/frame
            end
        end  
    end
    for k = 1:length(files)
        t{k} = cell2mat(latencies{k});
    end
    latencies = horzcat(t{1:length(files)})';
end

sort_latencies = sort(latencies);
