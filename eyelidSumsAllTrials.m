%% eyelidSumsAllTrials %%
% Binned CRprobs and CRamps across all trials

% Written by Kayla Fernando (3/28/23)

clear all
close all
clc

mouse = ['KF267']; 
experiment = 'Thy1-ChR2';
basepath = ['Z:\\home\kayla\Eyelid conditioning\' experiment '\'];
controlGroup = 1;
blackwin = [52 53 54 55]; %[139 140 141 142]; %241104: accomodating for new black rig params
           %[23 24 25 26]; % sham optotraining for US-only trial analysis
bluewin =  [50 51 52 53]; % optotraining 250 ms ISI & CS-catch trial analysis           
           %[79 80 81 82]; % optotraining 500 ms ISI
           %[22 23 24 25]; % sham optotraining for US-only trial analysis
           %[76 77 78 79]; % 5 kHz tone (CS2 training)       
trialblocksize = 50;
load('Z:\home\kayla\MATLAB\Saved workspaces\timesBlue.mat');

% Preprocess eyelid conditioning data, output promptData.txt
eyelidPreprocess; clearvars eyelid3_0_trials eyelid3_5_trials eyelid3_7_trials calib_trials catch_trials conditioning_trials % analyzing normally
% eyelidPreprocessVarISI; clearvars eyelid3_0_trials eyelid3_00_trials eyelid3_5_trials eyelid3_6_trials CS1_catch_trials CS1_conditioning_trials CS2_catch_trials CS2_conditioning_trials % analyzing variable ISI

% Define trial type to analyze
if numel(unique(rig)) == 1
    trialType = cspaired_all; %cs2paired_all; 
    if size(trialType,2) == 334; %241104: accomodating for new black rig params
        trialType = trialType(:,1:200);
    end
elseif numel(unique(rig)) > 1
    trialType = cspaired_all_cell; %cs2paired_all_cell; 
    for n = 1:size(trialType,2)
        if size(trialType{n},2) == 334; %241104: accomodating for new black rig params
            trialType{n} = trialType{n}(:,1:200);
        end
    end
end 

% Block process the array to replace every element in the 100 element-wide block by the mean of the values in the block
    % First, define the averaging function for use by blockproc()
    meanFilterFunction = @(block_struct) mean(block_struct.data);
    % Define the block parameters (m rows by n cols block). We will average every m trials
    for k = 1:length(files)
        if strcmp(rig{k},'black') == 1
            blockSize{k} = [trialblocksize 200]; %[trialblocksize 334]; %241104: accomodating for new black rig params
        elseif strcmp(rig{k},'blue') == 1
            blockSize{k} = [trialblocksize 200];
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
            win = blackwin;
            cramp = mean(trialType(:,win),2) - mean(trialType(:,1:10),2); %mean(trialType(:,1:66),2); %241104: accomodating for new black rig params
        elseif strcmp(rig,'blue') == 1
            win = bluewin;
            cramp = mean(trialType(:,win),2) - mean(trialType(:,1:10),2); 
        end
        blockSize2 = [trialblocksize 1];
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
                win{k} = blackwin;
                trialTypeTemp = trialType{k};
                cramp{k} = mean(trialTypeTemp(:,win{k}),2) - mean(trialType(:,1:10),2); %mean(trialTypeTemp(:,1:66),2); %241104: accomodating for new black rig params
            elseif strcmp(rig{k},'blue') == 1
                win{k} = bluewin;
                trialTypeTemp = trialType{k};
                cramp{k} = mean(trialTypeTemp(:,win{k}),2) - mean(trialTypeTemp(:,1:10),2); 
            end
    end
            cramp = vertcat(cramp{:});
            blockSize2 = [trialblocksize 1];
            CRamps = blockproc(cramp, blockSize2, meanFilterFunction);
        % Binned CRprob
            cramp2 = cramp>0.1;
            blockSums = blockproc(cramp2, blockSize2, sumFunction);
            for k = 1:length(files)
                blockSizeTemp = blockSize{k};
                CRprobs = blockSums./blockSizeTemp(1);
            end
end
[h,hf1] = plotBlockProcessedTrials(blockAveragedDownSignal,mouse,rig,files,trials,blockSizeTemp,CRprobs,times);
     
% Calculate and plot binned CRamps across all trials using only successful CS-US trials while preserving temporal structure of training
if numel(unique(rig)) == 1
    [keep_cramp,keep_trials,keep_baseline,fullCR,keep_trials_idx] = sortTrials(rig,blackwin,bluewin,trialType,files);
elseif numel(unique(rig)) > 1
    [keep_cramp,keep_trials,keep_baseline,fullCR] = sortTrials(rig,blackwin,bluewin,trialType,files);
    if iscell(keep_cramp) == 1
        keep_cramp = cell2mat(keep_cramp');
        for n = 1:length(keep_cramp)
            keep_trials_idx(n) = find(cramp == keep_cramp(n),1);
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
[blockCRamps,blockFullCRamps,blockBaseline,hf2,hf3,hf4,hf5,hf6] = plotBlockProcessedSeqCRamps(1000/trialblocksize,keep_trials_idx,keep_cramp,keep_baseline,fullCR,mouse,blockSizeTemp,c);
blockCRamps = blockCRamps';

% % Plot representative eyelid traces for the naive, intermediate, and learned conditions
% hf7 = figure;
% eyelidSumsLearningEpochsForVis

delete promptData.txt test.eps
