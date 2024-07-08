function varargout = getAllEyelidTracesVarISI(mouse,basepath)
% Written by Kayla Fernando (5/8/22)
%
% INPUTS:
%   mouse: mouse ID
%   basepath: general path to file
%
% OUTPUTS:
%   cspaired_all_cell: normalized eyelid traces for all CS-US trials
%   usonly_all_cell: normalized eyelid traces for all US only trials
%   cscatch_all_cell: normalized eyelid traces for all CS catch trials
%   cspaired_all: same as cspaired_all but in double array format, 1 row/trial
%   usonly_all: same as usonly_all  but in double array format, 1 row/trial
%   cscatch_all: same as cscatch_all but in double array format, 1 row/trial

directory = dir([basepath mouse]);

for ii = 1:numel(directory(:,1))
    filename = [basepath mouse '\' directory(ii).name '\trialdata.mat'];
    files{ii} = filename;
    if strcmp(files{ii},[basepath mouse '\.\trialdata.mat'])|strcmp(files{ii},[basepath mouse '\..\trialdata.mat'])
        files{ii} = [];
    end
    files = files(~cellfun('isempty',files));
end

for k = 1:length(files)
    data{k} = load(files{k});
    trials{k} = data{k}.trials;

    % Normalize eyelid traces
    eyelid{k} = trials{k}.eyelidpos;
    cs1pairedtrials{k} = find(trials{k}.c_usdur>0 & trials{k}.c_csnum==5); % CS1-US pairing
        cs2pairedtrials{k} = find(trials{k}.c_usdur>0 & trials{k}.c_csnum==6); % CS2-US pairing
    cs1catchtrials{k} = find(trials{k}.c_usdur==0 & trials{k}.c_csnum==5); % CS1 catch, referred to as "0" in code
        cs2catchtrials{k} = find(trials{k}.c_usdur==0 & trials{k}.c_csnum==6); % CS2 catch, referred to as "00" in code
    
    eyelid1_5{k} = trials{k}.eyelidpos(cs1pairedtrials{k},:);
        eyelid1_6{k} = trials{k}.eyelidpos(cs2pairedtrials{k},:);
    eyelid1_0{k} = trials{k}.eyelidpos(cs1catchtrials{k},:);
        eyelid1_00{k} = trials{k}.eyelidpos(cs2catchtrials{k},:);
    
    calibmin1{k} = min(eyelid{k});
    calibmin{k} = min(calibmin1{k}); % use only the most extreme value from all trials
    
    eyelid2_5{k} = eyelid1_5{k}-calibmin{k};
        eyelid2_6{k} = eyelid1_6{k}-calibmin{k};
    eyelid2_0{k} = eyelid1_0{k}-calibmin{k};
        eyelid2_00{k} = eyelid1_00{k}-calibmin{k};
    eyelid2_all{k} = eyelid{k}-calibmin{k};
    
    calibmax1{k} = max(eyelid2_all{k});
    calibmax{k} = max(calibmax1{k}); % use only the most extreme value from all trials
    
    eyelid3_5{k} = eyelid2_5{k}./calibmax{k}; % normalized CS1-US eyelid traces
        eyelid3_6{k} = eyelid2_6{k}./calibmax{k}; % normalized CS2-US eyelid traces
    eyelid3_0{k} = eyelid2_0{k}./calibmax{k}; % normalized CS1 eyelid traces
        eyelid3_00{k} = eyelid2_00{k}./calibmax{k}; % normalized CS2 eyelid traces

    cs1paired_all_cell = eyelid3_5; % cell format, each row is a trial and each column is eyelid position
        cs2paired_all_cell = eyelid3_6;
    cs1catch_all_cell = eyelid3_0;
        cs2catch_all_cell = eyelid3_00;
    
    % Get the dates
    date{k} = directory(k+2).name; 
    
end

if nargout == 4
    varargout{1} = cs1paired_all_cell;
    varargout{2} = cs1catch_all_cell;
    varargout{3} = cs2paired_all_cell;
    varargout{4} = cs2catch_all_cell;
elseif nargout == 8
    varargout{1} = cs1paired_all_cell;
    varargout{2} = cs1catch_all_cell;
    varargout{3} = cs2paired_all_cell;
    varargout{4} = cs2catch_all_cell;
    varargout{5} = files; 
    varargout{6} = directory; 
    varargout{7} = trials; 
    varargout{8} = date;
elseif nargout > 8
    cs1paired_all = vertcat(eyelid3_5{:}); % double array format, each row is a trial and each column is eyelid position
    cs2paired_all = vertcat(eyelid3_6{:}); 
    cs1catch_all = vertcat(eyelid3_0{:}); 
    cs2catch_all = vertcat(eyelid3_00{:});
    varargout{1} = cs1paired_all_cell;
    varargout{2} = cs1catch_all_cell;
    varargout{3} = cs2paired_all_cell;
    varargout{4} = cs2catch_all_cell;
    varargout{5} = cs1paired_all;
    varargout{6} = cs1catch_all;
    varargout{7} = cs2paired_all;
    varargout{8} = cs2catch_all;
    varargout{9} = files;
    varargout{10} = directory;
    varargout{11} = trials;
    varargout{12} = date;
end

end