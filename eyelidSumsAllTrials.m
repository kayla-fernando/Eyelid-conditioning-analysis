%% eyelidSumsAllTrials %%
% Binned CRprobs and CRamps across all trials

% Written by Kayla Fernando (3/28/23)

clear all
close all
clc

mouse = 'mouse'; 
basepath = 'Y:\\';
controlGroup = 1;

% Preprocess eyelid conditioning data, output promptData.txt
eyelidPreprocess; clear eyelid3_0_trials; clear eyelid3_5_trials; clear eyelid3_7_trials;

% Define trial type to analyze
if numel(unique(rig)) == 1
    trialType = cspaired_all;
elseif numel(unique(rig)) > 1
    trialType = cspaired_all_cell;
end

% Block process the array to replace every element in the 100 element-wide block by the mean of the values in the block
    % First, define the averaging function for use by blockproc()
    meanFilterFunction = @(block_struct) mean(block_struct.data);
    % Define the block parameters (m rows by n cols block). We will average every m trials
    for k = 1:length(files)
        if strcmp(rig{k},'black') == 1
            blockSize{k} = [100 334];
        elseif strcmp(rig{k},'blue') == 1
            blockSize{k} = [100 200];
        end
    end
    % Now do the actual averaging (block average down to smaller size array)
    if numel(unique(rig)) == 1
        for k = 1:length(files)
            blockAveragedDownSignal = blockproc(trialType, blockSize{k}, meanFilterFunction);
        end
        % Let's check the output size
        [bins, frames] = size(blockAveragedDownSignal)
    elseif numel(unique(rig)) > 1
        for k = 1:length(files)
            blockAveragedDownSignal{k} = blockproc(trialType{k}, blockSize{k}, meanFilterFunction);
            frames(k) = size(blockAveragedDownSignal{k},2);
        end
        % Let's check the output size
        bins = size(blockAveragedDownSignal{1},1)
        frames = unique(frames)
    end
    
    % Also define the summation function for use by blocproc()
    sumFunction = @(block_struct) sum(block_struct.data);
  
% Calculate and plot binned CRprobs across all trials using all CS-US trials
if numel(unique(rig)) == 1
    % Binned CRamp
        if strcmp(rig,'black') == 1
            win = [139 140 141 142];
            cramp = mean(trialType(:,win),2) - mean(trialType(:,1:66),2); 
        elseif strcmp(rig,'blue') == 1
            win = [47 48 49 50];
            cramp = mean(trialType(:,win),2) - mean(trialType(:,1:10),2); 
        end
        blockSize2 = [100 1];
        CRamps = blockproc(cramp, blockSize2, meanFilterFunction);
    % Binned CRprob
        cramp2 = cramp>0.1;
        blockSums = blockproc(cramp2, blockSize2, sumFunction);
        for k = 1:length(files)
            blockSizeTemp = blockSize{k};
            CRprobs = blockSums./blockSizeTemp(1);
        end
elseif numel(unique(rig)) > 1
    for k = 1:length(files)
        % Binned CRamp
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
            blockSize2 = [100 1];
            CRamps = blockproc(cramp, blockSize2, meanFilterFunction);
        % Binned CRprob
            cramp2 = cramp>0.1;
            blockSums = blockproc(cramp2, blockSize2, sumFunction);
            for k = 1:length(files)
                blockSizeTemp = blockSize{k};
                CRprobs = blockSums./blockSizeTemp(1);
            end
end
[h,hf1] = plotBlockProcessedTrials(blockAveragedDownSignal,mouse,rig,files,trials,blockSizeTemp,CRprobs);
     
% Calculate and plot binned CRamps across all trials using only successful CS-US trials while preserving temporal structure of training
if numel(unique(rig)) == 1
    [keep_cramp,keep_trials,keep_baseline,fullCR,keep_trials_idx] = sortTrials(rig,win,trialType,files);
elseif numel(unique(rig)) > 1
    [keep_cramp,keep_trials,keep_baseline,fullCR] = sortTrials(rig,win,trialType,files);
    if iscell(keep_cramp) == 1
        keep_cramp = cell2mat(keep_cramp');
        for n = 1:length(keep_cramp)
            keep_trials_idx(n) = find(cramp == keep_cramp(n));
         end
    end
    if iscell(keep_baseline) == 1
        keep_baseline = cell2mat(keep_baseline');
    end
    if iscell(fullCR) == 1
        fullCR = cell2mat(fullCR)';
    end
end

if controlGroup == 1 
    c = 'b'; else c = 'r'; end
[blockCRamps,blockFullCRamps,blockBaseline,hf2,hf3,hf4,hf5,hf6] = plotBlockProcessedSeqCRamps(20,keep_trials_idx,keep_cramp,keep_baseline,fullCR,mouse,blockSizeTemp,c);

% Plot representative eyelid traces for the naive, intermediate, and learned conditions
hf7 = figure;
eyelidSumsLearningEpochsForVis
