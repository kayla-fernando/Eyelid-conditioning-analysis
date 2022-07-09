function varargout = getAllEyelidTraces(mouse,basepath)
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
    cspairedtrials{k} = find(trials{k}.c_usdur>0 & trials{k}.c_csnum==5); % CS-US pairing
    ustrials{k} = find(trials{k}.c_csnum==7); % US only
    catchtrials{k} = find(trials{k}.c_usdur==0 & trials{k}.c_csnum==5); % CS catch, referred to as "0" in code
    
    eyelid1_5{k} = trials{k}.eyelidpos(cspairedtrials{k},:);
    eyelid1_7{k} = trials{k}.eyelidpos(ustrials{k},:);
    eyelid1_0{k} = trials{k}.eyelidpos(catchtrials{k},:);
    
    calibmin1{k} = min(eyelid{k});
    calibmin{k} = min(calibmin1{k}); % use only the most extreme value from all trials
    
    eyelid2_5{k} = eyelid1_5{k}-calibmin{k};
    eyelid2_7{k} = eyelid1_7{k}-calibmin{k};
    eyelid2_0{k} = eyelid1_0{k}-calibmin{k};
    eyelid2_all{k} = eyelid{k}-calibmin{k};
    
    calibmax1{k} = max(eyelid2_all{k});
    calibmax{k} = max(calibmax1{k}); % use only the most extreme value from all trials
    
    eyelid3_5{k} = eyelid2_5{k}./calibmax{k}; % normalized CS-US eyelid traces
    eyelid3_7{k} = eyelid2_7{k}./calibmax{k}; % normalized US eyelid traces
    eyelid3_0{k} = eyelid2_0{k}./calibmax{k}; % normalized CS eyelid traces

    cspaired_all_cell = eyelid3_5; % cell format, each row is a trial and each column is eyelid position
    usonly_all_cell = eyelid3_7;
    cscatch_all_cell = eyelid3_0;
    
    % Get the dates
    date{k} = directory(k+2).name; 
    
end

if nargout == 3
    varargout{1} = cspaired_all_cell;
    varargout{2} = usonly_all_cell;
    varargout{3} = cscatch_all_cell;
elseif nargout == 7
    varargout{1} = cspaired_all_cell;
    varargout{2} = usonly_all_cell;
    varargout{3} = cscatch_all_cell;
    varargout{4} = files; 
    varargout{5} = directory; 
    varargout{6} = trials; 
    varargout{7} = date;
elseif nargout > 7
    cspaired_all = vertcat(eyelid3_5{:}); % double array format, each row is a trial and each column is eyelid position
    usonly_all = vertcat(eyelid3_7{:}); 
    cscatch_all = vertcat(eyelid3_0{:}); 
    varargout{1} = cspaired_all_cell;
    varargout{2} = usonly_all_cell;
    varargout{3} = cscatch_all_cell;
    varargout{4} = cspaired_all;
    varargout{5} = usonly_all;
    varargout{6} = cscatch_all;
    varargout{7} = files;
    varargout{8} = directory;
    varargout{9} = trials;
    varargout{10} = date;
end

end