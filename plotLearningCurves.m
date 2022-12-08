%% Summary plots for all mice across all trials

% Written by Kayla Fernando (7/10/22)

close all
clear all
clc

% Load workspace
load('ISRIB Saline CRprobs CRamps all trials.mat');
ISRIB_CRprobs(ISRIB_CRprobs == 0) = NaN;
saline_CRprobs(saline_CRprobs == 0) = NaN;
ISRIB_CRamps(ISRIB_CRamps == 0) = NaN;
saline_CRamps(saline_CRamps == 0) = NaN;

% Plot binned CRprobs for all ISRIB mice across all trials
h1 = figure; title('CRprob across all trials'); xlabel('Trial block (100 trials each)'); ylabel('Probability'); ylim([0 1]); xlim([0 20]);
shadedErrorBar(1:size(ISRIB_CRprobs,1),mean(ISRIB_CRprobs,2,'omitnan'),std(ISRIB_CRprobs,0,2,'omitnan'),'lineProps','r'); hold on
h2 = shadedErrorBar(1:size(saline_CRprobs,1),mean(saline_CRprobs,2,'omitnan'),std(saline_CRprobs,0,2,'omitnan'),'lineProps','b'); hold off

% Plot binned CRamps for all saline mice across all trials
h3 = figure; title('CRamp across all trials'); xlabel('Trial block (100 trials each)'); ylabel('FEC'); ylim([0 0.5]); xlim([0 20]);
shadedErrorBar(1:size(ISRIB_CRamps,1),mean(ISRIB_CRamps,2,'omitnan'),std(ISRIB_CRamps,0,2,'omitnan'),'lineProps','r'); hold on
h4 = shadedErrorBar(1:size(saline_CRamps,1),mean(saline_CRamps,2,'omitnan'),std(saline_CRamps,0,2,'omitnan'),'lineProps','b'); hold off
