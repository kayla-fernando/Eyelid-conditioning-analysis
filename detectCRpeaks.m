%% detectCRpeaks %%
% Use the first derivative of eyelid traces from successful CS-US trials to detect CR peaks

% Written by Kayla Fernando (6/5/23)

clear all
close all
clc

mouse = 'KF49'; 
basepath = 'Y:\\home\kayla\Eyelid conditioning\ASTN2\';

% Preprocess eyelid conditioning data, output promptData.txt
eyelidPreprocess

% Define trial type to analyze (cspaired_all/cspaired_all_cell; cscatch_all/cscatch_all_cell)
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
[~,keep_trials,~,~,~] = sortTrials(rig,win,trialType,files);

% Search for CR peaks
event_indices = cell(1,size(keep_trials,1));
for k = 1:size(keep_trials,1)
    
    % Original eyelid trace
    t = 1:length(keep_trials(k,:));   
%     ax1 = subplot(2,1,1);
%     plot(keep_trials(k,:)); title([mouse ' original eyelid trace CS-US trial ' num2str(keep_trials_idx(k))]);
%     xline(gca,68,'b-','Alpha',1); xline(gca,143,'g-','Alpha',1);
  
    % First derivative to find rate of change
    dydx = gradient(keep_trials(k,:))./gradient(t);          
%     ax2 = subplot(2,1,2);
%     plot(dydx); title('First derivative'); 
%     xline(gca,68,'b-','Alpha',1); xline(gca,143,'g-','Alpha',1);

    % Search for CR peaks (i.e., local maxima)
    slope = 0; % Local maximum/minimum where slope is 0
%     refline(0, slope);
    state = 0; % A state variable
    event_indices_temp = [];
    for ii = 120:143 % strict search window
        if (state == 0) && (dydx(ii) < slope) && (dydx(ii-2) > slope) && (dydx(ii+2) < slope) % definition of local maximum
            state = 1;
            event_indices{k}(ii) = [event_indices_temp ii]; % event_indices will increase with each event
%             l = line([ii ii], [-0.05, 0.05]);
%             set(l, 'color', 'r');
        elseif (state == 1) && (dydx(ii) > slope) 
            state = 0;
        end
    end
    event_indices{k} = event_indices{k}(find(event_indices{k}));
    
%     linkaxes([ax1, ax2], 'x');

end

% How many trials had CRs with peaks, and how many peaks
peak_counts = cell(1,length(event_indices));
for k = 1:length(event_indices)
    peak_counts{k} = numel(event_indices{k});
end
peak_counts = cell2mat(peak_counts);
peak_number = unique(peak_counts)
frequency = histcounts(peak_counts)

% Pie chart
labels = {'Normal CR'; [num2str(peak_number(2)) ' peak']; 
        [num2str(peak_number(3)) ' peaks']; [num2str(peak_number(4)) ' peaks'];
        [num2str(peak_number(5)) ' peaks']; [num2str(peak_number(6)) ' peaks']};
h = pie(frequency, labels);
% patchHand = findobj(h, 'Type', 'Patch');
% colormap = {'#2f4b7c';     % normal CR
%             '#a05195';     % 1 peak
%             '#f95d6a';     % 2 peaks
%             '#ffa600'};    % 3 peaks
% set(patchHand, {'FaceColor'}, colormap)


