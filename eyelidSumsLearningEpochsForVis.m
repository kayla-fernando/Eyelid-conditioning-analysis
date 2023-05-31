%% eyelidSumsLearningEpochsForVis %%
% Plot representative eyelid traces for the naive, chance, and learned conditions

% Written by Kayla Fernando (3/15/23)

% Notes:
%   - timescale of eyelid traces may differ if a mouse was on different rigs throughout training
%   - originally tried to make this a function, but Matlab's Code Analyzer reports an error with the "mean" function used to calculate naive/intermediate/learned average eyelid trace 
%   - kept as a separate script, run eyelidSumsAllTrials for one animal first to have the necessary inputs

% Average of n trials for each epoch depending on trial type
if numel(unique(rig)) == 1
    if size(trialType,1) == size(cspaired_all,1)
        n = 100;
    elseif size(trialType,1) == size(cscatch_all,1) 
        n = 10;
    end
elseif numel(unique(rig)) > 1
    if cellfun(@isequal,trialType,cspaired_all_cell)
        n = 100;
    elseif cellfun(@isequal,trialType,cscatch_all_cell)
        n = 10;
    end
end

% If same rig throughout training
if numel(unique(rig)) == 1
    if size(trialType,1) < 200
        naiveBlock = 1; naive = mean(trialType(1:20,:)); 
        intBlock = 1; intermediate = mean(trialType((end/2)-10:(end/2)+10,:));
        learnedBlock = 1; learned = mean(trialType(end-20:end,:));
    else
        % average n trials for naive
        naiveBlock = find(CRprobs == min(CRprobs),1,'first');
        naive = mean(trialType((naiveBlock*n)-n+1:naiveBlock*n,:)); 
        % average n trials for intermediate
        intBlock = find(CRprobs >= max(CRprobs)/2,1,'first'); 
        intermediate = mean(trialType((intBlock*n)-n:intBlock*n,:));
        % average n trials for learned
        learnedBlock = find(CRprobs == max(CRprobs),1,'first');
        learned = mean(trialType((learnedBlock*n)-n:learnedBlock*n,:));
    end
% If different rigs throughout training
elseif numel(unique(rig)) > 1
    for k = 1:length(trialType)
        trialSize{k} = size(trialType{k},1);
    end
    trialSize = cell2mat(trialSize);
    trialSize = sum(trialSize);
    if trialSize < 200
        naiveBlock = 1; naive = mean(trialType{1}); 
        intBlock = 1; intermediate = mean(trialType{round(end/2)});
        learnedBlock = 1; learned = mean(trialType{end});
    else
    % average n trials for naive
    naiveBlock = find(CRprobs == min(CRprobs),1,'first'); 
        if size(trialType{naiveBlock},1) < n & size(trialType{naiveBlock},2) == size(trialType{naiveBlock+1},2)
            naiveBlockTemp = vertcat(trialType{naiveBlock},trialType{naiveBlock+1});
            naive = mean(naiveBlockTemp((naiveBlock*n)-n+1:naiveBlock*n,:));
        elseif size(trialType{naiveBlock},1) < n & size(trialType{naiveBlock},2) ~= size(trialType{naiveBlock+1},2)
            disp('Manually select the next cells with the same col dimension for vertical concatenation and rerun the conditional')
        else
            naive = mean(trialType{naiveBlock}((naiveBlock*n)-n+1:naiveBlock*n,:));
        end
    % average n trials for intmermediate    
    intBlock = find(CRprobs >= max(CRprobs)/2,1,'first');
        for k = 1:length(trialType)
            trialSize(k) = size(trialType{k},1); 
        end
        trialSize = cumsum(trialSize);
        idxInt = find(trialSize >= intBlock*n,1,'first');
        if size(trialType{idxInt},1) < n && size(trialType{idxInt-1},2) == size(trialType{idxInt},2)
            intBlockTemp = vertcat(trialType{idxInt-1},trialType{idxInt});
            intermediate = mean(intBlockTemp(1:n),:); 
        elseif size(trialType{idxInt},1) < n && size(trialType{idxInt-1},2) ~= size(trialType{idxInt},2)
            disp('Manually select the next cells with the same col dimension for vertical concatenation and rerun the conditional')
        else
            intermediate = mean(trialType{idxInt}(1:n,:));
        end
    % average n trials for learned    
    learnedBlock = find(CRprobs == max(CRprobs),1,'first');
        for k = 1:length(trialType)
           trialSize(k) = size(trialType{k},1);
        end
        trialSize = cumsum(trialSize);
        idxLearned = find(trialSize >= learnedBlock*n,1,'first');
        if size(trialType{idxLearned},1) < n && size(trialType{idxLearned-1},2) == size(trialType{idxLearned},2)
           learnedBlockTemp = vertcat(trialType{idxLearned-1},trialType{idxLearned}); %#ok<*NASGU>
           learned = mean(intBlockTemp(1:n),:);
        elseif size(trialType{idxLearned},1) < n && size(trialType{idxLearned-1},2) ~= size(trialType{idxLearned},2)
           disp('Manually select the next cells with the same col dimension for vertical concatenation and rerun the conditional')
        else
           learned = mean(trialType{idxLearned}(1:n,:));
        end
    end
end

% Plot average eyelid traces for the naive, intermediate, and learned conditions
times = trials{end}.tm(1,:);
plot(times,naive); hold on
plot(times,intermediate);
plot(times,learned); hold off
xlabel('Time from CS (s)'); ylabel('FEC'); ylim([0 1]);
legend(['naive (CRprob = ' num2str(CRprobs(naiveBlock)) ')'],...
       ['intermediate (CRprob = ' num2str(CRprobs(intBlock)) ')'],...
       ['learned (CRprob = ' num2str(CRprobs(learnedBlock)) ')']);
title([mouse ' average eyelid traces across learning epochs']);
