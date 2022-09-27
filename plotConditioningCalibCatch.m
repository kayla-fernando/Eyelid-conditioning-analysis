function [ax5,ax6,ax7,win] = plotConditioningCalibCatch(conditioning_trials,calib_trials,catch_trials,eyelid3_5_trials,eyelid3_7_trials,eyelid3_0_trials,mouse,rig,win,files,trials,date,first_analysis_day)
% Plotting average eyelid traces for CS-US trials, US-only trials, and CS-catch trials across sessions

% Written by Kayla Fernando (7/8/22)

for k = first_analysis_day:length(files)
    % CS-US trials
    ax5 = subplot(3,1,1); 
    plot(conditioning_trials{1, k}); 
    if strcmp(rig{k},'black') == 1
        xline(gca,68,'b-','Alpha',1); xline(gca,151,'b-','Alpha',1); % 2018b and newer
        xline(gca,143,'g-','Alpha',1); xline(gca,153,'g-','Alpha',1); % 2018b and newer
%     l1 = line([68 68], [0 1]); set(l1,'color','b'); l2 = line([151 151], [0 1]); set(l2,'color','b');
%     l1 = line([143 143], [0 1]); set(l1,'color','g'); l2 = line([153 153], [0 1]); set(l2,'color','g');
    elseif strcmp(rig{k},'blue') == 1
        xline(gca,24,'b-','Alpha',1); xline(gca,53,'b-','Alpha',1); % 2018b and newer
        xline(gca,51,'g-','Alpha',1); xline(gca,54,'g-','Alpha',1); % 2018b and newer
%     l1 = line([24 24], [0 1]); set(l1,'color','b'); l2 = line([53 53], [0 1]); set(l2,'color','b');
%     l1 = line([51 51], [0 1]); set(l1,'color','g'); l2 = line([54 54], [0 1]); set(l2,'color','g');
    end
    title([mouse ' ' num2str(date{k}) ' (Day ' num2str(k) ') average of ' num2str(size(eyelid3_5_trials{k},1)) ' CS-US trials']);  
    ylabel('FEC'); 
    xlim([0 size(trials{1,1}.tm,2)]); ylim([0 1]);

    % US-only trials
    ax6 = subplot(3,1,2); 
    plot(calib_trials{1, k}); 
    if strcmp(rig{k},'black') == 1
        xline(gca,143,'g-','Alpha',1); xline(gca,153,'g-','Alpha',1); % 2018b and newer
%     l1 = line([143 143], [0 1]); set(l1,'color','g'); l2 = line([153 153], [0 1]); set(l2,'color','g');
    elseif strcmp(rig{k},'blue') == 1
        xline(gca,51,'g-','Alpha',1); xline(gca,54,'g-','Alpha',1); % 2018b and newer
%     l1 = line([51 51], [0 1]); set(l1,'color','g'); l2 = line([54 54], [0 1]); set(l2,'color','g');
    end
    title([mouse ' ' num2str(date{k}) ' (Day ' num2str(k) ') average of ' num2str(size(eyelid3_7_trials{k},1)) ' US-only trials']); 
    ylabel('FEC'); 
    xlim([0 size(trials{1,1}.tm,2)]); ylim([0 1]);

    % CS-catch trials
    ax7 = subplot(3,1,3); 
    plot(catch_trials{1, k}); 
    if strcmp(rig{k},'black') == 1
        xline(gca,68,'b-','Alpha',1); xline(gca,151,'b-','Alpha',1); % 2018b and newer
%     l1 = line([68 68], [0 1]); set(l1,'color','b'); l2 = line([151 151], [0 1]); set(l2,'color','b');
    elseif strcmp(rig{k},'blue') == 1
        xline(gca,24,'b-','Alpha',1); xline(gca,53,'b-','Alpha',1); % 2018b and newer
%     l1 = line([24 24], [0 1]); set(l1,'color','b'); l2 = line([53 53], [0 1]); set(l2,'color','b');
    end
    title([mouse ' ' num2str(date{k}) ' (Day ' num2str(k) ') average of ' num2str(size(eyelid3_0_trials{k},1)) ' CS-catch trials']); 
    xlabel('Frame'); ylabel('FEC');  
    xlim([0 size(trials{1,1}.tm,2)]); ylim([0 1]);

    linkaxes([ax5, ax6, ax7], 'x');
    
    pause
end
