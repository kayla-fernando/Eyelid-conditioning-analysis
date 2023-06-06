%% detectCRpeaks %%
% Use the first derivative of eyelid traces from successful CS-US trials to detect CR peaks

% Written by Kayla Fernando (6/5/23)

clear all
close all
clc

mouse = 'mouse'; 
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

if numel(unique(rig)) > 1
    for k = 1:length(files)
        if strcmp(rig{k},'black') == 1
            win{k} = [139 140 141 142];
            trialTypeTemp = trialType{k};
            cramp{k} = mean(trialTypeTemp(:,win{k}),2) - mean(trialTypeTemp(:,1:66),2); 
        elseif strcmp(rig{k},'blue') == 1
            win{k} = [47 48 49 50];
            trialTypeTemp = trialType{k};
            cramp{k} = mean(trialTypeTemp(:,win{k}),2) - mean(trialTypeTemp(:,1:10),2); 
        end
    end
    cramp = vertcat(cramp{:});
end

% Use only successful trials
if numel(unique(rig)) == 1
    [~,keep_trials,~,~,keep_trials_idx] = sortTrials(rig,win,trialType,files);
elseif numel(unique(rig)) > 1
    [keep_cramp,keep_trials,~,~] = sortTrials(rig,win,trialType,files);
    if iscell(keep_cramp) == 1
        keep_cramp = cell2mat(keep_cramp');
        for n = 1:length(keep_cramp)
            keep_trials_idx(n) = find(cramp == keep_cramp(n));
        end
    end
    clear cramp; clear keep_cramp
end

% Search for CR peaks
if numel(unique(rig)) == 1
    event_indices = cell(1,size(keep_trials,1));
    for k = 1:size(keep_trials,1)
        % Original eyelid trace
        t = 1:length(keep_trials(k,:));
        % Search for CR peaks (i.e., local maxima) from first derivative
        dydx = gradient(keep_trials(k,:))./gradient(t);
        slope = 0; % Local maximum/minimum where slope is 0
        state = 0; % A state variable
        event_indices_temp = [];
        for ii = 120:143 % strict search window
            if (state == 0) && (dydx(ii) < slope) && (dydx(ii-2) > slope) && (dydx(ii+2) < slope) % definition of local maximum
                state = 1;
                event_indices{k}(ii) = [event_indices_temp ii]; % event_indices will increase with each event
            elseif (state == 1) && (dydx(ii) > slope) 
                state = 0;
            end
        end
        event_indices{k} = event_indices{k}(find(event_indices{k}));
    end
elseif numel(unique(rig)) > 1
    event_indices = cell(1,length(keep_trials));
    for k = 1:length(keep_trials)
        % Original eyelid trace
        t = 1:length(keep_trials{k});
        % Search for CR peaks (i.e., local maxima) from first derivative
        keep_trials_temp = keep_trials{k};
        event_indices_temp = cell(size(keep_trials_temp,1),1);
        for ii = 1:size(keep_trials_temp,1)
            dydx = gradient(keep_trials_temp(ii,:))./gradient(t);
            slope = 0; % Local maximum/minimum where slope is 0
            state = 0; % A state variable
            event_indices_temp_temp = [];
            for jj = 120:143 % strict search window
                if (state == 0) && (dydx(jj) < slope) && (dydx(jj-2) > slope) && (dydx(jj+2) < slope) % definition of local maximum
                    state = 1;
                    event_indices_temp{ii} = [event_indices_temp_temp jj]; % event_indices will increase with each event
                elseif (state == 1) && (dydx(jj) > slope) 
                    state = 0;
                end
            end
        end
        event_indices{k} = event_indices_temp;
    end    
end

% How many trials had CRs with peaks, and how many peaks
if numel(unique(rig)) == 1
    peak_counts = cell(1,length(event_indices));
    for k = 1:length(event_indices)
        peak_counts{k} = numel(event_indices{k});
    end
    peak_counts = cell2mat(peak_counts);
    peak_number = unique(peak_counts)
    frequency = histcounts(peak_counts)
elseif numel(unique(rig)) > 1
    for n = 1:length(event_indices)
        sums(1,n) = numel(event_indices{n});
    end
    peak_counts = cell(1,sum(sums)); clear sums
    event_indices = vertcat(event_indices{:})';
    for k = 1:length(event_indices)
        peak_counts{k} = numel(event_indices{k});
    end
    peak_counts = cell2mat(peak_counts);
    peak_number = unique(peak_counts)
    frequency = histcounts(peak_counts)
end

%%

% Pie chart
labels = {[num2str(peak_number(1)) ' peaks']; [num2str(peak_number(2)) ' peak']; 
          [num2str(peak_number(3)) ' peaks']; [num2str(peak_number(4)) ' peaks'];
          [num2str(peak_number(5)) ' peaks']; [num2str(peak_number(6)) ' peaks']};
h = pie(frequency, labels);
% patchHand = findobj(h, 'Type', 'Patch');
% colormap = {'#2f4b7c';     % 0 peaks
%             '#a05195';     % 1 peak
%             '#f95d6a';     % 2 peaks
%             '#ffa600'};    % 3 peaks
% set(patchHand, {'FaceColor'}, colormap)
