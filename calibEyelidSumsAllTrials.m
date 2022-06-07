%% Binned CRprobs and CRamps across all trials %%

% Written by Elizabeth Fleming
% Edited by Kayla Fernando (5/8/22)

clear all
close all
clc

%% Load and normalize data

mouse = 'KF12'; 
basepath = 'Y:\\All_Staff\home\kayla\Eyelid conditioning\';

prompt = input('Does this animal have multiple sessions at any point during training? ("1" for yes, "0" for no) ');
switch prompt
    case 0
        [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,cspaired_all,usonly_all,cscatch_all,files,directory,trials] = getAllEyelidTraces(mouse,basepath);
    case 1
        [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,cspaired_all,usonly_all,cscatch_all,files,directory,trials] = getAllEyelidTraces_mSessions(mouse,basepath);
end

% Define trial type to analyze
trialType = cspaired_all;

%% Define parameters and block processing functions

% Define the block parameter (m rows by n cols block). We will average every m trials
blockSize = [100, 334];

% Block process the array to replace every element in the 100 element-wide block by the mean of the values in the block
    % First, define the averaging function for use by blockproc()
    meanFilterFunction = @(block_struct) mean(block_struct.data);
    % Now do the actual averaging (block average down to smaller size array)
    blockAveragedDownSignal = blockproc(trialType, blockSize, meanFilterFunction);
    % Let's check the output size
    [rows, columns] = size(blockAveragedDownSignal)
    % Also define the summation function for use by blocproc()
    sumFunction = @(block_struct) sum(block_struct.data);

%% CS-US Analysis Method 1: CS-US trial analysis using concatenated double array structure and hardcoded analysis window

% Make sure trialType = cspaired_all

% Binned CRamp
win = [126,127,128,129];
cramp = mean(trialType(:,win),2) - mean(trialType(:,1:66),2); 
blockSize2 = [100, 1];
CRamps = blockproc(cramp, blockSize2, meanFilterFunction);

% Binned CRprob
cramp2 = cramp>0.1;
blockSums = blockproc(cramp2, blockSize2, sumFunction);
CRprobs = blockSums./blockSize(1);

%% CS-US Analysis Method 2: CS-US trial analysis using cell array structure and calibrated analysis window

% % First, run calibEyelidSumsPerSession.m on the same mouse
% % Next, run Cell 2 and Cell 3 in calibEyelidSumsAllTrials.m on the same mouse
% % Make sure trialType = cspaired_all
% 
% % Binned CRamp 
% % (trying to calculate the CRamp of each session with its corresponding 
% % calibrated analysis window produces replicate column values...) 
% winAll = vertcat(win{:});
% win = round(mean(winAll)); % best estimate of accurate analysis window
% cramp = mean(trialType(:,win),2) - mean(trialType(:,1:66),2); 
% blockSize2 = [100, 1];
% CRamps = blockproc(cramp, blockSize2, meanFilterFunction);
% 
% % Binned CRprob
% cramp2 = cramp>0.1;
% blockSums = blockproc(cramp2, blockSize2, sumFunction);
% CRprobs = blockSums./blockSize(1);

%% CS-catch trial CRamp analysis using concatenated double array structure and hardcoded analysis window

% % First, run Cell 2 and Cell 3, Line 27 in calibEyelidSumsAllTrials.m
% % Make sure trialType = cscatch_all
% 
% % Binned CRamp
% win = [126,127,128,129];
% cramp = mean(trialType(:,win),2) - mean(trialType(:,1:66),2); 
% blockSize2 = [1, 1];
% CRamps = blockproc(cramp, blockSize2, meanFilterFunction);

%% Figures

% Heatmap of block-processed eyelid traces 
hold off
h = heatmap(blockAveragedDownSignal);
title([mouse ' CS-US eyelid traces ' num2str(blockSize(1)) '-trial blocks']);
%title(['US-only eyelid traces binned every ' num2str(blockSize(1)) ' trials']);
%title(['CS-catch eyelid traces binned every ' num2str(blockSize(1)) ' trials']
xlabel('Time from CS (s)');
ylabel('Trial block');
colormap(jet); %turbo in newer versions
colorbar;
caxis([0 1]);
% Get underlying axis handle
origState = warning('query','MATLAB:structOnObject');
cleanup = onCleanup(@()warning(origState));
warning('off','MATLAB:structOnObject')
s = struct(h);  % Undocumented
ax = s.Axes;    % Undocumented
clear('cleanup')
% Label x-axis
XLabels = trials{1}.tm(1,1:end);
CustomXLabels = string(XLabels);
h.XDisplayLabels = CustomXLabels;
h.XDisplayLabels = compose('%.2f',str2double(h.XDisplayLabels));
% Remove grids
h.GridVisible = 'off';
% Place lines around selected column (assumes 1 unit in size)
CS_col_1 = 68;  % frame
CS_col_2 = 151; % frame
xline(ax,[CS_col_1-0.5],'b-','Alpha',1,'LineWidth',1.5); xline(ax,[CS_col_2-0.5],'b-','Alpha',1,'LineWidth',1.5); % 2018b and newer
US_col_1 = 130; % frame
US_col_2 = 137; % frame
xline(ax,[US_col_1-0.5],'g-','Alpha',1,'LineWidth',1.5); xline(ax,[US_col_2-0.5],'g-','Alpha',1,'LineWidth',1.5); % 2018b and newer
% 220427: adjust renderer parameters for cdfs to export as .eps vector files
set(gcf,'renderer','Painters')
print -depsc -tiff -r300 -painters test.eps

% Plot binned CRamp learning curves
figure;
plot(CRamps);
title([mouse ' CRamp across all trials']);
xlabel('Trial block (100 trials each)');
ylabel('CRamp');
xlim([0 size(blockAveragedDownSignal,1)]); ylim([0 1]);
set(gca,'ytick',0:0.1:1);

% Plot binned CRprob learning curves
figure;
plot(CRprobs);
title([mouse ' CRprob across all trials']);
xlabel('Trial block (100 trials each)');
ylabel('CRprob');
xlim([0 size(blockAveragedDownSignal,1)]); ylim([0 1]);

%% Summary plots for all mice across all trials

% Load workspace
load('ISRIB Saline CRprobs CRamps all trials.mat');
ISRIB_CRprobs(ISRIB_CRprobs == 0) = NaN;
saline_CRprobs(saline_CRprobs == 0) = NaN;
ISRIB_CRamps(ISRIB_CRamps == 0) = NaN;
saline_CRamps(saline_CRamps == 0) = NaN;

% Plot binned CRprobs for all ISRIB mice across all trials
h1 = figure; title('CRprob across all trials'); xlabel('Trial block (100 trials each)'); ylabel('FEC'); ylim([0 1]);
shadedErrorBar(1:size(ISRIB_CRprobs,1),mean(ISRIB_CRprobs,2,'omitnan'),std(ISRIB_CRprobs,0,2,'omitnan'),'lineProps','r'); hold on
h2 = shadedErrorBar(1:size(saline_CRprobs,1),mean(saline_CRprobs,2,'omitnan'),std(saline_CRprobs,0,2,'omitnan')); hold off

% Plot binned CRamps for all saline mice across all trials
h3 = figure; title('CRamp across all trials'); xlabel('Trial block (100 trials each)'); ylabel('FEC'); ylim([0 1]);
shadedErrorBar(1:size(ISRIB_CRamps,1),mean(ISRIB_CRamps,2,'omitnan'),std(ISRIB_CRamps,0,2,'omitnan'),'lineProps','r'); hold on
h4 = shadedErrorBar(1:size(saline_CRamps,1),mean(saline_CRamps,2,'omitnan'),std(saline_CRamps,0,2,'omitnan')); hold off