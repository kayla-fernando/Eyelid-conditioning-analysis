%% Subtracting average image of the baseline period from a putative frame of when the airpuff is delivered in a US-only trial %%

% Written by Kayla Fernando (5/10/22)

clear all
close all
clc

%% Load data

mouse = 'KF10';
date = '220607';
basepath = 'Y:\\All_Staff\home\kayla\Eyelid conditioning\'; 
basepath1 = 'Y:\\All_Staff\home\kayla\Eyelid conditioning analysis\'; 
basepath2 = 'Y:\\All_Staff\home\kayla\Image Processing';

load([basepath mouse '\' date '\trialdata.mat']);

% Range of frames to analyze
range = [120 160];

%% Use the first 66 frames of a US-only trial as the baseline period

% Find a US-only trial
usonlytrials = find(trials.c_usdur>0 & trials.c_csnum==7);
analyze_trial = 1;

if usonlytrials(analyze_trial) < 10
    leadingzeros = sprintf('%02d',0);
    load([basepath mouse '\' date '\' sprintf('Data_%s_s01_',date) leadingzeros num2str(usonlytrials(analyze_trial)) '.mat']);
elseif usonlytrials(analyze_trial) >= 10 && usonlytrials(analyze_trial) <= 99
    leadingzeros = '0';
    load([basepath mouse '\' date '\' sprintf('Data_%s_s01_',date) leadingzeros num2str(usonlytrials(analyze_trial)) '.mat']);
else
    load([basepath mouse '\' date '\' sprintf('Data_%s_s01_',date) num2str(usonlytrials(analyze_trial)) '.mat']);
end

% Make a tempImages folder for baseline.tiff
mkdir([basepath1 mouse '\' date '\tempImages']);
newFolder = ([basepath1 mouse '\' date '\tempImages']);
cd(newFolder)

% Get the baseline period and save baseline.tiff in tempImages folder
Data = squeeze(data(:,:,1,1:66));
saveastiff(Data,[mouse '_' date '_s01_' num2str(usonlytrials(analyze_trial)) '_baseline.tiff']);

%% ImageJ

javaaddpath('C:\Program Files\MATLAB\R2019b\java\mij.jar');
javaaddpath('C:\Program Files\MATLAB\R2019b\java\ij.jar');
MIJ.start(java.lang.String(basepath2)); % loads macros

% Load the baseline .tiff
% Plugins > baseline

%% Save average projection image in tempImages folder

% Shortcut: CTRL + s
MIJ.run('Save')

%% Set a range of putative frames of when the airpuff is delivered

% Save each frame as a .tiff in the tempImages folder
for k = range(1):range(2)
    Data = squeeze(data(:,:,1,k));
    saveastiff(Data,[mouse '_' date '_s01_' num2str(usonlytrials(analyze_trial)) '_' num2str(k) '.tiff']);
end

clc

%% Image subtraction

% Make a subtractedImages folder for image subtraction .tiffs
mkdir([basepath1 mouse '\' date '\subtractedImages'])
newFolder = ([basepath1 mouse '\' date '\subtractedImages']);
cd(newFolder)

% Save each result as a .tiff in the subtractedImages folder
for k = range(1):range(2)
    [A,CData] = imread([basepath1 mouse '\' date '\tempImages\' mouse '_' date '_s01_' num2str(usonlytrials(analyze_trial)) '_' num2str(k) '.tiff']);
    [B,CData] = imread([basepath1 mouse '\' date '\tempImages\AVG_' mouse '_' date '_s01_' num2str(usonlytrials(analyze_trial)) '_baseline.tif']);
    Z = imsubtract(A,B);
    saveastiff(Z,['Result of ' mouse '_' date '_s01_' num2str(usonlytrials(analyze_trial)) '_' num2str(k) '.tiff']); 
end

clc

% File > Import > Image Sequence 
% Image > Lookup Tables > 3-3-2 RGB
% Image > Stacks > Animation > Animation options (shortcut: "\" key)

%% Close ImageJ

MIJ.closeAllWindows
MIJ.exit
