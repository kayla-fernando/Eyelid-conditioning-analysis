function [h,outputArray] = crampCDF(data,range,outputArray,dataType,dataUnits)
% Edited by Kayla Fernando (5/4/22)
% Generates a cumulative distribution function (cdf) histogram for event
% data by randomly selecting which data points to plot based on the 
% least number of events detected in a sweep (such that all sweeps are
% weighed equally)
%   Inputs:
%       data = numeric array of all event data for all sweeps
%       range = range of sweeps (formatted as [n1 n2])
%       outputArray = array of values included in final plot
%       dataType = the kind of event data that is being analyzed, used for labeling figures here
%       dataUnits = the units of the event data, used for labeling figures here
%   Outputs:
%       h = handle for plot of cdf histogram for event data  
%       outputArray = array of values included in final plot and for further use (e.g. stats)

cutData = data(:,range(1):range(2));                    % make a copy to edit
cutData(find(cutData < 0)) = NaN;                       % change all negative and CRs to NaN                 
cutData(any(isnan(cutData),2),:) = [];                  % delete rows that contain NaN
cutData = convert2cell(cutData);                        % convert to a cell array so you can have columns of different sizes
for ii = 1:length(cutData)
    q(ii) = size(cutData{ii},1);                        % how many CRs (rows) per animal (cols)
    q = sort(q);                                        
end
q = q(1);                                               % smallest number of CRs

idx = cell(1,length(cutData));                          % idx for each animal
for col = 1:length(cutData)                             % fill one column one row element at a time, then go to the next column
    for row = 1:q                                       % for the least number of CRs
        idx{row,col} = randi([1,q],1,1);                % make an indexing array, total rows = least number of events, total cols = number of sweeps,
    end                                                 % element values = random integers based on dimensions of cut array
end
idx = cell2mat(idx);

outputArray = cell(1,length(cutData));                          % outputArray for each animal
for col = 1:length(cutData)                                     % fill one column one row element at a time, then go to the next column
    cutDataTemp = cutData{col}; 
    outputArrayTemp = outputArray{col};
    for row = 1:q                                               % for the least number of CRs
        outputArrayTemp(row,1) = cutDataTemp(idx(row,col));     % make the array for the histogram with idx to get the array element value from the original array 
    end
    outputArray{col} = outputArrayTemp;
end
outputArray = cell2mat(outputArray);

h = histogram(outputArray,'Normalization','cdf','DisplayStyle','stairs','BinWidth',0.001,'LineWidth',1.5); 
title(['Cumulative fraction ' dataType ' histogram']); 
xlabel([dataType ' ' '(' dataUnits ')']); 
ylabel('cumulative fraction');

% 220420: adjust renderer parameters for cdfs to export as .eps vector files
set(gcf,'renderer','Painters')
print -depsc -tiff -r300 -painters test.eps

end