%% Upsampling blue rig eyelid traces to match black rig eyelid traces and aligning signals to US onset for visualization

% Written by Kayla Fernando (2/23/23)

close all
clear all
clc

% Load workspace (average eyelid trace for naive, chance, or learned
% condition for each animal in a given experimental condition. 1 row = 1
% animal
load('ISRIB Saline learning epochs.mat');
ISRIB_learned(ISRIB_learned == 0) = NaN;

for n = 1:size(ISRIB_learned,1)
    if any(isnan(ISRIB_learned(n,:))) == 1
        dataTemp = ISRIB_learned(n,1:200);
        dataTempResample = resample(dataTemp,5,3);
        plot(horzcat(zeros(1,60),dataTempResample)); 
        hold on
    else
        plot(ISRIB_learned(n,:))
        hold on
    end
end

if version('-release') == '2017b'
    l1 = line([68 68], [0 1]); set(l1,'color','b'); l2 = line([151 151], [0 1]); set(l2,'color','b');
    l1 = line([143 143], [0 1]); set(l1,'color','g'); l2 = line([153 153], [0 1]); set(l2,'color','g');
else
    xline(gca,68,'b-','Alpha',1); xline(gca,151,'b-','Alpha',1); % 2018b and newer
    xline(gca,143,'g-','Alpha',1); xline(gca,153,'g-','Alpha',1); % 2018b and newer
end

xlim([1 334]); ylim([0 1]);
xlabel('Frame (realigned)'); ylabel('FEC');
hold off

%%

%run eyelidSumsAllTrials for KF52 since it was on different rigs

for k = 1:length(keep_trials)
    temp = keep_trials{k};
    for n = 1:size(temp,1)
        [row,col] = find(cspaired_all_cell{k} == temp(n,:));
        t = cspaired_all_cell{k};
        t(row(1),:)
        pause
    end
end