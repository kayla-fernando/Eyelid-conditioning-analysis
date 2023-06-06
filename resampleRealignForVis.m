%% Upsampling blue rig eyelid traces to match black rig eyelid traces and aligning signals to US onset for visualization %%

% Written by Kayla Fernando (2/23/23)

close all
clear all
clc

% Load workspace (average eyelid trace for naive, intermediate, or learned
% condition for each animal in a given experimental condition. 1 row = 1
% animal
load('workspace.mat');
load('times.mat')
group_learned(group_learned == 0) = NaN;

color = [0.6350 0.0780 0.1840];
r1 = rectangle('Position',[times(68) 0 0.250 1],'FaceColor','b','EdgeColor','none'); hold on
r2 = rectangle('Position',[times(143) 0 0.030 1],'FaceColor','g','EdgeColor','none'); hold on

for n = 1:size(group_learned,1)
    if any(isnan(group_learned(n,:))) == 1
        dataTemp = group_learned(n,1:200);
        dataTempResample = resample(dataTemp,5,3);
        plot(times,horzcat(NaN(1,60),dataTempResample(1,1:274)),'Color',color); 
        hold on
    else
        plot(times,group_learned(n,:),'Color',color)
        hold on
    end
end

xlabel('Time from CS (s)'); ylabel('FEC (resampled)'); ylim([0 1]); set(gca,'ytick',0:0.5:1);
hold off

%% 

% run eyelidSumsAllTrials for a mouse that was trained on different rigs

% for k = 1:length(keep_trials)
%     temp = keep_trials{k};
%     for n = 1:size(temp,1)
%         [row,col] = find(cspaired_all_cell{k} == temp(n,:));
%         t = cspaired_all_cell{k};
%         t(row(1),:)
%         pause
%     end
% end
