%% Binned CRprobs and CRamps across all trials %%

% Written by Kayla Fernando (7/10/22)

clear all
close all
clc

mouse = 'KF18'; 
basepath = 'Y:\\All_Staff\home\kayla\Eyelid conditioning\';

prompt = input('Does this mouse have multiple sessions at any point during training? ("1" for yes, "0" for no) ');
switch prompt
    % If mouse has no multiple sessions at any point during training:
    case 0 
        prompt1 = input('Was this mouse trained on the same rig throughout training? ("1" for yes, "0" for no) ');
        switch prompt1
            % If not trained on the same rig throughout training:
            case 0 
                % Normalize eyelid traces
                [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,files,directory,trials,date] = getAllEyelidTraces(mouse,basepath);
                % Generate a list of which rig was used on each day for appropriate plotting parameters
                for k = 1:length(files)
                    r = input(['"1" for BLACK rig or "0" for BLUE rig on ' num2str(date{k}) ': '],"s");
                    if strcmp(r,'1') == 1
                        rig{k} = 'black'; 
                    elseif strcmp(r,'0') == 1 
                        rig{k} = 'blue'; 
                    end
                end
                % Rename eyelid traces
                [conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,files,date] = renameEyelidTraces(cspaired_all_cell,usonly_all_cell,cscatch_all_cell,rig,files,directory,1);
            % If trained on the same rig throughout training:
            case 1 
                prompt2 = input('Which rig? ("1" for BLACK, "0" for BLUE) ');
                switch prompt2
                    % Blue rig throughout all of training
                    case 0
                        % Normalize, rename, and plot average eyelid traces of all trial types for each session
                        [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,cspaired_all,usonly_all,cscatch_all,files,directory,trials,date] = getAllEyelidTraces(mouse,basepath);
                        rig = cell(1,length(files)); rig(1,1:length(files)) = {'blue'};
                        [conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,files,date] = renameEyelidTraces(cspaired_all_cell,usonly_all_cell,cscatch_all_cell,rig,files,directory,1);
                    % Black rig throughout all of training
                    case 1         
                        % Normalize, rename, and plot average eyelid traces of all trial types for each session
                        [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,cspaired_all,usonly_all,cscatch_all,files,directory,trials,date] = getAllEyelidTraces(mouse,basepath);
                        rig = cell(1,length(files)); rig(1,1:length(files)) = {'black'};
                        [conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,files,date] = renameEyelidTraces(cspaired_all_cell,usonly_all_cell,cscatch_all_cell,rig,files,directory,1);
                end
        end
    % If mouse has multiple sessions at any point during training:    
    case 1
        prompt1 = input('Was this mouse trained on the same rig throughout training? ("1" for yes, "0" for no) ');
        switch prompt1
            % If not trained on the same rig throughout training:
            case 0 
                % Normalize eyelid traces, combining multiple sessions on a given day if necessary
                [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,files,directory,trials,date] = getAllEyelidTraces_mSessions(mouse,basepath);
                % Generate a list of which rig was used for each day for appropriate plotting parameters
                for k = 1:length(files)
                    r = input(['"1" for BLACK rig or "0" for BLUE rig on ' num2str(date{k}) ': '],"s")
                    if strcmp(r,'1') == 1
                        rig{k} = 'black'; 
                    elseif strcmp(r,'0') == 1 
                        rig{k} = 'blue'; 
                    end
                end
                % Rename eyelid traces
                [conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,files,date] = renameEyelidTraces(cspaired_all_cell,usonly_all_cell,cscatch_all_cell,rig,files,directory,1);
           % If trained on the same rig throughout training:
            case 1 
                prompt2 = input('Which rig? ("1" for BLACK, "0" for BLUE) ');
                switch prompt2
                    % Blue rig throughout all of training
                    case 0
                        % Normalize, rename, and plot average eyelid traces of all trial types for each session, combining multiple sessions on a given day if necessary
                        [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,cspaired_all,usonly_all,cscatch_all,files,directory,trials,date] = getAllEyelidTraces_mSessions(mouse,basepath);
                        rig = cell(1,length(files)); rig(1,1:length(files)) = {'blue'};
                        [conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,files,date] = renameEyelidTraces(cspaired_all_cell,usonly_all_cell,cscatch_all_cell,rig,files,directory,1);
                  % Black rig throughout all of training
                    case 1
                        % Normalize, rename, and plot average eyelid traces of all trial types for each session, combining multiple sessions on a given day if necessary
                        [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,cspaired_all,usonly_all,cscatch_all,files,directory,trials,date] = getAllEyelidTraces_mSessions(mouse,basepath);
                        rig = cell(1,length(files)); rig(1,1:length(files)) = {'black'};
                        [conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,files,date] = renameEyelidTraces(cspaired_all_cell,usonly_all_cell,cscatch_all_cell,rig,files,directory,1);
              end
        end    
end

% Define trial type to analyze
if numel(unique(rig)) == 1
    trialType = cspaired_all;
elseif numel(unique(rig)) > 1
    trialType = cspaired_all_cell;
end

% Define the block parameters (m rows by n cols block). We will average every m trials
for k = 1:length(files)
    if strcmp(rig{k},'black') == 1
        blockSize{k} = [100 334];
    elseif strcmp(rig{k},'blue') == 1
        blockSize{k} = [100 200];
    end
end

% Block process the array to replace every element in the 100 element-wide block by the mean of the values in the block
    % First, define the averaging function for use by blockproc()
    meanFilterFunction = @(block_struct) mean(block_struct.data);
    % Now do the actual averaging (block average down to smaller size array)
    if numel(unique(rig)) == 1
        for k = 1:length(files)
            blockAveragedDownSignal = blockproc(trialType, blockSize{k}, meanFilterFunction);
        end
        % Let's check the output size
        [bins, frames] = size(blockAveragedDownSignal)
    elseif numel(unique(rig)) > 1
        for k = 1:length(files)
            blockAveragedDownSignal{k} = blockproc(trialType{k}, blockSize{k}, meanFilterFunction);
            frames(k) = size(blockAveragedDownSignal{k},2);
        end
        % Let's check the output size
        bins = size(blockAveragedDownSignal{1},1)
        frames = unique(frames)
    end
       
    % Also define the summation function for use by blocproc()
    sumFunction = @(block_struct) sum(block_struct.data);
    
if numel(unique(rig)) == 1
    % Binned CRamp
        if strcmp(rig,'black') == 1
            win = [126,127,128,129];
            cramp = mean(trialType(:,win),2) - mean(trialType(:,1:66),2); 
        elseif strcmp(rig,'blue') == 1
            win = [35,36,37,38];
            cramp = mean(trialType(:,win),2) - mean(trialType(:,1:10),2); 
        end
        blockSize2 = [100, 1];
        CRamps = blockproc(cramp, blockSize2, meanFilterFunction);
    % Binned CRprob
        cramp2 = cramp>0.1;
        blockSums = blockproc(cramp2, blockSize2, sumFunction);
        for k = 1:length(files)
            blockSizeTemp = blockSize{k};
            CRprobs = blockSums./blockSizeTemp(1);
        end
elseif numel(unique(rig)) > 1
    for k = 1:length(files)
        % Binned CRamp
            if strcmp(rig{k},'black') == 1
                win{k} = [126,127,128,129];
                trialTypeTemp = trialType{k};
                cramp{k} = mean(trialTypeTemp(:,win{k}),2) - mean(trialTypeTemp(:,1:66),2); 
            elseif strcmp(rig{k},'blue') == 1
                win{k} = [35,36,37,38];
                trialTypeTemp = trialType{k};
                cramp{k} = mean(trialTypeTemp(:,win{k}),2) - mean(trialTypeTemp(:,1:10),2); 
            end
    end
            cramp = vertcat(cramp{:});
            blockSize2 = [100, 1];
            CRamps = blockproc(cramp, blockSize2, meanFilterFunction);
        % Binned CRprob
            cramp2 = cramp>0.1;
            blockSums = blockproc(cramp2, blockSize2, sumFunction);
            for k = 1:length(files)
                blockSizeTemp = blockSize{k};
                CRprobs = blockSums./blockSizeTemp(1);
            end
end

[h,hf1,hf2] = plotBlockProcessedTrials(blockAveragedDownSignal,mouse,rig,files,trials,blockSizeTemp,CRamps,CRprobs);