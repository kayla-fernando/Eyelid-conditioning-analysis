% Find corrupted files
% Kayla Fernando (4/30/25)

% Set the maximum number of files to attempt
maxFiles = 110;

experiment = 'Thy1-ChR2';
mouse = 'KF315';
date = '250429';
basepath = ['Z:\\home\kayla\Eyelid conditioning\' experiment '\'];

for ii = 1:maxFiles
    % Create the file name with leading zeros
    fileNum = sprintf('%03d', ii);
    fileName = ([basepath mouse '\' date '\' mouse '_' date '_s01_' fileNum '.mat']);
    
    % Try to load the file
    try
        data = load(fileName);
    catch
        % If the file doesn't exist or fails to load, display the name
        fprintf('Failed to load file: %s\n', fileName);
        continue;
    end
end