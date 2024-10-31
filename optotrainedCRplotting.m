%% One animal concatenate all CS-US trials, all sessions

close all
clear all
clc

mouse = 'mouse'; 
basepath = 'Z:\\';
% [cspaired_all_cell,usonly_all_cell,cscatch_all_cell,cspaired_all,usonly_all,cscatch_all,files,directory,trials,date] = getAllEyelidTraces(mouse,basepath);
[cs1paired_all_cell,cs1catch_all_cell,cs2paired_all_cell,cs2catch_all_cell,cs1paired_all,cs1catch_all,cs2paired_all,cs2catch_all,...
                            files,directory,trials,date] = getAllEyelidTracesVarISI(mouse,basepath);
rig = cell(1,length(files)); rig(1,1:length(files)) = {'blue'};
% [conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,files,date] = renameEyelidTraces(cspaired_all_cell,usonly_all_cell,cscatch_all_cell,rig,files,directory,1);
[CS1_conditioning_trials,CS1_catch_trials,CS2_conditioning_trials,CS2_catch_trials,...
                            eyelid3_5_trials,eyelid3_0_trials,eyelid3_6_trials,eyelid3_00_trials,files,date] = ...
                            renameEyelidTracesVarISI(cs1paired_all_cell,cs1catch_all_cell,cs2paired_all_cell,cs2catch_all_cell,...
                            rig,files,directory,1);

%% One animal concatenate all CS-US trials, all sessions

meanFilterFunction = @(block_struct) mean(block_struct.data);
blockSize = [50 200];
blockAveragedDownSignal = blockproc(cs2paired_all, blockSize, meanFilterFunction);
gifFile = [mouse ' CS-US eyelid traces.gif']; % comment/uncomment line 36 for optional gif generation
for n = 1:size(blockAveragedDownSignal,1)
    plot(blockAveragedDownSignal(n,:)); ylim([0 1]); hold on
    CS_col_1 = 24;  % frame
    CS_col_2 = 79.5; % 53.5; % frame
    xline(CS_col_1,'b-','Alpha',1,'LineWidth',1.5); xline(CS_col_2,'b-','Alpha',1,'LineWidth',1.5); 
    US_col_1 = 80; % 54; % frame
    US_col_2 = 83; % 57; % frame
    xline(US_col_1,'g-','Alpha',1,'LineWidth',1.5); xline(US_col_2,'g-','Alpha',1,'LineWidth',1.5); 
    hold off
    title(['Bin # ' num2str(n) ' (' num2str(blockSize(1)) ' trials each)']);
    %pause
    exportgraphics(gcf,gifFile,Append=true); % comment/uncomment line 24 for optional gif generation
end
hold off

%% One animal concatenate all CS catch trials, all sessions

meanFilterFunction = @(block_struct) mean(block_struct.data);
blockSize = [5 200];
blockAveragedDownSignal = blockproc(cs2catch_all, blockSize, meanFilterFunction);
gifFile = [mouse ' CS-catch eyelid traces.gif']; % comment/uncomment line 52 for optional gif generation
for n = 1:size(blockAveragedDownSignal,1)
    plot(blockAveragedDownSignal(n,:)); ylim([0 1]); hold on
    CS_col_1 = 24;  % frame
    CS_col_2 = 79.5; % 53.5; % frame
    xline(CS_col_1,'b-','Alpha',1,'LineWidth',1.5); xline(CS_col_2,'b-','Alpha',1,'LineWidth',1.5);
    hold off
    title(['Bin # ' num2str(n) ' (' num2str(blockSize(1)) ' trials each)']);
    %pause
    exportgraphics(gcf,gifFile,Append=true); % comment/uncomment line 43 for optional gif generation
end
hold off

%% One animal single session, CS-US trials

% manually load trialdata.mat for a single session from one animal
pairedtrials = find(trials.c_usdur>0 & trials.c_csnum==5);
idx = 1:length(pairedtrials);
eyelid1 = trials.eyelidpos(pairedtrials,:);
calibmin1 = min(eyelid1');
calibmin = min(calibmin1); %use only most extreme value from all trials
eyelid2 = eyelid1-calibmin;
calibmax1 = max(eyelid2');
calibmax = max(calibmax1); %use only most extreme value from all trials
eyelid3 = eyelid2./calibmax;

meanFilterFunction = @(block_struct) mean(block_struct.data);
blockSize = [5 200];
blockAveragedDownSignal = blockproc(eyelid3, blockSize, meanFilterFunction);
for n = 1:size(blockAveragedDownSignal,1)
    plot(blockAveragedDownSignal(n,:)); ylim([0 1]); hold on
    CS_col_1 = 24;  % frame
    CS_col_2 = 53.5; % frame
    xline(CS_col_1,'b-','Alpha',1,'LineWidth',1.5); xline(CS_col_2,'b-','Alpha',1,'LineWidth',1.5); 
    US_col_1 = 54; % frame
    US_col_2 = 57; % frame
    xline(US_col_1,'g-','Alpha',1,'LineWidth',1.5); xline(US_col_2,'g-','Alpha',1,'LineWidth',1.5); 
    hold off
    title(['Bin # ' num2str(n) ' (' num2str(blockSize(1)) ' trials each)']);
    pause
end
hold off

%% One animal single session, CS catch trials

% manually load trialdata.mat for a single session from one animal
catchtrials = find(trials.c_usdur==0 & trials.c_csnum==5);
idx = 1:length(catchtrials);
eyelid1 = trials.eyelidpos(catchtrials,:);
calibmin1 = min(eyelid1');
calibmin = min(calibmin1); %use only most extreme value from all trials
eyelid2 = eyelid1-calibmin;
calibmax1 = max(eyelid2');
calibmax = max(calibmax1); %use only most extreme value from all trials
eyelid3 = eyelid2./calibmax;

for n = 1:size(eyelid3,1)
    plot(eyelid3(n,:)); ylim([0 1]); hold on
    CS_col_1 = 24;  % frame
    CS_col_2 = 53.5; % frame
    xline(CS_col_1,'b-','Alpha',1,'LineWidth',1.5); xline(CS_col_2,'b-','Alpha',1,'LineWidth',1.5);
    hold off
    title(['Catch trial # ' num2str(n)]);
    pause
end
hold off
