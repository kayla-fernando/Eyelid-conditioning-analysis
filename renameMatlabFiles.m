close all
clear all
clc

experiment = 'experiment';

mouse = 'mouse';              
date = 'date';
numTrials = 110;

% Define the directory containing the files
dirPath = ['Z:\\home\kayla\Eyelid conditioning\' experiment '\' mouse '\' date];  % Change this to the directory where your files are stored

% Loop through the numbers 001 to numTrials
for n = 1:numTrials
    % Format the number with leading zeros (e.g., 001, 002, ..., 200)
    oldName = sprintf('TempBlk_%03d.mat', n);
    
    % Define the new name format
    newName = sprintf('%s_%s_s01_%03d.mat',mouse,date,n);
    
    % Get the full file paths
    oldFilePath = fullfile(dirPath, oldName);
    newFilePath = fullfile(dirPath, newName);
    
    % Check if the file exists
    if exist(oldFilePath, 'file')
        % Rename the file
        movefile(oldFilePath, newFilePath);
        % Display the renaming process (optional)
        fprintf('Renamed: %s -> %s\n', oldName, newName);
    else
        % If the file doesn't exist, display a warning (optional)
        fprintf('File not found: %s\n', oldName);
    end
end
