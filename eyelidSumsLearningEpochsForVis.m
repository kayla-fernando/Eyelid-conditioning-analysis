%% eyelidSumsLearningEpochsForVis %%
% Plot representative eyelid traces for the naive, chance, and learned conditions

% Written by Kayla Fernando (2/23/23)

% Notes:
%   - timescale of eyelid traces may differ if a mouse was on different rigs throughout training
%   - originally tried to make this a function, but Matlab's Code Analyzer reports an error with the "mean" function used to calculate naive/chance/learned average eyelid trace 
%   - kept as a separate script, run eyelidSumsAllTrials for one animal first to have the necessary inputs

% If same rig throughout training
if numel(unique(rig)) == 1
    % average 100 trials for naive
    naiveBlock = find(CRprobs == min(CRprobs),1,'first');
        naive = mean(trialType((naiveBlock*100)-100+1:naiveBlock*100,:)); 
    % average 100 trials for chance
    chanceBlock = find(CRprobs >= max(CRprobs)/2,1,'first'); 
        chance = mean(trialType((chanceBlock*100)-100:chanceBlock*100,:));
    % average 100 trials for learned
    learnedBlock = find(CRprobs == max(CRprobs),1,'first');
        learned = mean(trialType((learnedBlock*100)-100:learnedBlock*100,:));
% If different rigs throughout training
elseif numel(unique(rig)) > 1
    % average 100 trials for naive
    naiveBlock = find(CRprobs == min(CRprobs),1,'first'); 
        if size(trialType{naiveBlock},1) < 100 & size(trialType{naiveBlock},2) == size(trialType{naiveBlock+1},2)
            naiveBlockTemp = vertcat(trialType{naiveBlock},trialType{naiveBlock+1});
            naive = mean(naiveBlockTemp((naiveBlock*100)-100+1:naiveBlock*100,:));
        elseif size(trialType{naiveBlock},1) < 100 & size(trialType{naiveBlock},2) ~= size(trialType{naiveBlock+1},2)
            disp('Manually select the next cells with the same col dimension for vertical concatenation and rerun the conditional')
        else
            naive = mean(trialType{naiveBlock}((naiveBlock*100)-100+1:naiveBlock*100,:));
        end
    % average 100 trials for chance    
    chanceBlock = find(CRprobs >= max(CRprobs)/2,1,'first');
        for k = 1:length(trialType)
            trialSize(k) = size(trialType{k},1); 
        end
        trialSize = cumsum(trialSize);
        idxChance = find(trialSize >= chanceBlock*100,1,'first');
        if size(trialType{idxChance},1) < 100 && size(trialType{idxChance-1},2) == size(trialType{idxChance},2)
            chanceBlockTemp = vertcat(trialType{idxChance-1},trialType{idxChance});
            chance = mean(chanceBlockTemp(1:100),:); 
        elseif size(trialType{idxChance},1) < 100 && size(trialType{idxChance-1},2) ~= size(trialType{idxChance},2)
            disp('Manually select the next cells with the same col dimension for vertical concatenation and rerun the conditional')
        else
            chance = mean(trialType{idxChance}(1:100,:));
        end
    % average 100 trials for learned    
    learnedBlock = find(CRprobs == max(CRprobs),1,'first');
        for k = 1:length(trialType)
           trialSize(k) = size(trialType{k},1);
        end
        trialSize = cumsum(trialSize);
        idxLearned = find(trialSize >= learnedBlock*100,1,'first');
        if size(trialType{idxLearned},1) < 100 && size(trialType{idxLearned-1},2) == size(trialType{idxLearned},2)
           learnedBlockTemp = vertcat(trialType{idxLearned-1},trialType{idxLearned}); %#ok<*NASGU>
           learned = mean(chanceBlockTemp(1:100),:);
        elseif size(trialType{idxLearned},1) < 100 && size(trialType{idxLearned-1},2) ~= size(trialType{idxLearned},2)
           disp('Manually select the next cells with the same col dimension for vertical concatenation and rerun the conditional')
        else
           learned = mean(trialType{idxLearned}(1:100,:));
        end
end

% Plot average eyelid traces for the naive, chance, and learned conditions
plot(naive); hold on
plot(chance);
plot(learned); hold off
xlabel('Frame'); ylabel('FEC'); ylim([0 1]);
legend(['naive (CRprob = ' num2str(CRprobs(naiveBlock)) ')'],...
       ['chance (CRprob = ' num2str(CRprobs(chanceBlock)) ')'],...
       ['learned (CRprob = ' num2str(CRprobs(learnedBlock)) ')']);
title([mouse ' average eyelid traces across learning epochs']);
