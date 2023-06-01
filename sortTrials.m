function varargout = sortTrials(rig,win,trialType,files)
% Sorts out trials (which type is defined by the user) where a CR occurred

% Written by Kayla Fernando (11/28/22)

% If same rig throughout training
if numel(unique(rig)) == 1
    % Black rig throughout training
    if strcmp(rig,'black') == 1
        win = [139 140 141 142]; % determined through imageSubtraction.m
        cramp = mean(trialType(:,win),2) - mean(trialType(:,1:66),2);
        for k = 1:length(cramp)
            if cramp(k) > 0.1 % 10 percent of normalized eyelid position throughout the trial
                keep_trials{k} = trialType(k,:); % keep the trials that satisfy criterion
            end
        end
        keep_trials_trialspace = keep_trials;
        keep_trials_idx = find(~cellfun('isempty',keep_trials));
        keep_trials = keep_trials(~cellfun('isempty',keep_trials)); keep_trials = vertcat(keep_trials{:});
        keep_baseline = mean(keep_trials(:,1:66),2);
        keep_cramp = mean(keep_trials(:,win),2) - keep_baseline; % keep the CRamp values that satisfy criterion
        fullCR = keep_baseline + keep_cramp; % unmasked CR
    % Blue rig throughout training
    elseif strcmp(rig,'blue') == 1 
        win = [47 48 49 50]; % determined through imageSubtraction.m
        cramp = mean(trialType(:,win),2) - mean(trialType(:,1:10),2);
        for k = 1:length(cramp)
            if cramp(k) > 0.1 % 10 percent of normalized eyelid position throughout the trial
                keep_trials{k} = trialType(k,:); % keep the trials that satisfy criterion
            end
        end
        keep_trials_trialspace = keep_trials;
        keep_trials_idx = find(~cellfun('isempty',keep_trials));
        keep_trials = keep_trials(~cellfun('isempty',keep_trials)); keep_trials = vertcat(keep_trials{:});
        keep_baseline = mean(keep_trials(:,1:10),2);
        keep_cramp = mean(keep_trials(:,win),2) - keep_baseline; % keep the CRamp values that satisfy criterion
        fullCR = keep_baseline + keep_cramp; % unmasked CR
    end 
    
% If different rigs throughout training    
elseif numel(unique(rig)) > 1
    
    % Keep the trials
    keep_trials = cell(1,length(files));
    keep_baseline = cell(1,length(files));
    fullCR = cell(1,length(files));
    cramp = {};
    
    for k = 1:length(files)
        % Fill this cell if on the black rig on this session
        if strcmp(rig{k},'black') == 1
            win{k} = [139 140 141 142];
            trialTypeTemp = trialType{k};
            cramp{k} = mean(trialTypeTemp(:,win{k}),2) - mean(trialTypeTemp(:,1:66),2); 
            keep_trials_temp = keep_trials{k};
            for ii = 1:length(cramp{k})
                cramp_temp = cramp{k};
                if cramp_temp(ii) > 0.1 % 10 percent of normalized eyelid position throughout the trial
                    keep_trials_temp{ii} = trialTypeTemp(ii,:); % keep the trials that satisfy criterion
                    keep_trials{k} = keep_trials_temp(~cellfun('isempty',keep_trials_temp)); keep_trials{k} = vertcat(keep_trials_temp{:}); 
                end
            end
            for jj = 1:size(keep_trials{k},1)
                keep_trials_temp_temp = keep_trials{k};
                keep_baseline{k} = mean(keep_trials_temp_temp(:,1:66),2);
            end
        % Fill this cell if on the blue rig on this session
        elseif strcmp(rig{k},'blue') == 1
            win{k} = [47 48 49 50];
            trialTypeTemp = trialType{k};
            cramp{k} = mean(trialTypeTemp(:,win{k}),2) - mean(trialTypeTemp(:,1:10),2); 
            keep_trials_temp = keep_trials{k};
            for ii = 1:length(cramp{k})
                cramp_temp = cramp{k};
                if cramp_temp(ii) > 0.1 % 10 percent of normalized eyelid position throughout the trial
                    keep_trials_temp{ii} = trialTypeTemp(ii,:); % keep the trials that satisfy criterion
                    keep_trials{k} = keep_trials_temp(~cellfun('isempty',keep_trials_temp)); keep_trials{k} = vertcat(keep_trials_temp{:});
                end
            end
            for jj = 1:size(keep_trials{k},1)
                keep_trials_temp_temp = keep_trials{k};
                keep_baseline{k} = mean(keep_trials_temp_temp(:,1:10),2);
            end
        end  
    end
    
    % Keep the CRamps
    keep_cramp = cell(1,length(files));
    
    % If there are sessions (cells) that are empty
    % (i.e., do not have any trials to keep)
    if any(cellfun(@isempty,keep_trials)) == 1
        empty = cellfun(@isempty,keep_trials);
        ses = find(empty == 0); % find the sessions that do have trials to keep
        for k = 1:length(files) % iterate through the entire list but nothing happens with empty cells
            for ii = 1:length(ses) % by specifically using this new session index
                keep_trials_temp = keep_trials{ses(ii)}; % calculate CRamps for these sessions only
                if strcmp(rig{ses(ii)},'black') == 1
                    keep_cramp{ses(ii)} = mean(keep_trials_temp(:,win{ses(ii)}),2) - mean(keep_trials_temp(:,1:66),2);
                    for jj = 1:size(keep_trials{k},1)
                        fullCR{k}(jj) = keep_baseline{k}(jj) + keep_cramp{k}(jj);
                    end
                elseif strcmp(rig{ses(ii)},'blue') == 1
                    keep_cramp{ses(ii)} = mean(keep_trials_temp(:,win{ses(ii)}),2) - mean(keep_trials_temp(:,1:10),2);
                    for jj = 1:size(keep_trials{k},1)
                        fullCR{k}(jj) = keep_baseline{k}(jj) + keep_cramp{k}(jj);
                    end
                end
            end
        end
    % If all sessions (cells) are filled (i.e., have trials to keep)    
    else
        for k = 1:length(files) % iterate through the entire list
            keep_trials_temp = keep_trials{k};
            if strcmp(rig{k},'black') == 1
                keep_cramp{k} = mean(keep_trials_temp(:,win{k}),2) - mean(keep_trials_temp(:,1:66),2);
                for jj = 1:size(keep_trials{k},1)
                    fullCR{k}(jj) = keep_baseline{k}(jj) + keep_cramp{k}(jj);
                end
            elseif strcmp(rig{k},'blue') == 1
                keep_cramp{k} = mean(keep_trials_temp(:,win{k}),2) - mean(keep_trials_temp(:,1:10),2);
                for jj = 1:size(keep_trials{k},1)
                    fullCR{k}(jj) = keep_baseline{k}(jj) + keep_cramp{k}(jj);
                end
            end
        end
    end
end

if nargout == 1
    varargout{1} = keep_cramp;
elseif nargout == 4
    varargout{1} = keep_cramp;
    varargout{2} = keep_trials;
    varargout{3} = keep_baseline;
    varargout{4} = fullCR;
else
    varargout{1} = keep_cramp;
    varargout{2} = keep_trials;
    varargout{3} = keep_baseline;
    varargout{4} = fullCR;
    varargout{5} = keep_trials_idx;
end

end
