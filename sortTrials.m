function varargout = sortTrials(rig,win,trialType,files)

if numel(unique(rig)) == 1
    if strcmp(rig,'black') == 1
        win = [139 140 141 142]; % determined through imageSubtraction.m
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
        win = [47 48 49 50]; % determined through imageSubtraction.m
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
            win{k} = [139 140 141 142];
            trialTypeTemp = trialType{k};
            cramp = {};
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
            win{k} = [47 48 49 50];
            trialTypeTemp = trialType{k};
            cramp = {};
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

if nargout == 1
    varargout{1} = keep_cramp;
elseif nargout > 1
    varargout{1} = keep_cramp;
    varargout{2} = keep_trials;
end

end