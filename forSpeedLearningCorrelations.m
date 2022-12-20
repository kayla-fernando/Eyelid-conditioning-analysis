%% 1. Rank and color-code mice by speed, plot CRprob or CRamp learning curves

% Average speed per mouse calculated using encoderSpeed.m
% CRprob learning curve as a function of cumulative trials per mouse   
%   calculated using eyelidSumsAllTrials.m
% CRamp learning curve as a function of cumulative trials per mouse
%   calculated using eyelidSumsAllTrials.m

% Written by Kayla Fernando (12/20/22)

load('ASTN2 avg speed learning corrs.mat')
data = ASTN2_WT_avgspeed_CRamps;

colorScheme = [1 0 0]; % slower mice are red, faster mice are blue

for k = 1:size(data,2)
    dataTemp = data(:,k);
    map(k,1:3) = colorScheme;
    plot(dataTemp(2:20,1),'LineWidth',1.25,'Color',colorScheme);
    ylim([0 1])
        colorScheme(1) = colorScheme(1) - 0.1;
        colorScheme(3) = colorScheme(3) + 0.1;
    hold on
end

colormap(map);
c = colorbar('TickLabels',{'',mat2str(data(end,1)),...
                              mat2str(data(end,2)),...
                              mat2str(data(end,3)),...
                              mat2str(data(end,4)),...
                              mat2str(data(end,5)),...
                              mat2str(data(end,6)),...
                              mat2str(data(end,7)),...
                              mat2str(data(end,8)),...
                              mat2str(data(end,9))});
c.Label.String = 'Mice ranked from slowest (red) to fastest (blue)';
xlabel('Trial block (50 trials each)'); ylabel('CRamp (using only successful CS-US trials)');
set(gcf,'Position',[500 500 1000 500]);

hold off

%% 2a. For plotting average speed of a session and CRprob for that same session

mouse = 'mouse'; 
basepath = 'Y:\\';
% date = {'220101', '220102',...
%         '220103', '220104'}; 

% Preprocess eyelid conditioning data, output promptData.txt
eyelidPreprocess

% Modified from makePlots.m
data = [];    
for n = 1:length(date)
    load(['Y:\\home\kayla\Eyelid conditioning\' mouse '\' date{n} '\trialdata.mat']);
    [h1,h2,CRprob] = makePlots(trials,"black",[139 140 141 142]);
    %[h1,h2,CRprob] = makePlots(trials,"blue",[47 48 49 50]);
    data(n) = CRprob;
end
close all
data = data';

%% 2b. For plotting average speed of a session and CRamp for that same session

mouse = 'mouse'; 
basepath = 'Y:\\';

% Preprocess eyelid conditioning data, output promptData.txt
    eyelidPreprocess

% Modified from sortTrials.m
    trialType = cspaired_all_cell;
    data = [];

    % Keep the trials
    keep_trials = cell(1,length(files));
    
    for k = 1:length(files)
        % Fill this cell if on the black rig on this session
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
        % Fill this cell if on the blue rig on this session
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

    % Keep the CRamps
    keep_cramp = cell(1,length(files));

    % If there are sessions (cells) that do not have any trials to keep
    % (i.e., are empty)
    if any(cellfun(@isempty,keep_trials)) == 1
        empty = cellfun(@isempty,keep_trials);
        ses = find(empty == 0); % find the sessions that do have trials to keep
        for k = 1:length(files) % iterate through the entire list but nothing happens with empty cells
            for ii = 1:length(ses) % by specifically using this new session index
                keep_trials_temp = keep_trials{ses(ii)}; % calculate CRamps for these sessions only
                if strcmp(rig{ses(ii)},'black') == 1
                    keep_cramp{ses(ii)} = mean(keep_trials_temp(:,win{ses(ii)}),2) - mean(keep_trials_temp(:,1:66),2);
                elseif strcmp(rig{ses(ii)},'blue') == 1
                    keep_cramp{ses(ii)} = mean(keep_trials_temp(:,win{ses(ii)}),2) - mean(keep_trials_temp(:,1:10),2);
                end
            end
        end
    % If all sessions (cells) have trials to keep (i.e., no empty cells)    
    else
        for k = 1:length(files) % iterate through the entire list
            keep_trials_temp = keep_trials{k};
            if strcmp(rig{k},'black') == 1
                keep_cramp{k} = mean(keep_trials_temp(:,win{k}),2) - mean(keep_trials_temp(:,1:66),2);
            elseif strcmp(rig{k},'blue') == 1
                keep_cramp{k} = mean(keep_trials_temp(:,win{k}),2) - mean(keep_trials_temp(:,1:10),2);
            end
        end
    end

    for n = 1:length(keep_cramp)
        data(n) = mean(keep_cramp{n});
    end
    data = data';

%% 3. For plotting learning curves and speed on two y-axes

% Add speeds per session in second column of variable "data"
% label y-axes accordingly
yyaxis left; plot(data(:,1)); ylim([0 1]); ylabel('CRamp (using only successful CS-US trials)'); 
yyaxis right; plot(data(:,2)); ylabel('Average speed (m/s)')
title(mouse); xlabel('Session')
