% Upsampling blue rig eyelid traces to match black rig eyelid traces and aligning signals to US onset for visualization

% Written by Kayla Fernando (2/23/23)

close all
clear all
clc

% Load workspace (average eyelid trace for naive, chance, or learned
% condition for each animal in a given experimental condition. 1 row = 1
% animal
load('workspace.mat');
group_learned(group_learned == 0) = NaN;

for n = 1:size(group_learned,1)
    if any(isnan(group_learned(n,:))) == 1
        dataTemp = group_learned(n,1:200);
        dataTempResample = resample(dataTemp,5,3);
        plot(horzcat(zeros(1,60),dataTempResample)); 
        hold on
    else
        plot(group_learned(n,:))
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
xlabel('Frame (realigned)'); ylabel('FEC (resampled)');
hold off
