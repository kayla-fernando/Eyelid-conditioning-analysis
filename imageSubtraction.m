%% Subtracting average image of the baseline period from a putative frame of when the airpuff is delivered in a US-only trial %%

% Written by Kayla Fernando (5/10/22)

clear all
close all
clc

%% Load data

mouse = 'mouse';
date = '220101';
experiment = 'experiment';
basepath = ['Y:\\All_Staff\home\kayla\Eyelid conditioning\' experiment '\']; 
basepath1 = 'Y:\\All_Staff\home\kayla\Eyelid conditioning analysis\'; 
basepath2 = 'Y:\\All_Staff\home\kayla\Image Processing';

load([basepath mouse '\' date '\trialdata.mat']);

% Range of frames to analyze; black rig = [130 160]; blue rig = [30 60]
range = [130 160];

%% Use the first 66 (black)/10 (blue) frames of a US-only trial as the baseline period

% Find a US-only trial
usonlytrials = find(trials.c_usdur>0 & trials.c_csnum==7);
analyze_trial = 1;

if usonlytrials(analyze_trial) < 10
    leadingzeros = sprintf('%02d',0);
    load([basepath mouse '\' date '\' sprintf('%s_%s_s01_',mouse,date) leadingzeros num2str(usonlytrials(analyze_trial)) '.mat']);
elseif usonlytrials(analyze_trial) >= 10 && usonlytrials(analyze_trial) <= 99
    leadingzeros = '0';
    load([basepath mouse '\' date '\' sprintf('%s_%s_s01_',mouse,date) leadingzeros num2str(usonlytrials(analyze_trial)) '.mat']);
else
    load([basepath mouse '\' date '\' sprintf('%s_%s_s01_',mouse,date) num2str(usonlytrials(analyze_trial)) '.mat']);
end

% Make a tempImages folder for baseline.tiff
mkdir([basepath1 mouse '\' date '\tempImages']);
newFolder = ([basepath1 mouse '\' date '\tempImages']);
cd(newFolder)

% Get the baseline period and save baseline.tiff in tempImages folder
Data = squeeze(data(:,:,1,1:66));
saveastiff(Data,[mouse '_' date '_s01_' num2str(usonlytrials(analyze_trial)) '_baseline.tiff']);

%% ImageJ

vers = ['R' version('-release')];
javaaddpath(['C:\Program Files\MATLAB\' vers '\java\mij.jar']);
javaaddpath(['C:\Program Files\MATLAB\' vers '\java\ij.jar']);
MIJ.start(java.lang.String(basepath2)); % loads macros

% Drag and drop the baseline .tiff into ImageJ

%% Save average projection image in tempImages folder

% Shortcut: CTRL + s
MIJ.run('baseline')
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

% Browse to the folder containing the image sequence you want to see
MIJ.run('Image Sequence...')
MIJ.run('3-3-2 RGB')
MIJ.run('Start Animation [\]')

%% Close ImageJ

MIJ.closeAllWindows
MIJ.exit
