function varargout = plotBlockProcessedSeqCRamps(numBlocks,keep_trials_idx,keep_cramp,keep_baseline,fullCR,mouse,blockSizeTemp,c)
% Takes successful trials and their corresponding CR amplitudes, bins them 
% into user-defined number of trial blocks while preserving the temporal 
% structure of training, then finds the average within that trial block. 
% Resulting array shows the true development of CRamp over the course of 
% training without interference of CRamps from unsuccessful trials.
% INPUTS:
%       numBlocks = number of trial blocks 
%       keep_trials_idx = index of trials that had a detected CR
%       keep_cramp = CRamp values from those successful trials
%       keep_baseline = baseline values from those successful trials
%       fullCR = full CRamp values (baseline + keep_cramp) from those successful trials
% OUTPUTS:
%       blockCRamps = average CRamp at each trial block, 
%           calculated using only CRamps from successful trials within a trial 
%           block, preserving temporal structure of training
%       blockFullCRamps = average full CRamp at each trial block,
%           calculated using only CRamps from successful trials within a trial 
%           block, preserving temporal structure of training
%       blockBaseline = average baseline value at each trial block,
%           calculated using only baseline values from successful trials within a trial 
%           block, preserving temporal structure of training
%       hf2 = plot binned CRamps using only successful CS-US trials while 
%           preserving temporal structure of training
%       hf3 = plot binned full CRamps only successful CS-US trials while 
%           preserving temporal structure of training
%       hf4 = plot each detected CRamp as it occurs throughout training
%       hf5 = plot each full detected CRamp as it occurs throughout training
%       hf6 = plot binned baseline values using only successful CS-US trials while 
%           preserving temporal structure of training

% Written by Kayla Fernando (3/28/23)

n = 0; % initialize counter

% For the first numBlocks-1 bins
while n < numBlocks-1
    binRange = [n*100 n*100+99];
    idx = find(keep_trials_idx >= binRange(1) & keep_trials_idx < binRange(2)); % does not include right edge
    if isempty(idx)
        blockCRamps(n+1) = 0;
        blockFullCRamps(n+1) = 0;
        blockBaseline(n+1) = 0;
    else
        blockCRamps(n+1) = mean(keep_cramp(idx(1):idx(end)));
        blockFullCRamps(n+1) = mean(fullCR(idx(1):idx(end)));
        blockBaseline(n+1) = mean(keep_baseline(idx(1):idx(end)));
    end
    n = n+1;
end

% For the last (i.e., numBlocks) bin
if n == numBlocks-1 
    binRange = [n*100 n*100+100];
    idx = find(keep_trials_idx >= binRange(1) & keep_trials_idx <= binRange(2)); % includes right edge
    if isempty(idx)
        blockCRamps(numBlocks) = 0;
        blockFullCRamps(numBlocks) = 0;
        blockBaseline(numBlocks) = 0;
    else
        blockCRamps(numBlocks) = mean(keep_cramp(idx(1):idx(end)));
        blockFullCRamps(numBlocks) = mean(fullCR(idx(1):idx(end)));
        blockBaseline(numBlocks) = mean(keep_baseline(idx(1):idx(end)));
    end
end

% Plot binned CRamps using only successful CS-US trials while preserving temporal structure of training
figure;
ax1 = subplot(2,1,1);
    hf2 = plot(blockCRamps);
    title([mouse ' CRamps of detected CRs in sequential order']);
    xlim([0 numBlocks]); xlabel(['Trial block (' num2str(blockSizeTemp(1)) ' trials each)']);
    ylim([0 1]); ylabel('Fraction of eye closed');
ax2 = subplot(2,1,2);
    hf3 = plot(blockFullCRamps);
    title([mouse ' full CRamps of detected CRs in sequential order']);
    xlim([0 numBlocks]); xlabel(['Trial block (' num2str(blockSizeTemp(1)) ' trials each)']);
    ylim([0 1]); ylabel('Fraction of eye closed');
linkaxes([ax1, ax2], 'x');

% Plot each detected CRamp as it occurs throughout training
figure;
ax3 = subplot(2,1,1);
    hf4 = scatter(keep_trials_idx,keep_cramp,'.',c);
    title([mouse ' all CRamps of detected CRs in sequential order']);
    xlim([0 numBlocks*blockSizeTemp(1)]); xlabel('Trial #');
    ylim([0 1]); ylabel('Fraction of eye closed');
ax4 = subplot(2,1,2);
    hf5 = scatter(keep_trials_idx,fullCR,'.',c);
    title([mouse ' all full CRamps of detected CRs in sequential order']);
    xlim([0 numBlocks*blockSizeTemp(1)]); xlabel('Trial #');
    ylim([0 1]); ylabel('Fraction of eye closed');
linkaxes([ax3, ax4], 'x');

% Plot binned baseline value using only successful CS-US trials while preserving temporal structure of training
figure;
hf6 = plot(blockBaseline);
title([mouse ' baseline value of detected CRs in sequential order']);
xlim([0 numBlocks]); xlabel(['Trial block (' num2str(blockSizeTemp(1)) ' trials each)']);
ylim([0 1]); ylabel('Fraction of eye closed');

% if nargout == 3
%     varargout{1} = blockCRamps;
%     varargout{2} = blockFullCRamps;
%     varargout{3} = blockBaseline;
if nargout > 1
    varargout{1} = blockCRamps;
    varargout{2} = blockFullCRamps;
    varargout{3} = blockBaseline;
    varargout{4} = hf2;
    varargout{5} = hf3;
    varargout{6} = hf4;
    varargout{7} = hf5;
    varargout{8} = hf6;
end
    
end
