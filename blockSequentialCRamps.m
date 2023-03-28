function blockCRamps = blockSequentialCRamps(numBlocks,keep_trials_idx,keep_cramp)
% Takes successful trials and their corresponding CR amplitudes, bins them 
% into user-defined number of trial blocks while preserving the temporal 
% structure of training, then finds the average within that trial block. 
% Resulting array shows the true development of CRamp over the course of 
% training without interference of CRamps from unsuccessful trials.
% INPUTS:
%       numBlocks = number of trial blocks 
%       keep_trials_idx = index of trials that had a detected CR
%       keep_cramp = CRamp values from those successful trials
% OUTPUT:
%       blockCRamps = average CRamp at each trial block, 
%       calculated using only CRamps from successful trials within a trial 
%       block, preserving temporal structure of training

% Written by Kayla Fernando 3/28/23

n = 0; % initialize counter

% For the first numBlocks-1 bins
while n < numBlocks-1
    binRange = [n*100 n*100+99];
    idx = find(keep_trials_idx >= binRange(1) & keep_trials_idx < binRange(2)); % does not include right edge
    if isempty(idx)
        blockCRamps(n+1) = 0;
    else
        blockCRamps(n+1) = mean(keep_cramp(idx(1):idx(end)));
    end
    n = n+1;
end

% For the last (i.e., numBlocks) bin
if n == numBlocks-1 
    binRange = [n*100 n*100+100];
    idx = find(keep_trials_idx >= binRange(1) & keep_trials_idx <= binRange(2)); % includes right edge
    if isempty(idx)
        blockCRamps(20) = 0;
    else
        blockCRamps(20) = mean(keep_cramp(idx(1):idx(end)));
    end
end

end