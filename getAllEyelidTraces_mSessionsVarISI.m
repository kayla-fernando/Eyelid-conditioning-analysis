function varargout = getAllEyelidTraces_mSessionsVarISI(mouse,basepath)
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
    cs1pairedtrials1{k} = find(trials{k}.c_usdur>0 & trials{k}.c_csnum==5 & trials{k}.session_of_day == 1); % CS1-US pairing
    cs1pairedtrials2{k} = find(trials{k}.c_usdur>0 & trials{k}.c_csnum==5 & trials{k}.session_of_day == 2); 
        cs2pairedtrials1{k} = find(trials{k}.c_usdur>0 & trials{k}.c_csnum==6 & trials{k}.session_of_day == 1); % CS2-US pairing
        cs2pairedtrials2{k} = find(trials{k}.c_usdur>0 & trials{k}.c_csnum==6 & trials{k}.session_of_day == 2); 
    cs1catchtrials1{k} = find(trials{k}.c_usdur==0 & trials{k}.c_csnum==5 & trials{k}.session_of_day == 1); % CS1 catch, referred to as "0" in code
    cs1catchtrials2{k} = find(trials{k}.c_usdur==0 & trials{k}.c_csnum==5 & trials{k}.session_of_day == 2);
        cs2catchtrials1{k} = find(trials{k}.c_usdur==0 & trials{k}.c_csnum==6 & trials{k}.session_of_day == 1); % CS2 catch, referred to as "00" in code
        cs2catchtrials2{k} = find(trials{k}.c_usdur==0 & trials{k}.c_csnum==6 & trials{k}.session_of_day == 2);

    eyelid1_5_1{k} = trials{k}.eyelidpos(cs1pairedtrials1{k},:);
    eyelid1_5_2{k} = trials{k}.eyelidpos(cs1pairedtrials2{k},:);
        eyelid1_6_1{k} = trials{k}.eyelidpos(cs2pairedtrials1{k},:);
        eyelid1_6_2{k} = trials{k}.eyelidpos(cs2pairedtrials2{k},:);
    eyelid1_0_1{k} = trials{k}.eyelidpos(cs1catchtrials1{k},:);
    eyelid1_0_2{k} = trials{k}.eyelidpos(cs1catchtrials2{k},:);
        eyelid1_00_1{k} = trials{k}.eyelidpos(cs2catchtrials1{k},:);
        eyelid1_00_2{k} = trials{k}.eyelidpos(cs2catchtrials2{k},:);
    
    calibmin1{k} = min(eyelid{k});
    calibmin{k} = min(calibmin1{k}); % use only the most extreme value from all trials
    
    eyelid2_5_1{k} = eyelid1_5_1{k}-calibmin{k};
    eyelid2_5_2{k} = eyelid1_5_2{k}-calibmin{k};
        eyelid2_6_1{k} = eyelid1_6_1{k}-calibmin{k};
        eyelid2_6_2{k} = eyelid1_6_2{k}-calibmin{k};
    eyelid2_0_1{k} = eyelid1_0_1{k}-calibmin{k};
    eyelid2_0_2{k} = eyelid1_0_2{k}-calibmin{k};
        eyelid2_00_1{k} = eyelid1_00_1{k}-calibmin{k};
        eyelid2_00_2{k} = eyelid1_00_2{k}-calibmin{k};
    eyelid2_all{k} = eyelid{k}-calibmin{k};
    
    calibmax1{k} = max(eyelid2_all{k});
    calibmax{k} = max(calibmax1{k}); % use only the most extreme value from all trials
    
    eyelid3_5_1{k} = eyelid2_5_1{k}./calibmax{k}; % normalized CS1-US eyelid traces
    eyelid3_5_2{k} = eyelid2_5_2{k}./calibmax{k};
        eyelid3_6_1{k} = eyelid2_6_1{k}./calibmax{k}; % normalized CS2-US eyelid traces
        eyelid3_6_2{k} = eyelid2_6_2{k}./calibmax{k};
    eyelid3_0_1{k} = eyelid2_0_1{k}./calibmax{k}; % normalized CS1 eyelid traces
    eyelid3_0_2{k} = eyelid2_0_2{k}./calibmax{k};
        eyelid3_00_1{k} = eyelid2_00_1{k}./calibmax{k}; % normalized CS2 eyelid traces
        eyelid3_00_2{k} = eyelid2_00_2{k}./calibmax{k};

    cs1paired_all = vertcat(eyelid3_5_1{:},eyelid3_5_2{:}); % each row is a trial and each column is eyelid position
        cs2paired_all = vertcat(eyelid3_6_1{:},eyelid3_6_2{:}); 
    cs1catch_all = vertcat(eyelid3_0_1{:},eyelid3_0_2{:}); 
        cs2catch_all = vertcat(eyelid3_00_1{:},eyelid3_00_2{:});
    
    % Get the dates
    date{k} = directory(k+2).name; 
end

for ii = 1:length(eyelid3_5_2)
    if ~isempty(eyelid3_5_2{ii}) == 1
        cs1paired_all_cell{ii} = vertcat(eyelid3_5_1{ii},eyelid3_5_2{ii});
    else
        cs1paired_all_cell = eyelid3_5_1; % cell format, each row is a trial and each column is eyelid position
    end
end

for ii = 1:length(eyelid3_6_2)
    if ~isempty(eyelid3_6_2{ii}) == 1
        cs2paired_all_cell{ii} = vertcat(eyelid3_6_1{ii},eyelid3_6_2{ii});
    else
        cs2paired_all_cell = eyelid3_6_1; % cell format, each row is a trial and each column is eyelid position
    end
end

for ii = 1:length(eyelid3_0_2)
    if ~isempty(eyelid3_0_2{ii}) == 1
        cs1catch_all_cell{ii} = vertcat(eyelid3_0_1{ii},eyelid3_0_2{ii});
    else
        cs1catch_all_cell = eyelid3_0_1;
    end
    
end

for ii = 1:length(eyelid3_00_2)
    if ~isempty(eyelid3_00_2{ii}) == 1
        cs2catch_all_cell{ii} = vertcat(eyelid3_00_1{ii},eyelid3_00_2{ii});
    else
        cs2catch_all_cell = eyelid3_00_1;
    end
    
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