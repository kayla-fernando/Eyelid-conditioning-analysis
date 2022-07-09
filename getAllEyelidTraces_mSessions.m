function varargout = getAllEyelidTraces_mSessions(mouse,basepath)
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
    cspairedtrials1{k} = find(trials{k}.c_usdur>0 & trials{k}.c_csnum==5 & trials{k}.session_of_day == 1); % CS-US pairing
    cspairedtrials2{k} = find(trials{k}.c_usdur>0 & trials{k}.c_csnum==5 & trials{k}.session_of_day == 2); 
    ustrials1{k} = find(trials{k}.c_csnum==7 & trials{k}.session_of_day == 1); % US only
    ustrials2{k} = find(trials{k}.c_csnum==7 & trials{k}.session_of_day == 2);
    catchtrials1{k} = find(trials{k}.c_usdur==0 & trials{k}.c_csnum==5 & trials{k}.session_of_day == 1); % CS catch, referred to as "0" in code
    catchtrials2{k} = find(trials{k}.c_usdur==0 & trials{k}.c_csnum==5 & trials{k}.session_of_day == 2);

    eyelid1_5_1{k} = trials{k}.eyelidpos(cspairedtrials1{k},:);
    eyelid1_5_2{k} = trials{k}.eyelidpos(cspairedtrials2{k},:);
    eyelid1_7_1{k} = trials{k}.eyelidpos(ustrials1{k},:);
    eyelid1_7_2{k} = trials{k}.eyelidpos(ustrials2{k},:);
    eyelid1_0_1{k} = trials{k}.eyelidpos(catchtrials1{k},:);
    eyelid1_0_2{k} = trials{k}.eyelidpos(catchtrials2{k},:);
    
    calibmin1{k} = min(eyelid{k});
    calibmin{k} = min(calibmin1{k}); % use only the most extreme value from all trials
    
    eyelid2_5_1{k} = eyelid1_5_1{k}-calibmin{k};
    eyelid2_5_2{k} = eyelid1_5_2{k}-calibmin{k};
    eyelid2_7_1{k} = eyelid1_7_1{k}-calibmin{k};
    eyelid2_7_2{k} = eyelid1_7_2{k}-calibmin{k};
    eyelid2_0_1{k} = eyelid1_0_1{k}-calibmin{k};
    eyelid2_0_2{k} = eyelid1_0_2{k}-calibmin{k};
    eyelid2_all{k} = eyelid{k}-calibmin{k};
    
    calibmax1{k} = max(eyelid2_all{k});
    calibmax{k} = max(calibmax1{k}); % use only the most extreme value from all trials
    
    eyelid3_5_1{k} = eyelid2_5_1{k}./calibmax{k}; % normalized CS-US eyelid traces
    eyelid3_5_2{k} = eyelid2_5_2{k}./calibmax{k};
    eyelid3_7_1{k} = eyelid2_7_1{k}./calibmax{k}; % normalized US eyelid traces
    eyelid3_7_2{k} = eyelid2_7_2{k}./calibmax{k};
    eyelid3_0_1{k} = eyelid2_0_1{k}./calibmax{k}; % normalized CS eyelid traces
    eyelid3_0_2{k} = eyelid2_0_2{k}./calibmax{k};

    cspaired_all = vertcat(eyelid3_5_1{:},eyelid3_5_2{:}); % each row is a trial and each column is eyelid position
    usonly_all = vertcat(eyelid3_7_1{:},eyelid3_7_2{:}); 
    cscatch_all = vertcat(eyelid3_0_1{:},eyelid3_0_2{:}); 
    
    % Get the dates
    date{k} = directory(k+2).name; 
end

for ii = 1:length(eyelid3_5_2)
    if ~isempty(eyelid3_5_2{ii}) == 1
        cspaired_all_cell{ii} = vertcat(eyelid3_5_1{ii},eyelid3_5_2{ii});
    else
        cspaired_all_cell = eyelid3_5_1; % cell format, each row is a trial and each column is eyelid position
    end
end

for ii = 1:length(eyelid3_7_2)
    if ~isempty(eyelid3_7_2{ii}) == 1
        usonly_all_cell{ii} = vertcat(eyelid3_7_1{ii},eyelid3_7_2{ii});
    else
        usonly_all_cell = eyelid3_7_1;
    end
end

for ii = 1:length(eyelid3_0_2)
    if ~isempty(eyelid3_0_2{ii}) == 1
        cscatch_all_cell{ii} = vertcat(eyelid3_0_1{ii},eyelid3_0_2{ii});
    else
        cscatch_all_cell = eyelid3_0_1;
    end
    
end

if nargout == 3
    varargout{1} = cspaired_all_cell;
    varargout{2} = usonly_all_cell;
    varargout{3} = cscatch_all_cell;
elseif nargout == 7
    varargout{1} = cspaired_all_cell;
    varargout{2} = usonly_all_cell;
    varargout{3} = cscatch_all_cell;
    varargout{4} = cspaired_all;
    varargout{5} = usonly_all;
    varargout{6} = cscatch_all;
    varargout{7} = date;
elseif nargout > 7
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